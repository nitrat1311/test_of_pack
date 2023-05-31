import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../game/game.dart';

import 'enemy.dart';

// This component represent a bullet in game world.
class Bullet extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<MasksweirdGame> {
  // Speed of the bullet.
  // final double _speed = 450;
  Random random = Random();
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
    // if (other is Ally) {
    //   direction =
    //       Vector2(-random.nextDouble() - 0.5, -random.nextDouble() + 0.7);

    //   gameRef.player.animation = gameRef.animationSlide;
    // }
    // if (other is Player) {
    //   removeFromParent();
    //   // gameRef.player.animation = gameRef.catch_animation;
    //   final command = Command<Player>(action: (player) {
    //     // Use the correct killPoint to increase player's score.

    //     player.addToScore(10);
    //   });
    //   gameRef.addCommand(command);
    //   gameRef.resetAlly();
    // }
    if (other is Enemy) {
      gameRef.player.increaseHealthBy(-10);
      removeFromParent();
      gameRef.camera.shake(intensity: 5);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Moves the bullet to a new position with _speed and direction.
    position += direction * 450 * dt;
    // if (position.y < 30 || position.y > gameRef.size.y - 30) {
    //   direction.y = direction.y * -1;
    // }

    // if (position.x < 0 || position.x > gameRef.size.x - 100) {
    //   // gameRef.player.increaseHealthBy(-10);
    //   // gameRef.camera.shake(intensity: 5);
    //   gameRef.player.addToScore(10);
    //   removeFromParent();
    // }
    // if (position.y < 0 || position.x > gameRef.size.y) {
    //   gameRef.player.increaseHealthBy(-10);
    //   gameRef.camera.shake(intensity: 5);
    //   removeFromParent();
    // }
  }
}
