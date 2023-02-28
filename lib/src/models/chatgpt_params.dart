// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:chatgpt_completions/src/models/gpt_model.dart';

class TextCompletionsParams {
  final String prompt;
  final GPTModel model;
  final double temperature;
  final double topP;
  final int n;
  final bool stream;
  final int maxTokens;
  TextCompletionsParams({
    required this.prompt,
    required this.model,
    this.temperature = 0.9,
    this.topP = 1,
    this.n = 1,
    this.stream = true,
    this.maxTokens = 2048,
  });

  TextCompletionsParams copyWith({
    String? prompt,
    GPTModel? model,
    double? temperature,
    double? topP,
    int? n,
    bool? stream,
    int? maxTokens,
  }) {
    return TextCompletionsParams(
      prompt: prompt ?? this.prompt,
      model: model ?? this.model,
      temperature: temperature ?? this.temperature,
      topP: topP ?? this.topP,
      n: n ?? this.n,
      stream: stream ?? this.stream,
      maxTokens: maxTokens ?? this.maxTokens,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'prompt': prompt,
      'model': model.model,
      "max_tokens": maxTokens,
      'temperature': temperature,
      'top_p': topP,
      'n': n,
      'stream': stream,
      'logprobs': null,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'TextCompletionsParams(prompt: $prompt, model: $model, temperature: $temperature, topP: $topP, n: $n, stream: $stream)';
  }

  @override
  bool operator ==(covariant TextCompletionsParams other) {
    if (identical(this, other)) return true;

    return other.prompt == prompt &&
        other.model == model &&
        other.temperature == temperature &&
        other.topP == topP &&
        other.n == n &&
        other.stream == stream;
  }

  @override
  int get hashCode {
    return prompt.hashCode ^
        model.hashCode ^
        temperature.hashCode ^
        topP.hashCode ^
        n.hashCode ^
        stream.hashCode;
  }
}
