import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import '../models/ally_data.dart';
import 'ally.dart';
import 'game.dart';

class AllyManager extends Component with HasGameRef<MasksweirdGame> {
  late Timer _timer;
  late Sprite sprite;
  Random random = Random();
  List<Ally> allies = [];

  AllyManager({required this.sprite}) : super() {
    _timer = Timer(0, onTick: spawnAllies, repeat: false);
  }

  void spawnAllies() {
    final Vector2 center = Vector2(0, 0);
    const double radius = 45;
    const int allyCount = 3;
    const double angleIncrement = 2 * pi / allyCount;

    for (int i = 0; i < allyCount; i++) {
      double angle = i * angleIncrement;
      Vector2 position = Vector2(
        center.x + radius * cos(angle),
        center.y + radius * sin(angle),
      );

      createRotatingAlly(position, angle);
    }
  }

  void createRotatingAlly(Vector2 position, double initialAngle) {
    final allyData = AllyData(
      killPoint: 1,
      speed: 250,
      spriteId: 1,
      level: 1,
      hMove: false,
    );

    final ally = Ally(
      sprite: sprite,
      allyData: allyData,
      position: position,
      size: Vector2(64 * 1.3, 64 * 1.3),
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

    const double rotationSpeed = 2; // Adjust the rotation speed as desired

    for (final ally in allies) {
      ally.angle += dt * rotationSpeed;
      final Vector2 center = Vector2(gameRef.size.x - 132, gameRef.size.y / 2);
      const double radius = 45;
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

  static const List<AllyData> _enemyDataList = [
    AllyData(
      killPoint: 1,
      speed: 250,
      spriteId: 1,
      level: 1,
      hMove: false,
    ),
  ];
}
