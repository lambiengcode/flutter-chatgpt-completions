## 1.0.3

* [Fix] Duplicate body response. Thanks @chopper985

## 1.0.2

* [Fix] add function _getContentFromJson using regexp to attempt to get value in json format error

## 1.0.1

* [Feat] Add Decoder Queue when listen response from Chat Completions API for ensure decode response payload in order.

## 1.0.0

* [Feat] Support new gpt model: **gpt-4**, **gpt-4-0613**, **gpt-4-32k**, **gpt-4-32k-0613** 
* [Fix] Decode bytes when stream response chat completions api

## 0.0.5

* Allow put force api key in each function execute
* Support debounce duration when stream response
* Fix response of ChatGPT(text-davinci-003)

## 0.0.4

* Support new gpt model: **gpt-3.5-turbo**
* Fix decoder response related to issue [#1](https://github.com/lambiengcode/chatgpt_completions/issues/1)

## 0.0.3

* Fix decode response in onStreamValue

## 0.0.2

* Add maxTokens in TextCompletionsParams
* Set default for max_tokens, temperature, top_p, n, stream 
* Throw exeption when error occured

## 0.0.1

* Text completions without stream response
* Text completions with stream response
