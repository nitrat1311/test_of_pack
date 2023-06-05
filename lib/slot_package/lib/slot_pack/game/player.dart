import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
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
  PlayerState playerState = PlayerState.zero;
  // Player health.
  int _health = 100;
  int _currentScore = 0;
  int get health => _health;

  // A reference to PlayerData so that
  JoystickComponent joystick;

  int get score => _currentScore;

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
        !gameRef.player.animation!.isLastFrame &&
        gameRef.player.animation == gameRef.animationRight) {
      // Make the camera shake, with custom intensity.

      Bullet bullet = Bullet(
          animation: gameRef.fire,
          size: Vector2(104 / 2, 101 / 2),
          position: Vector2(
              gameRef.player.position.x + 32, gameRef.player.position.y + 62));

      // Anchor it to center and add to game world.
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
      gameRef.animationForward.reset();
      gameRef.animationBack.reset();
      gameRef.player.animation?.done();
    }
    if (!joystick.delta.isZero()) {
      if (joystick.delta.x < 0) {
        gameRef.animationForward.reset();
        gameRef.player.animation = gameRef.animationBack;
      }
      if (joystick.delta.x > 0) {
        gameRef.animationBack.reset();
        gameRef.player.animation = gameRef.animationForward;
      }
      position.add(Vector2(joystick.relativeDelta.x, 0) * 200 * dt);
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

  // Resets player score, health and position. Should be called
  // while restarting and exiting the game.
  void reset() {
    _currentScore = 0;
    _health = 100;
    // position = gameRef.size / 2;
  }

  void jump() async {
    playerState = PlayerState.jumping;
    gameRef.no_fire.reset();
    gameRef.player.animation = gameRef.animationRight;
    // gameRef.animationRight.reset();
    // gameRef.animationForward.reset();
    // gameRef.animationBack.reset();
  }

  void compl() {
    // if (playerState == PlayerState.reverse) {

    //   playerState = PlayerState.stopped2;
    // } else
    if (playerState == PlayerState.jumping) {
      gameRef.no_fire.reset();
      gameRef.animationRight.reset();
      gameRef.animationForward.reset();
      gameRef.animationBack.reset();

      playerState = PlayerState.stopped1;
    }
  }

  void compl2() {
    // if (playerState == PlayerState.reverse) {

    //   playerState = PlayerState.stopped2;
    // } else
  }
}
