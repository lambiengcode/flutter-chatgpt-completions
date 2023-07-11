// Dart imports:
import 'dart:collection';

class DecoderQueueService {
  final Queue<Function> _queue = Queue<Function>();
  String msg = "DECODER_QUEUE_SERVICE";
  bool _isProcessing = false;

  Future<void> addQueue(Function fn) async {
    _queue.add(fn);

    if (_isProcessing) return;

    runQueue();
  }

  void runQueue() {
    _isProcessing = true;

    while (_queue.isNotEmpty) {
      _queue.first();
      _queue.removeFirst();
    }

    _isProcessing = false;
  }

  void initialize() {
    _queue.clear();
  }

  /// Singleton factory
  static final DecoderQueueService instance = DecoderQueueService._internal();

  factory DecoderQueueService() {
    return instance;
  }

  DecoderQueueService._internal();
}
