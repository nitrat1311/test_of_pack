import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import '../game/bullet.dart';

import 'game.dart';
import 'enemy.dart';
import 'knows_game_size.dart';

enum PlayerState { stopped1, stopped2, jumping, reverse, zero }

// This component class represents the player character in game.
class Player extends SpriteAnimationComponent
    with
        KnowsGameSize,
        CollisionCallbacks,
        HasGameRef<MasksweirdGame>,
        KeyboardHandler {
  late SpriteAnimation animationBack;
  late SpriteAnimation animationForward;
  late SpriteAnimation animationRight;
  late SpriteAnimation animation5;
  late SpriteAnimation no_fire;
  late SpriteAnimation fire;
  @override
  FutureOr<void> onLoad() {
    fire = SpriteSheet.fromColumnsAndRows(
      image: gameRef.images.fromCache('animation_fire.png'),
      columns: 6,
      rows: 1,
    ).createAnimation(from: 0, to: 5, row: 0, stepTime: 0.25, loop: true);
    no_fire = SpriteSheet.fromColumnsAndRows(
      image: gameRef.images.fromCache('animation_right.png'),
      columns: 4,
      rows: 1,
    ).createAnimation(from: 0, to: 1, row: 0, stepTime: 0.2, loop: false);
    animationBack = SpriteSheet.fromColumnsAndRows(
      image: gameRef.images.fromCache('animation_forward.png'),
      columns: 6,
      rows: 1,
    )
        .createAnimation(from: 0, to: 6, row: 0, stepTime: 0.15, loop: true)
        .reversed();
    animationForward = SpriteSheet.fromColumnsAndRows(
      image: gameRef.images.fromCache('animation_forward.png'),
      columns: 6,
      rows: 1,
    ).createAnimation(from: 0, to: 6, row: 0, stepTime: 0.15, loop: true);
    animationRight = SpriteSheet.fromColumnsAndRows(
      image: gameRef.images.fromCache('animation_right.png'),
      columns: 4,
      rows: 1,
    ).createAnimation(from: 0, to: 4, row: 0, stepTime: 0.15, loop: false);

    return super.onLoad();
  }

  PlayerState playerState = PlayerState.zero;
  // Player health.

  // A reference to PlayerData so that
  JoystickComponent joystick;

  Player({
    required this.joystick,
    SpriteAnimation? animation,
    Vector2? position,
    Vector2? size,
  }) : super(animation: animation, position: position, size: size);

  @override
  void onMount() async {
    super.onMount();

    // Adding a circular hitbox with radius as 0.8 times
    // the smallest dimension of this components size.
    final shape = RectangleHitbox.relative(
      Vector2(0.6, 0.1),
      parentSize: Vector2(super.size.x * 0.6, super.size.y * 0.3),
      position: Vector2(super.size.x / 2, super.size.y / 2),
      anchor: Anchor.bottomCenter,
    );
    add(shape);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Enemy &&
        animation == animationRight &&
        !animation!.isLastFrame) {
      // Make the camera shake, with custom intensity.

      // Anchor it to center and add to game world.

      Bullet bullet = Bullet(
          animation: fire,
          size: Vector2(104 / 2, 101 / 2),
          position: Vector2(position.x + 32, position.y + 62));
      bullet.anchor = Anchor.bottomCenter;
      gameRef.add(bullet);

      //   _health -= 10;
      //   if (_health <= 0) {
      //     _health = 0;
      //   }
    }
  }

  // This method is called by game class for every frame.
  @override
  void update(double dt) {
    super.update(dt);
    // if (playerState == PlayerState.jumping) {
    //   gameRef.player.animation = gameRef.animationRight;
    // }
    if (joystick.delta.x == 0) {
      // gameRef.animationRight.reset();
      animationForward.reset();
      animationBack.reset();
      animation?.done();
    }
    if (!joystick.delta.isZero()) {
      if (joystick.delta.x < 0) {
        animationForward.reset();
        animation = animationBack;
      }
      if (joystick.delta.x > 0) {
        animationBack.reset();
        animation = animationForward;
      }
      position
          .add(Vector2(joystick.relativeDelta.x, 0) * gameRef.playerSpeed * dt);
    }

    if (playerState == PlayerState.stopped1) {}
    if (playerState == PlayerState.stopped2) {}
    if (playerState == PlayerState.zero) {}
    // Clamp position of player such that the player sprite does not go outside the screen size.
    position.clamp(
      Vector2.zero() + size / 2,
      gameRef.size - size / 2,
    );
  }

  // Adds given points to player score
  /// and also add it to [PlayerData.money].
  void addToScore(int points) {
    gameRef.currentScore += points;
  }

  void changeSpeed(double speed) {
    gameRef.playerSpeed = speed;
  }

  void increaseHealthBy(int points) {
    gameRef.health += points;
    // Clamps health to 100.
    if (gameRef.health > 100) {
      gameRef.health = 100;
    }
  }

  // Resets player score, health and position. Should be called
  // while restarting and exiting the game.
  void reset() {
    gameRef.currentScore = 0;
    gameRef.health = 100;
    // position = gameRef.size / 2;
  }

  void jump() async {
    playerState = PlayerState.jumping;
    no_fire.reset();
    animation = animationRight;
    // gameRef.animationRight.reset();
    // gameRef.animationForward.reset();
    // gameRef.animationBack.reset();
  }

  void compl() {
    // if (playerState == PlayerState.reverse) {

    //   playerState = PlayerState.stopped2;
    // } else
    if (playerState == PlayerState.jumping) {
      no_fire.reset();
      animationRight.reset();
      animationForward.reset();
      animationBack.reset();

      playerState = PlayerState.stopped1;
    }
  }

  void compl2() {
    // if (playerState == PlayerState.reverse) {

    //   playerState = PlayerState.stopped2;
    // } else
  }
}
