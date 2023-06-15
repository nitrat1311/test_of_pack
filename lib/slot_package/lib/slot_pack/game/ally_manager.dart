import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import '../models/ally_data.dart';
import 'ally.dart';
import 'game.dart';

class AllyManager extends Component with HasGameRef<MasksweirdGame> {
  late Timer _timer;
  late SpriteSheet spriteSheet;
  Random random = Random();
  List<Ally> allies = [];

  AllyManager({required this.spriteSheet}) : super() {
    _timer = Timer(0, onTick: spawnAllies, repeat: false);
  }

  void spawnAllies() {
    final Vector2 center = Vector2(gameRef.size.x - 32, gameRef.size.y / 2);
    const double radius = 65;
    const int allyCount = 3;
    const double angleIncrement = 2 * pi / allyCount;

    final List<AllyData> allyDataList = [
      const AllyData(
          killPoint: 1, speed: 250, spriteId: 1, level: 1, hMove: false),
      const AllyData(
          killPoint: 20, speed: 250, spriteId: 2, level: 1, hMove: false),
      const AllyData(
          killPoint: 30, speed: 250, spriteId: 5, level: 1, hMove: false),
    ];

    for (int i = 0; i < allyCount; i++) {
      double angle = i * angleIncrement;
      Vector2 position = Vector2(
        center.x + radius * cos(angle),
        center.y + radius * sin(angle),
      );

      AllyData allyData = allyDataList[i];

      createRotatingAlly(position, angle, allyData);
    }
  }

  void createRotatingAlly(
      Vector2 position, double initialAngle, AllyData allyData) {
    final ally = Ally(
      position: position,
      allyData: allyData,
      sprite: spriteSheet.getSpriteById(allyData.spriteId),
      size: Vector2(900 / 18, 1500 / 20),
    );

    ally.angle = initialAngle;
    allies.add(ally);
    gameRef.add(ally);
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);

    const double rotationSpeed = 0.5; // Adjust the rotation speed as desired

    for (final ally in allies) {
      ally.angle += dt * rotationSpeed;
      final Vector2 center = Vector2(gameRef.size.x - 50, gameRef.size.y / 2);
      const double radius = 30;
      final double angle = ally.angle;
      final double x = center.x + radius * cos(angle);
      final double y = center.y + radius * sin(angle);
      ally.position.setValues(x, y);
    }

    _timer.update(dt);
  }

  void reset() {
    _timer.stop();
    _timer.start();
  }
}
