library slot_package;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'game.dart';
import 'knows_size.dart';

enum PlayerState { stopped1, stopped2, jumping, reverse, zero }

// This component class represents the player character in game.
class Player extends SpriteAnimationComponent
    with
        KnowsSize,
        CollisionCallbacks,
        HasGameRef<MasksweirdGame>,
        KeyboardHandler {
  PlayerState playerState = PlayerState.zero;
  // Player health.
  int _health = 100;
  int _currentScore = 50;
  int get health => _health;
  int get score => _currentScore;

  Player({
    Vector2? position,
    Vector2? size,
  }) : super(position: position, size: size);

  @override
  void onMount() async {
    super.onMount();

    // Adding a circular hitbox with radius as 0.8 times
    // the smallest dimension of this components size.
    final shape = RectangleHitbox.relative(
      Vector2(0.5, 1),
      parentSize: Vector2(super.size.x * 0.5, super.size.y * 1),
      position: Vector2(super.size.x / 2, super.size.y),
      anchor: Anchor.centerRight,
    );
    add(shape);
  }

  void addToScore(int points) {
    _currentScore += points;
  }

  // Increases health by give amount.
  void increaseHealthBy(int points) {
    _health += points;
    // Clamps health to 100.
    if (_health > 100) {
      _health = 100;
    }
  }

  void reset() {
    _currentScore = 0;
    _health = 100;
    // position = gameRef.size / 2;
  }
}
