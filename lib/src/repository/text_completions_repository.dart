// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:chatgpt_completions/src/constants/constants.dart';
import 'package:chatgpt_completions/src/constants/endpoints.dart';
import 'package:chatgpt_completions/src/models/chatgpt_params.dart';
import 'package:chatgpt_completions/src/repository/text_completions_repository_interface.dart';
import 'package:dio/dio.dart';

class TextCompletionsRepository extends TextCompletionsRepositoryInterface {
  static Dio openAIClient = Dio(
    BaseOptions(
      baseUrl: Endpoints.openAIBaseUrl,
      connectTimeout: const Duration(milliseconds: connectTimeOut),
      receiveTimeout: const Duration(milliseconds: receiveTimeOut),
      sendTimeout: const Duration(milliseconds: receiveTimeOut),
    ),
  );

  getHeaders(String apiKey) {
    return {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json; charset=UTF-8',
      'Connection': 'keep-alive',
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
    };
  }

  Options getOptions(String apiKey, {ResponseType? responseType}) {
    return Options(
      validateStatus: (status) {
        return true;
      },
      headers: getHeaders(apiKey),
      responseType: responseType,
    );
  }

  @override
  Future<String?> textCompletions(
    String apiKey,
    TextCompletionsParams params, {
    Function(String p1)? onStreamValue,
    Function(StreamSubscription? p1)? onStreamCreated,
  }) async {
    try {
      String responseText = '';

      if (params.stream) {
        final Response<ResponseBody> response = await openAIClient.post(
          Endpoints.textCompletions,
          data: params.toMap(),
          options: getOptions(apiKey, responseType: ResponseType.stream),
        );

        final StreamSubscription? responseStream = response.data?.stream.listen(
          (event) {
            final String data = utf8.decode(event);

            if (data.startsWith('data: {')) {
              final Map dataJson = jsonDecode(data.replaceAll('data: ', ''));
              responseText += dataJson['choices'][0]['text'].toString();
              onStreamValue?.call(responseText);
            }
          },
        );

        onStreamCreated?.call(responseStream);

        await responseStream?.asFuture();
        responseStream?.cancel();
      } else {
        final Response response = await openAIClient.post(
          Endpoints.textCompletions,
          data: params.toMap(),
          options: getOptions(apiKey),
        );

        responseText = response.data['choices'][0]['text'].toString();
      }

      return responseText;
    } catch (e) {
      return null;
    }
  }
}
