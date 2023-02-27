enum GPTModel {
  davinci("text-davinci-003", 4000),
  curie("text-curie-001", 2048),
  babbage("text-babbage-001", 2048),
  ada("text-ada-001", 2048);

  /// Returns the [GPTModel] from the given model.
  const GPTModel(this.model, this.maxTokens);

  final String model;
  final int maxTokens;
}
