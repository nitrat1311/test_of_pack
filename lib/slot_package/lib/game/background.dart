import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

class Background extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('back.png');
    size = gameRef.size;
  }
}
