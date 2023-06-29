

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../game/game.dart';

import 'ally.dart';
import 'enemy.dart';

// This component represent a bullet in game world.
class Bullet extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<MasksweirdGame> {
  // Speed of the bullet.

  // // Controls the direction in which bullet travels.
  Vector2 direction = Vector2(1, 0);

  Bullet({
    required SpriteAnimation? animation,
    required Vector2? position,
    required Vector2? size,
  }) : super(animation: animation, position: position, size: size);

  @override
  void onMount() {
    super.onMount();

    // Adding a circular hitbox with radius as 0.4 times
    //  the smallest dimension of this components size.
    final shape = CircleHitbox.relative(
      0.4,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(shape);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // If the other Collidable is Enemy, remove this bullet.
    if (other is Ally) {
      removeFromParent();
    }
    if (other is Enemy) {
      // gameRef.player.increaseHealthBy(-10);
      removeFromParent();
      gameRef.camera.shake(intensity: 5);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Moves the bullet to a new position with _speed and direction.
    position += direction * 450 * dt;

    // If bullet crosses the upper boundary of screen
    // mark it to be removed it from the game world.
    if (position.y < 0) {
      removeFromParent();
    }
  }
}
