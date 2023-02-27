// ignore_for_file: avoid_print

import 'dart:async';

import 'package:chatgpt_completions/chatgpt_completions.dart';

void main() async {
  /// Generate api key from openai console: https://platform.openai.com/account/api-keys
  ChatGPTCompletions.instance.initialize(apiKey: 'openai_api_key');

  print("Generating answer without stream...");

  // Text completions without stream response (stream: false)
  String? responseWithoutStream =
      await ChatGPTCompletions.instance.textCompletions(TextCompletionsParams(
    prompt: "What's Flutter?",
    model: GPTModel.davinci,
    stream: false,
  ));

  print("OpenAI: $responseWithoutStream");

  print("\n\n-> Generating answer with stream...");
  await Future.delayed(const Duration(seconds: 2));

  // Text completions with stream response (stream: true)
  String responseWithStream = "";

  // If you want implement feature "stop generating", need record stream subcription when you want to stop.
  // Let call responseSubscription?.cancel();

  StreamSubscription? responseSubscription;

  await ChatGPTCompletions.instance.textCompletions(
    TextCompletionsParams(
      prompt: "What's Flutter?",
      model: GPTModel.davinci,
    ),
    onStreamValue: (characters) {
      responseWithStream += characters;
      print(responseWithStream);
    },
    onStreamCreated: (subscription) {
      responseSubscription = subscription;
    },
  );

  // Stop generating
  responseSubscription?.cancel();
}
