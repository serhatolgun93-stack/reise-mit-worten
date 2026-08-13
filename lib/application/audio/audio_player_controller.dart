import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import '../../domain/audio/audio_models.dart';
import '../../domain/audio/audio_repository.dart';

final class AudioPlayerSnapshot {
  final LearningAudioState state;
  final String? audioId;
  const AudioPlayerSnapshot(this.state, {this.audioId});
}

final class LearningAudioPlayerController {
  final AudioRepository repository;
  final AudioPlayer player;
  final _states = StreamController<AudioPlayerSnapshot>.broadcast();
  StreamSubscription<void>? _completeSub;
  AudioPlayerSnapshot _snapshot = const AudioPlayerSnapshot(LearningAudioState.idle);

  LearningAudioPlayerController({required this.repository, AudioPlayer? player}) : player = player ?? AudioPlayer() {
    this.player.setReleaseMode(ReleaseMode.stop);
    _completeSub = this.player.onPlayerComplete.listen((_) => _emit(AudioPlayerSnapshot(LearningAudioState.completed, audioId: _snapshot.audioId)));
  }

  Stream<AudioPlayerSnapshot> get states => _states.stream;
  AudioPlayerSnapshot get snapshot => _snapshot;

  Future<void> play(String audioId) async {
    try {
      await stop();
      _emit(AudioPlayerSnapshot(LearningAudioState.loading, audioId: audioId));
      final source = await repository.resolve(audioId);
      await player.setSource(AssetSource(source.assetPath.replaceFirst('assets/', '')));
      await player.resume();
      _emit(AudioPlayerSnapshot(LearningAudioState.playing, audioId: audioId));
    } catch (_) {
      _emit(AudioPlayerSnapshot(LearningAudioState.error, audioId: audioId));
      rethrow;
    }
  }

  Future<void> pause() async {
    await player.pause();
    _emit(AudioPlayerSnapshot(LearningAudioState.paused, audioId: _snapshot.audioId));
  }

  Future<void> replay() async {
    final id = _snapshot.audioId;
    if (id == null) return;
    await play(id);
  }

  Future<void> stop() async {
    await player.stop();
    if (_snapshot.state != LearningAudioState.idle) _emit(const AudioPlayerSnapshot(LearningAudioState.idle));
  }

  Future<void> dispose() async {
    await _completeSub?.cancel();
    await player.dispose();
    await _states.close();
  }

  void _emit(AudioPlayerSnapshot next) { _snapshot = next; _states.add(next); }
}
