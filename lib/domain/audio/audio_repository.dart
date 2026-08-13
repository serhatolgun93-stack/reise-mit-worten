import 'audio_models.dart';
abstract interface class AudioRepository {
  Future<AudioSourceRef> resolve(String audioId);
  Future<bool> isAvailable(String audioId);
}
