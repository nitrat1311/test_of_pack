import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/particles.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../models/enemy_data.dart';


import 'game2.dart';
import 'player.dart';
import 'knows_game_size.dart';


// This class represent an enemy component.
class Enemy extends SpriteComponent
    with KnowsGameSize, CollisionCallbacks,TapCallbacks, HasGameRef<RouterGame> {
  // The speed of this enemy.
  double _speed = 250;

  // This direction in which this Enemy will move.
  // Defaults to vertically downwards.
  Vector2 moveDirection = Vector2(-0.5, 0.8);

  // Controls for how long enemy should be freezed.
  late Timer _freezeTimer;
  // This method generates a random vector with its angle
  // between from 0 and 360 degrees.
  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2.random(_random)) * 500;
  }

  // Holds an object of Random class to generate random numbers.
  final _random = Random();

  // The data required to create this enemy.
  final EnemyData enemyData;

  // Represents health of this enemy.
  int _hitPoints = 10;

  // This method generates a random vector with its angle
  // between from 0 and 360 degrees.

  // Returns a random direction vector with slight angle to +ve y axis.

  Enemy({
    required Sprite? sprite,
    required this.enemyData,
    required Vector2? position,
    required Vector2? size,
  }) : super(sprite: sprite, position: position, size: size) {
    // Rotates the enemy component by 180 degrees. This is needed because
    // all the sprites initially face the same direct, but we want enemies to be
    // moving in opposite direction.
    angle = pi / 2;

    // Set the current speed from enemyData.
    _speed = enemyData.speed;

    // Set hitpoint to correct value from enemyData.
    _hitPoints = enemyData.level * 10;

    // Sets freeze time to 2 seconds. After 2 seconds speed will be reset.
    _freezeTimer = Timer(5, onTick: () {
      _speed = enemyData.speed;
    });

    // If this enemy can move horizontally, randomize the move direction.
    // if (enemyData.hMove) {
    //   moveDirection = getRandomDirection();
    // }
  }

  @override
  void onMount() {
    super.onMount();

    // Adding a circular hitbox with radius as 0.8 times
    // the smallest dimension of this components size.
    final shape = CircleHitbox.relative(
      1.2,
      parentSize: size * 1.5,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(shape);
  }
    @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapDown(TapDownEvent event) {
    destroyMe();
  }

  // This method will destory this enemy.
  void destroy() {
  gameRef.health-=20;
    removeFromParent();


    // Generate 20 white circle particles with random speed and acceleration,
    // at current position of this enemy. Each particles lives for exactly
    // 0.1 seconds and will get removed from the game world after that.
    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 20,
        lifespan: 0.2,
        generator: (i) => AcceleratedParticle(
          acceleration: getRandomVector(),
          speed: getRandomVector(),
          position: position.clone(),
          child: CircleParticle(
            radius: 5,
            paint: Paint()..color = Colors.redAccent,
          ),
        ),
      ),
    );

    gameRef.add(particleComponent);
  }

  void destroyMe() {
    removeFromParent();

    // gameRef.addCommand(Command<AudioPlayerComponent>(action: (audioPlayer) {
    //   audioPlayer.playSfx('audio/crack.mp3');
    // }));
    // Generate 20 white circle particles with random speed and acceleration,
    // at current position of this enemy. Each particles lives for exactly
    // 0.1 seconds and will get removed from the game world after that.
    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 20,
        lifespan: 0.2,
        generator: (i) => AcceleratedParticle(
          acceleration: getRandomVector(),
          speed: getRandomVector(),
          position: position.clone(),
          child: CircleParticle(
            radius: 5,
            paint: Paint()..color = Colors.white,
          ),
        ),
      ),
    );

    gameRef.add(particleComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle = angle + 0.1;
    // If hitPoints have reduced to zero,
    // destroy this enemy

    _freezeTimer.update(dt);

    // Update the position of this enemy using its speed and delta time.
    position += moveDirection * _speed * dt;
    // print(position -= moveDirection * _speed * dt);
    // print(gameRef.player.position.x);
    // if (position.y > gameRef.size.y / 1.35) {
    //   destroy();
    // }
    // If the enemy leaves the screen, destroy it.
    if (position.x<gameRef.size.x/2) {
      gameRef.camera.shake(intensity: 5);
      destroy();
    } 
  }

  // Pauses enemy for 2 seconds when called.
  void freeze() {
    _speed = 0;
    _freezeTimer.stop();
    _freezeTimer.start();
  }
}
