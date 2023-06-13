library slot_package;

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

import 'package:slot_package/const_colors.dart';

class Background extends ParallaxComponent {
  @override
  Future<void>? onLoad() async {
    final layers = await Future.wait<ParallaxLayer>([
      backGroundSnow,
    ]);
    parallax = Parallax(
      layers,
      baseVelocity: Vector2(0, 0),
    );

    return super.onLoad();
  }

  Future<ParallaxLayer> get backGroundSnow => gameRef.loadParallaxLayer(
        MyParallaxImageData('game_back.png'),
        fill: LayerFill.width,
        velocityMultiplier: Vector2(0.5, 0.0),
      );

  void changeLayerDay({
    required ParallaxLayer layerBack,
    required ParallaxLayer layerStars,
  }) {
    final Parallax? _parallax = parallax;
    if (_parallax != null) {
      _parallax.layers[0] = layerBack;
      _parallax.layers[1] = layerStars;

      parallax = Parallax(
        _parallax.layers,
        baseVelocity: Vector2(0, 0),
      );
    }
  }
}

class MyParallaxImageData extends ParallaxData {
  final String path;

  MyParallaxImageData(this.path);

  @override
  Future<ParallaxRenderer> load(
    ImageRepeat repeat,
    Alignment alignment,
    LayerFill fill,
    Images? images,
  ) {
    return ParallaxImage.load(
      path,
      repeat: repeat,
      alignment: alignment,
      fill: fill,
      images: Images(prefix: 'packages/${AppColors.myPackage}/assets/images/'),
    );
  }
}
