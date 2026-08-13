enum SpeechRecognitionStatus { success, uncertain, noSpeech, technicalFailure, cancelled }
enum SpeechCapabilityState { available, permissionRequired, disabledByUser, providerUnavailable, networkRequired, unavailableWithFallback }
enum MicrophonePermissionState { granted, denied, permanentlyDenied, restricted, unknown }

final class SpeechRecognitionRequest {
  final String localeId;
  final Duration maxDuration;
  const SpeechRecognitionRequest({required this.localeId, this.maxDuration = const Duration(seconds: 12)});
}

final class SpeechRecognitionResult {
  final SpeechRecognitionStatus status;
  final String? recognizedText;
  final double? confidence;
  final String? diagnosticCode;
  const SpeechRecognitionResult({required this.status, this.recognizedText, this.confidence, this.diagnosticCode});
  const SpeechRecognitionResult.cancelled() : this(status: SpeechRecognitionStatus.cancelled);
}

final class SpeechProviderAvailability {
  final bool available;
  final bool requiresNetwork;
  const SpeechProviderAvailability({required this.available, this.requiresNetwork = false});
}

final class SpeechCapability {
  final SpeechCapabilityState state;
  final bool textFallbackAvailable;
  const SpeechCapability(this.state, {this.textFallbackAvailable = true});
  bool get canSpeak => state == SpeechCapabilityState.available;
}
