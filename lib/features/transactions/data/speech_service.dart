import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();

  Future<bool> initialize({
    required Function(String status) onStatus,
    required Function(String error) onError,
  }) async {
    return await _speech.initialize(
      onStatus: onStatus,
      onError: (err) => onError(err.errorMsg),
    );
  }

  Future<void> startListening({
    required Function(String text) onResult,
  }) async {
    await _speech.listen(
      onResult: (result) => onResult(result.recognizedWords),
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  bool get isListening => _speech.isListening;
}

final speechServiceProvider = Provider<SpeechService>((ref) {
  return SpeechService();
});
