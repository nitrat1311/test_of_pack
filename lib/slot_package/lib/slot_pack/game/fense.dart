import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import '../game/bullet.dart';

import '../models/ally_data.dart';
import '../widgets/overlays/pause_button.dart';
import '../widgets/overlays/pause_menu.dart';
import 'game.dart';
import 'player.dart';
import 'command.dart';
import 'knows_game_size.dart';
import 'audio_player_component.dart';

// This class represent an enemy component.
class Fense extends SpriteComponent
    with KnowsGameSize, CollisionCallbacks, HasGameRef<MasksweirdGame> {
  // The speed of this enemy.
  double _speed = 250;

  // This direction in which this Enemy will move.
  // Defaults to vertically downwards.
  // Vector2 moveDirection = Vector2(1, 0);

  // Holds an object of Random class to generate random numbers.
  final _random = Random();
  // Represents health of this enemy.
  double _fenceHealth = 100;
  double get fenceHealth => _fenceHealth;
  // Returns a random direction vector with slight angle to +ve y axis.
  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2.random(_random)) * 500;
  }

  Fense({
    required Sprite? sprite,
    required Vector2? position,
    required Vector2? size,
  }) : super(sprite: sprite, position: position, size: size) {
    // Rotates the enemy component by 180 degrees. This is needed because
    // all the sprites initially face the same direct, but we want enemies to be
    // moving in opposite direction.
    angle = 0;

    // Set the current speed from enemyData.
    _speed = 0;

    // Set hitpoint to correct value from enemyData.
  }

  @override
  void onMount() {
    super.onMount();

    // Adding a circular hitbox with radius as 0.8 times
    // the smallest dimension of this components size.
    final shape = CircleHitbox.relative(
      0.8,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(shape);
  }

  // @override
  // bool onTapDown(TapDownInfo info) {
  //   kiss();
  //   gameRef.resetAlly();
  //   return super.onTapDown(info);
  // }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Bullet) {
      // If the other Collidable is Player, destroy.
      _fenceHealth -= 10;
      // gameRef.resetAlly();
      if (_fenceHealth == 10) {
        gameRef.reset();

        gameRef.isReset = false;
        gameRef.router.pushReplacementNamed('level2');
      }
    }
  }

  // This method will destory this enemy.
  void kiss() {
    // Ask audio player to play enemy destroy effect.
    // gameRef.addCommand(Command<AudioPlayerComponent>(action: (audioPlayer) {
    //   audioPlayer.playSfx('audio/coin.mp3');
    // }));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (fenceHealth == 0) {
      removeFromParent();
    }

    // Update the position of this enemy using its speed and delta time.
    // position += moveDirection * _speed * dt;
    // angle = angle + 0.1;
    // position.clamp(
    //   Vector2.zero() + size / 2,
    //   gameRef.size - size / 2,
    // );
    // If the enemy leaves the screen, destroy it.

    //  else if ((position.x < size.x / 2) ||
    //     (position.x > (gameRef.size.x - size.x / 2))) {
    //   // Enemy is going outside vertical screen bounds, flip its x direction.
    //   moveDirection.x *= -1;
    // }
  }

  void fenseReset() {
    _fenceHealth = 100;
  }
}