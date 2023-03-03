<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Dart client for the unofficial ChatGPT API. Support Text Completeion and stream response from v1/completions.

## Features

<img src="https://github.com/lambiengcode/chatgpt_completions/blob/main/screenshots/RPReplay_Final1677469870.gif?raw=true" width="300px" />

* Text completions without stream response
* Text completions with stream response

## Getting started

- Install package

```terminal
flutter pub add chatgpt_completions
```

## Usage

- Initialize instance

```dart
/// Generate api key from openai console: https://platform.openai.com/account/api-keys
ChatGPTCompletions.instance.initialize(apiKey: "api_key_here");
```

- Text completions without stream response (stream: false)

```dart
String? responseWithoutStream =
      await ChatGPTCompletions.instance.textCompletions(TextCompletionsParams(
    prompt: "What's Flutter?",
    model: GPTModel.davinci,
    temperature: 0.2,
    topP: 1,
    n: 1,
    stream: false,
    maxTokens: 2048,
));

print("OpenAI: $responseWithoutStream");
```

- Text completions with stream response (stream: true)

```dart
StreamSubscription? responseSubscription;

await ChatGPTCompletions.instance.textCompletions(
    TextCompletionsParams(
      prompt: "What's Flutter?",
      model: GPTModel.davinci,
      temperature: 0.2,
      topP: 1,
      n: 1,
      stream: true, // --> set this is true
      maxTokens: 2048,
    ),
    onStreamValue: (characters) {
      responseWithStream += characters;
      print(responseWithStream);
    },
    onStreamCreated: (subscription) {
      responseSubscription = subscription;
    },
);
```

- Stop generating (with stream)

```dart
responseSubscription?.cancel();
```

- Using model gpt-3.5-turbo

```dart
// Using GPT-3.5-Turbo
await ChatGPTCompletions.instance.textCompletions(
  TextCompletionsParams(
    // using messagesTurbo insteal of prompt
    messagesTurbo: [
      MessageTurbo(
        role: TurboRole.user,
        content: "What's Flutter?",
      ),
    ],
    model: GPTModel.gpt3p5turbo, // --> switch to gpt-3.5-turbo model
  ),
  onStreamValue: (characters) {
    responseWithStream += characters;
    print(responseWithStream);
  },
  onStreamCreated: (subscription) {
    responseSubscription = subscription;
  },
  // Debounce 100ms for receive next value
  debounce: const Duration(milliseconds: 100),
);
```


## License - lambiengcode

```terminal
MIT License

Copyright (c) 2022 Askany

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```

