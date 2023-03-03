// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:chatgpt_completions/src/models/turbo_role.dart';

class MessageTurbo {
  final TurboRole role;
  final String content;
  MessageTurbo({
    required this.role,
    required this.content,
  });

  MessageTurbo copyWith({
    TurboRole? role,
    String? content,
  }) {
    return MessageTurbo(
      role: role ?? this.role,
      content: content ?? this.content,
    );
  }

  Map<String, String> toMap() {
    return {
      'role': role.name,
      'content': content,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'MessageTurbo(role: $role, content: $content)';

  @override
  bool operator ==(covariant MessageTurbo other) {
    if (identical(this, other)) return true;

    return other.role == role && other.content == content;
  }

  @override
  int get hashCode => role.hashCode ^ content.hashCode;
}
