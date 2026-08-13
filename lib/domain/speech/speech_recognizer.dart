import 'speech_models.dart';

abstract interface class SpeechRecognizer {
  Future<SpeechProviderAvailability> availability();
  Future<SpeechRecognitionResult> recognize(SpeechRecognitionRequest request);
  Future<void> cancel();
}
