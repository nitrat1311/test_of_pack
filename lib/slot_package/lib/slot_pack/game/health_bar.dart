import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:slot_package/slot_pack/game/game.dart';

import '../../const_colors.dart';
import 'fense.dart';

class HealthBar extends PositionComponent with HasGameRef<MasksweirdGame> {
  Fense? fence;

  HealthBar({
    this.fence,
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
      Rect.fromLTWH(-2, 5, fence?.fenceHealth ?? gameRef.health, 20),
      Paint()..color = AppColors.backColor,
    );
    super.render(canvas);
  }
}
