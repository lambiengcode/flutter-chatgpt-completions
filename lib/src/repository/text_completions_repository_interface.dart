import 'dart:async';

import 'package:chatgpt_completions/src/models/chatgpt_params.dart';

abstract class TextCompletionsRepositoryInterface {
  Future<String?> textCompletions(
    String apiKey,
    TextCompletionsParams params, {
    Function(String)? onStreamValue,
    Function(StreamSubscription?)? onStreamCreated,
  }) async {
    throw UnimplementedError("textCompletions() has not been implemented.");
  }
}
