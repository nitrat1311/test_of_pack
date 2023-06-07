library slot_package;

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import '../../const_colors.dart';
import 'game.dart';

class AudioPlayerComponent extends Component with HasGameRef<MasksweirdGame> {
  var audioooCache = FlameAudio.audioCache;
  @override
  Future<void>? onLoad() async {
    FlameAudio.bgm.initialize();

    // audioooCache.prefix = 'packages/${AppColors.myPackage}/assets/audio/';

    await audioooCache.load('music.mp3');
    return super.onLoad();
  }

  void playBgm(String filename) {
    if (!audioooCache.loadedFiles.containsKey(filename)) return;

    if (gameRef.buildContext != null) {
      FlameAudio.bgm.play(filename);
    }
  }

  void stopBgm() {
    FlameAudio.bgm.stop();
  }
}
