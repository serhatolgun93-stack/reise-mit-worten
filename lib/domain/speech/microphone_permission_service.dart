import 'speech_models.dart';

abstract interface class MicrophonePermissionService {
  Future<MicrophonePermissionState> currentState();
  Future<MicrophonePermissionState> requestContextualPermission();
  Future<bool> openSettings();
}
