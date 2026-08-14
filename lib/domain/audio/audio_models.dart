enum AudioRole { model, character, listening }
enum AudioVariant { normal, slow }
enum LearningAudioState { idle, loading, playing, paused, completed, error }
final class AudioAssetDefinition { final String audioId; final String languageId; final String speakerId; final AudioRole role; final String scriptRef; final int scriptVersion; final AudioVariant variant; final String fileRef; final int durationMs; final String checksum; const AudioAssetDefinition({required this.audioId,required this.languageId,required this.speakerId,required this.role,required this.scriptRef,required this.scriptVersion,required this.variant,required this.fileRef,required this.durationMs,required this.checksum}); }
final class AudioManifest { final int version; final List<AudioAssetDefinition> assets; const AudioManifest({required this.version,required this.assets}); }
final class AudioSourceRef { final String assetPath; const AudioSourceRef(this.assetPath); }
