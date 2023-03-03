library chatgpt_completions;

import 'dart:async';

import 'package:chatgpt_completions/src/models/chatgpt_params.dart';
import 'package:chatgpt_completions/src/repository/text_completions_repository.dart';

export './src/models/chatgpt_params.dart';
export './src/models/gpt_model.dart';
export './src/models/turbo_role.dart';
export './src/models/message_turbo.dart';

class ChatGPTCompletions {
  // MARK: variables
  String _apiKey = "";

  void initialize({required String apiKey}) {
    _apiKey = apiKey;
  }

  Future<String?> textCompletions(
    TextCompletionsParams params, {
    Function(String p1)? onStreamValue,
    Function(StreamSubscription? p1)? onStreamCreated,
    Duration debounce = Duration.zero,
    String? forceKey,
  }) async {
    return await TextCompletionsRepository().textCompletions(
      forceKey ?? _apiKey,
      params,
      onStreamValue: onStreamValue,
      onStreamCreated: onStreamCreated,
      debounce: debounce,
    );
  }

  /// Singleton factory
  static final ChatGPTCompletions instance = ChatGPTCompletions._internal();

  factory ChatGPTCompletions() {
    return instance;
  }

  ChatGPTCompletions._internal();
}
