import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:slot_package/app_state.dart';
import 'game.dart';

class AudioPlayerComponent extends Component with HasGameRef<MasksweirdGame> {
  var audio = FlameAudio.audioCache;

  @override
  Future<void>? onLoad() async {
    audio.prefix = 'packages/slot_package/assets/audio/';
    FlameAudio.bgm.initialize();
    await audio.load('music.mp3');

    try {
      await audio.load('music.mp3');
    } catch (_) {}
    return super.onLoad();
  }

  void playBgm(String filename) {
    if (!audio.loadedFiles.containsKey(filename)) return;

    if (gameRef.buildContext != null) {
      if (AppState().backgroundMusic) {
        FlameAudio.bgm.play(filename);
      }
    }
  }

  void playSfx(String filename) {
    if (gameRef.buildContext != null) {
      if (AppState().soundEffects) {
        FlameAudio.play(filename);
      }
    }
  }

  void stopBgm() {
    FlameAudio.bgm.stop();
  }
}
