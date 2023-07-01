import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:slot_package/game/enemy.dart';
import 'package:slot_package/game/game2.dart';


import 'health_bar.dart';
import 'knows_game_size.dart';

enum PlayerState { stopped1, stopped2, jumping, reverse, zero }

// This component class represents the player character in game.
class Player extends SpriteComponent
    with
        KnowsGameSize,
        CollisionCallbacks,
        HasGameRef<RouterGame>
         {


  int _health = 100;
  int _currentScore = 0;
  int get health => _health;
  int get score => _currentScore;



  Player({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(sprite: sprite, position: position, size: size);
     
      @override
  FutureOr<void> onLoad() {
    
    return super.onLoad();
  }

  @override
  void onMount() async {
    super.onMount();

    // Adding a circular hitbox with radius as 0.8 times
    // the smallest dimension of this components size.
    final shape = RectangleHitbox.relative(
      Vector2(0.8, 0.8),
      parentSize: super.size,
      position: Vector2(super.size.x / 2, super.size.y / 2),
      anchor: Anchor.center,
    );
    add(shape);
  }

  // This method is called by game class for every frame.
  @override
  void update(double dt) {
    super.update(dt);

    position.clamp(
      Vector2.zero() + size / 2,
      gameRef.size - size / 2,
    );
            if (health <= 0) {
          gameRef.pauseEngine();
          gameRef.router.popUntilNamed('home');
        }
  }

  // Adds given points to player score
  /// and also add it to [PlayerData.money].
  void addToScore(int points) {
    _currentScore += points;
  }
@override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
       if (other is Enemy && position.y > gameRef.size.y / 1.32) {
      // If the other Collidable is Player, destroy.
      _health-=20;
    }
    super.onCollision(intersectionPoints, other);
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
  }

