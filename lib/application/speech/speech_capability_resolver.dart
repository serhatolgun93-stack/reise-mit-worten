import '../../domain/speech/microphone_permission_service.dart';
import '../../domain/speech/speech_models.dart';
import '../../domain/speech/speech_recognizer.dart';

abstract interface class NetworkAvailability { Future<bool> get isOnline; }
final class AlwaysOnlineNetworkAvailability implements NetworkAvailability { const AlwaysOnlineNetworkAvailability(); @override Future<bool> get isOnline async => true; }

final class SpeechCapabilityResolver {
  final MicrophonePermissionService permissions;
  final SpeechRecognizer recognizer;
  final NetworkAvailability network;
  const SpeechCapabilityResolver({required this.permissions, required this.recognizer, required this.network});

  Future<SpeechCapability> resolve({required bool speechEnabled, bool textFallbackAvailable = true}) async {
    if (!speechEnabled) return SpeechCapability(SpeechCapabilityState.disabledByUser, textFallbackAvailable: textFallbackAvailable);
    final permission = await permissions.currentState();
    if (permission == MicrophonePermissionState.unknown || permission == MicrophonePermissionState.denied) {
      return SpeechCapability(SpeechCapabilityState.permissionRequired, textFallbackAvailable: textFallbackAvailable);
    }
    if (permission != MicrophonePermissionState.granted) {
      return SpeechCapability(SpeechCapabilityState.unavailableWithFallback, textFallbackAvailable: textFallbackAvailable);
    }
    final provider = await recognizer.availability();
    if (!provider.available) return SpeechCapability(SpeechCapabilityState.providerUnavailable, textFallbackAvailable: textFallbackAvailable);
    if (provider.requiresNetwork && !await network.isOnline) {
      return SpeechCapability(SpeechCapabilityState.networkRequired, textFallbackAvailable: textFallbackAvailable);
    }
    return SpeechCapability(SpeechCapabilityState.available, textFallbackAvailable: textFallbackAvailable);
  }
}
