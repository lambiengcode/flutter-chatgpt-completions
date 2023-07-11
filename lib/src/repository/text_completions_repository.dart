// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:developer';

// Package imports:
import 'package:chatgpt_completions/src/constants/constants.dart';
import 'package:chatgpt_completions/src/constants/endpoints.dart';
import 'package:chatgpt_completions/src/models/chatgpt_params.dart';
import 'package:chatgpt_completions/src/repository/text_completions_repository_interface.dart';
import 'package:chatgpt_completions/src/services/decoder_queue.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class TextCompletionsRepository extends TextCompletionsRepositoryInterface {
  final String matchResultString = '"text":';
  final String matchResultTurboString = '"content":';
  final Dio _openAIClient = Dio(
    BaseOptions(
      baseUrl: Endpoints.openAIBaseUrl,
      connectTimeout: const Duration(milliseconds: connectTimeOut),
      receiveTimeout: const Duration(milliseconds: receiveTimeOut),
      sendTimeout: const Duration(milliseconds: receiveTimeOut),
    ),
  );

  Map<String, String> _getHeaders(String apiKey) {
    return {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json; charset=UTF-8',
      'Connection': 'keep-alive',
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
    };
  }

  Options _getOptions(String apiKey, {ResponseType? responseType}) {
    return Options(
      validateStatus: (status) {
        return true;
      },
      headers: _getHeaders(apiKey),
      responseType: responseType,
    );
  }

  @override
  Future<String?> textCompletions(
    String apiKey,
    TextCompletionsParams params, {
    Function(String p1)? onStreamValue,
    Function(StreamSubscription? p1)? onStreamCreated,
    Duration debounce = Duration.zero,
  }) async {
    String responseText = '';

    if (params.stream) {
      final Response<ResponseBody> response = await _openAIClient.post(
        params.isChatCompletion
            ? Endpoints.textCompletionsTurbo
            : Endpoints.textCompletions,
        data: params.isChatCompletion ? params.toMapTurbo() : params.toMap(),
        options: _getOptions(apiKey, responseType: ResponseType.stream),
      );

      DecoderQueueService.instance.initialize();

      final StreamSubscription<Uint8List>? responseStream = response
          .data?.stream
          .asyncExpand((event) => Rx.timer(event, debounce))
          .doOnData((event) {})
          .listen(
        (bodyBytes) {
          DecoderQueueService.instance.addQueue(() {
            if (params.isChatCompletion) {
              _handleListenBodyBytesTurbo(bodyBytes, response, (p0) {
                responseText += p0;
                onStreamValue?.call(responseText);
              });
            } else {
              _handleListenBodyBytes(bodyBytes, response, (p0) {
                responseText += p0;
                onStreamValue?.call(responseText);
              });
            }
          });
        },
      );

      onStreamCreated?.call(responseStream);

      await responseStream?.asFuture();
      responseStream?.cancel();
    } else {
      final Response response = await _openAIClient.post(
        params.isChatCompletion
            ? Endpoints.textCompletionsTurbo
            : Endpoints.textCompletions,
        data: params.isChatCompletion ? params.toMapTurbo() : params.toMap(),
        options: _getOptions(apiKey),
      );

      if (response.statusCode != 200) {
        throw Exception(
          "status code: ${response.statusCode}, error: ${response.data}",
        );
      }

      if (params.isChatCompletion) {
        responseText =
            (response.data['choices'][0]?['message']?['content'] ?? '')
                .toString()
                .trim();
      } else {
        responseText =
            (response.data['choices'][0]?['text'] ?? '').toString().trim();
      }
    }
    return responseText;
  }

  void _handleListenBodyBytes(
    Uint8List bodyBytes,
    Response response,
    Function(String) handleNewValue,
  ) {
    final String data = utf8.decode(bodyBytes, allowMalformed: false);
    if (data.contains(matchResultString)) {
      final List<String> dataSplit = data.split("[{");

      final int indexOfResult = dataSplit.indexWhere(
        (element) => element.contains(matchResultString),
      );

      final List<String> textSplit =
          indexOfResult == -1 ? [] : dataSplit[indexOfResult].split(",");

      final indexOfText = textSplit.indexWhere(
        (element) => element.contains(matchResultString),
      );

      if (indexOfText != -1) {
        try {
          final Map dataJson = jsonDecode('{${textSplit[indexOfText]}}');
          handleNewValue(dataJson['text'].toString());
        } on Exception catch (_, __) {
          return;
        }
      }
    } else {
      Map errorJson = {};
      try {
        errorJson = jsonDecode(data);
        // ignore: empty_catches
      } catch (error) {}

      if (errorJson['error'] != null) {
        throw Exception(
          "status code: ${response.statusCode}, error: ${errorJson['error']['message']}",
        );
      }
    }
  }

  void _handleListenBodyBytesTurbo(
    Uint8List bodyBytes,
    Response response,
    Function(String) handleNewValue,
  ) {
    late final String data;
    try {
      data = utf8.decode(bodyBytes, allowMalformed: false);
    } catch (_) {
      return;
    }

    if (data.contains(matchResultTurboString)) {
      final List<String> jsonStrings = data.split('data: ');

      for (final jsonString in jsonStrings) {
        if (jsonString.isEmpty) continue;

        try {
          final dataJson = jsonDecode(jsonString);
          handleNewValue(
            dataJson?['choices']?[0]?['delta']?['content']?.toString() ?? '',
          );
        } catch (_) {
          log("-> 🐛 Throw: ${_.toString()}");
          handleNewValue(tryDecodeTurboBytesPayload(data));
        }
      }
    } else {
      Map errorJson = {};
      try {
        errorJson = jsonDecode(data);
        // ignore: empty_catches
      } catch (error) {}

      if (errorJson['error'] != null) {
        throw Exception(
          "status code: ${response.statusCode}, error: ${errorJson['error']['message']}",
        );
      }
    }
  }

  String tryDecodeTurboBytesPayload(String data) {
    final List<String> dataSplit = data.split("[{");

    final int indexOfResult = dataSplit.indexWhere(
      (element) => element.contains(matchResultString),
    );

    final List<String> textSplit =
        indexOfResult == -1 ? [] : dataSplit[indexOfResult].split(",");

    final indexOfText = textSplit.indexWhere(
      (element) => element.contains(matchResultString),
    );

    if (indexOfText != -1) {
      try {
        final Map dataJson = jsonDecode('{${textSplit[indexOfText]}}');
        return dataJson['text'].toString();
      } on Exception catch (_, __) {
        log("-> 🐛 Throw: ${_.toString()}");
        return " ";
      }
    }

    return " ";
  }
}
