import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'game2.dart';

class HealthBar extends PositionComponent with HasGameRef<RouterGame> {


  HealthBar({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
  }) {
    positionType = PositionType.viewport;
  }

  @override
  void render(Canvas canvas) {
    // Draws a rectangular health bar at top right corner.
    canvas.drawRect(
      Rect.fromLTWH(-2, 5, gameRef.health.toDouble(), 20),
      Paint()..color = Colors.pink,
    );
    super.render(canvas);
  }
    @override
  void update(double dt) {
    super.update(dt);
  }
}
