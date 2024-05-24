enum GPTModel {
  gpt4("gpt-4", 8192, isChatCompletion: true),
  gpt4o("gpt-4o", 4096, isChatCompletion: true),
  gpt4o20240513("gpt-4o-2024-05-13", 4096, isChatCompletion: true),
  gpt4turbo("gpt-4-turbo-2024-04-09", 4096, isChatCompletion: true),
  gpt4turbopreview("gpt-4-turbo-preview", 4096, isChatCompletion: true),
  gpt41106preview("gpt-4-1106-preview", 4096, isChatCompletion: true),
  gpt4v0613("gpt-4-0613", 8192, isChatCompletion: true),
  gpt3p5turbo("gpt-3.5-turbo", 4096, isChatCompletion: true);

  /// Returns the [GPTModel] from the given model.
  const GPTModel(this.model, this.maxTokens, {this.isChatCompletion = false});

  final String model;
  final int maxTokens;
  final bool isChatCompletion;
}
