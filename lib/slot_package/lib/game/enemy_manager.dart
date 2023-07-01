import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../models/enemy_data.dart';

import 'enemy.dart';
import 'game2.dart';
import 'health_bar.dart';
import 'knows_game_size.dart';



// This component class takes care of spawning new enemy components
// randomly from top of the screen. It uses the HasGameRef mixin so that
// it can add child components.
class EnemyManager extends Component
    with KnowsGameSize, HasGameRef<RouterGame> {
  // The timer which runs the enemy spawner code at regular interval of time.
  late Timer _timer;
late SpriteSheet ballSprite;
  // Controls for how long EnemyManager should stop spawning new enemies.
  late Timer _freezeTimer;



  // Holds an object of Random class to generate random numbers.
  Random random = Random();

  EnemyManager() : super() {
    // Sets the timer to call _spawnEnemy() after every 1 second, until timer is explicitly stops.
    _timer = Timer(1.5, onTick: _spawnEnemy, repeat: true);

    // Sets freeze time to 2 seconds. After 2 seconds spawn timer will start again.
    _freezeTimer = Timer(2, onTick: () {
      _timer.start();
    });
  }
@override
  Future<void> onLoad() async {
    // Makes the game use a fixed resolution irrespective of the windows size.
    gameRef.images.prefix = 'packages/slot_package/assets/images/';
    // Initilize the game world only one time.

      await gameRef.images.loadAll([
         'animation_fire.png',
      ]);


      ballSprite = SpriteSheet.fromColumnsAndRows(
        image: gameRef.images.fromCache('animation_fire.png'),
        columns: 6,
        rows: 1,
      );
      add(HealthBar(position: Vector2(25, 55)));
      
      }

      
  // Spawns a new enemy at random position at the top of the screen.
  void _spawnEnemy() {
    Vector2 initialSize = Vector2(64, 64);

    // random.nextDouble() generates a random number between 0 and 1.
    // Multiplying it by gameRef.size.x makes sure that the value remains between 0 and width of screen.
    Vector2 position =
        Vector2(gameRef.size.x - 10, (random.nextDouble() * 100));

    // Clamps the vector such that the enemy sprite remains within the screen.
    position.clamp(
      Vector2.zero() + initialSize / 2,
      gameRef.size - initialSize / 2,
    );

    // Make sure that we have a valid BuildContext before using it.
    if (gameRef.buildContext != null) {
      // Get current score and figure out the max level of enemy that
      // can be spawned for this score.


      /// Gets a random [EnemyData] object from the list.
      final enemyData = _enemyDataList.elementAt(random.nextInt(4));

      Enemy enemy = Enemy(
        sprite: ballSprite.getSpriteById(enemyData.spriteId),
        size: initialSize,
        position: position,
        enemyData: enemyData,
      );

      // Makes sure that the enemy sprite is centered.
      enemy.anchor = Anchor.center;

      // Add it to components list of game instance, instead of EnemyManager.
      // This ensures the collision detection working correctly.
      gameRef.add(enemy);
    }
  }

  // For a given score, this method returns a max level
  // of enemy that can be used for spawning.
  int mapScoreToMaxEnemyLevel(int score) {
    int level = 1;

    if (score > 10) {
      level = 2;
    }

    return level;
  }

  @override
  void onMount() {
    super.onMount();
    // Start the timer as soon as current enemy manager get prepared
    // and added to the game instance.
    _timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    // Stop the timer if current enemy manager is getting removed from the
    // game instance.
    _timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update timers with delta time to make them tick.
    _timer.update(dt);
    _freezeTimer.update(dt);
  }

  // Stops and restarts the timer. Should be called
  // while restarting and exiting the game.
  void reset() {
    _timer.stop();
    _timer.start();
  }

  // Pauses spawn timer for 2 seconds when called.
  void freeze() {
    _timer.stop();
    _freezeTimer.stop();
    _freezeTimer.start();
  }

  /// A private list of all [EnemyData]s.
  static const List<EnemyData> _enemyDataList = [
    EnemyData(
      killPoint: 1,
      speed: 200,
      spriteId: 0,
      level: 1,
      hMove: false,
    ),
    EnemyData(
      killPoint: 1,
      speed: 200,
      spriteId: 1,
      level: 1,
      hMove: false,
    ),
    EnemyData(
      killPoint: 1,
      speed: 200,
      spriteId: 2,
      level: 1,
      hMove: false,
    ),
    EnemyData(
      killPoint: 1,
      speed: 200,
      spriteId: 3,
      level: 1,
      hMove: false,
    ),
    EnemyData(
      killPoint: 1,
      speed: 250,
      spriteId: 4,
      level: 2,
      hMove: false,
    ),
    EnemyData(
      killPoint: 1,
      speed: 450,
      spriteId: 5,
      level: 2,
      hMove: false,
    ),
    EnemyData(
      killPoint: 1,
      speed: 450,
      spriteId: 6,
      level: 2,
      hMove: false,
    ),
    EnemyData(
      killPoint: 1,
      speed: 450,
      spriteId: 7,
      level: 2,
      hMove: false,
    ),
  ];
}
