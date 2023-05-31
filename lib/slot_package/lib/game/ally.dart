import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../game/bullet.dart';

import 'game.dart';
import 'player.dart';
import 'command.dart';
import 'knows_game_size.dart';
import 'audio_player_component.dart';

import '../../models/ally_data.dart';

// This class represent an enemy component.
class Ally extends SpriteComponent
    with
        KnowsGameSize,
        CollisionCallbacks,
        // Tappable,
        HasGameRef<MasksweirdGame> {
  // The speed of this enemy.
  double _speed = 350;

  // This direction in which this Enemy will move.
  // Defaults to vertically downwards.
  Vector2 moveDirection = Vector2(-1, 0);

  // Holds an object of Random class to generate random numbers.
  final _random = Random();

  // The data required to create this enemy.
  final AllyData allyData;
  // Represents health of this enemy.
  // int _hitPoints = 10;
  // Returns a random direction vector with slight angle to +ve y axis.
  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2.random(_random)) * 500;
  }

  Ally({
    required Sprite? sprite,
    required this.allyData,
    required Vector2? position,
    required Vector2? size,
  }) : super(sprite: sprite, position: position, size: size) {
    // Rotates the enemy component by 180 degrees. This is needed because
    // all the sprites initially face the same direct, but we want enemies to be
    // moving in opposite direction.
    angle = 0;

    // Set the current speed from enemyData.
    _speed = allyData.speed;

    // Set hitpoint to correct value from enemyData.
    // _hitPoints = allyData.level * 10;
  }

  @override
  void onMount() {
    super.onMount();

    // Adding a circular hitbox with radius as 0.8 times
    // the smallest dimension of this components size.
    final shape = CircleHitbox.relative(
      1,
      parentSize: size,
      position: Vector2(size.x / 3, size.y),
      anchor: Anchor.centerLeft,
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

    if (other is Player &&
        gameRef.player.animation == gameRef.animationKick &&
        allyData.hMove) {
      removeFromParent();
      gameRef.addCommand(Command<AudioPlayerComponent>(action: (audioPlayer) {
        audioPlayer.playSfx('audio/crack.mp3');
      }));
      gameRef.player.addToScore(allyData.killPoint * 10);
      Bullet bullet = Bullet(
          animation: gameRef.fire,
          size: Vector2(100 / 2, 100 / 2),
          position: Vector2(
              gameRef.player.position.x + 32, gameRef.player.position.y + 80));

      // Anchor it to center and add to game world.
      bullet.anchor = Anchor.bottomCenter;

      gameRef.add(bullet);
    }
    if (other is Player &&
        gameRef.player.animation == gameRef.animationSlide &&
        allyData.hMove) {
      removeFromParent();
      gameRef.player.addToScore(allyData.killPoint * 10);

      Bullet bullet = Bullet(
          animation: gameRef.fire,
          size: Vector2(100 / 2, 100 / 2),
          position: Vector2(
              gameRef.player.position.x + 32, gameRef.player.position.y + 80));

      // Anchor it to center and add to game world.
      bullet.anchor = Anchor.bottomCenter;

      gameRef.add(bullet);
    }
    if (other is Player &&
        gameRef.player.joystick.delta.y < 0 &&
        allyData.psn != 130 &&
        !allyData.hMove) {
      removeFromParent();
      final command = Command<Player>(action: (player) {
        player.increaseHealthBy(-20);
      });
      gameRef.addCommand(command);
      gameRef.camera.shake(intensity: 5);
    }
    if (other is Player &&
        gameRef.player.joystick.delta.y > 0 &&
        allyData.psn != 0 &&
        !allyData.hMove) {
      removeFromParent();
      final command = Command<Player>(action: (player) {
        player.increaseHealthBy(-20);
      });
      gameRef.addCommand(command);
      gameRef.camera.shake(intensity: 5);
    }
    if (other is Player &&
        gameRef.player.joystick.delta.y == 0 &&
        !allyData.hMove) {
      removeFromParent();
      final command = Command<Player>(action: (player) {
        player.increaseHealthBy(-20);
      });
      gameRef.addCommand(command);
      gameRef.camera.shake(intensity: 5);
    }
  }

  // This method will destory this enemy.
  void kiss() {
    // Ask audio player to play enemy destroy effect.
    // gameRef.addCommand(Command<AudioPlayerComponent>(action: (audioPlayer) {
    //   audioPlayer.playSfx('audio/coin.mp3');
    // }));

    removeFromParent();
    // Before dying, register a command to increase
    // player's score by 1.
    final command = Command<Player>(action: (player) {
      // Use the correct killPoint to increase player's score.

      player.addToScore(allyData.killPoint * 10);
    });
    gameRef.addCommand(command);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the position of this enemy using its speed and delta time.
    position += moveDirection * _speed * dt;
    if (allyData.hMove) {
      angle = angle - 0.1;
    }

    // position.clamp(
    //   Vector2.zero() + size / 2,
    //   gameRef.size - size / 2,
    // );
    // If the enemy leaves the screen, destroy it.
    if (position.x > gameRef.size.x) {
      removeFromParent();
      gameRef.resetAlly();
    }
    if (position.y > gameRef.size.y) {
      removeFromParent();
    }
    //  else if ((position.x < size.x / 2) ||
    //     (position.x > (gameRef.size.x - size.x / 2))) {
    //   // Enemy is going outside vertical screen bounds, flip its x direction.
    //   moveDirection.x *= -1;
    // }
  }
}
