import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import '../game/ally.dart';
import '../models/ally_data.dart';
import 'game.dart';
import 'knows_game_size.dart';


// This component class takes care of spawning new enemy components
// randomly from top of the screen. It uses the HasGameRef mixin so that
// it can add child components.
class AllyManager extends Component
    with KnowsGameSize, HasGameRef<MasksweirdGame> {
  // The timer which runs the enemy spawner code at regular interval of time.
  late Timer _timer;

  // A reference to spriteSheet contains enemy sprites.
  Sprite sprite;

  // Holds an object of Random class to generate random numbers.
  Random random = Random();

  AllyManager({required this.sprite}) : super() {
    _timer = Timer(0, onTick: _spawnAlly, repeat: false);
  }

  // Spawns a new enemy at random position at the top of the screen.
  void _spawnAlly() {
    Vector2 initialSize = Vector2(257/2, 156/2);

    // random.nextDouble() generates a random number between 0 and 1.
    // Multiplying it by gameRef.size.x makes sure that the value remains between 0 and width of screen.
    Vector2 position = Vector2(gameRef.size.x - 32,
        (gameRef.size.y - 160) - 300 * random.nextDouble());

    // Make sure that we have a valid BuildContext before using it.
    if (gameRef.buildContext != null) {
      // Get current score and figure out the max level of enemy that
      // can be spawned for this score.

      /// Gets a random [EnemyData] object from the list.
      final enemyData = _enemyDataList.elementAt(0);

      Ally enemy = Ally(
        sprite: sprite,
        size: initialSize,
        position: position,
        allyData: enemyData,
      );

      // Makes sure that the enemy sprite is centered.
      enemy.anchor = Anchor.center;

      // Add it to components list of game instance, instead of EnemyManager.
      // This ensures the collision detection working correctly.
      gameRef.add(enemy);
    }
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
  }

  // Stops and restarts the timer. Should be called
  // while restarting and exiting the game.
  void reset() {
    _timer.stop();
    _timer.start();
  }

  /// A private list of all [AllyData]s.
  static const List<AllyData> _enemyDataList = [
    AllyData(
      killPoint: 1,
      speed: 250,
      spriteId: 1,
      level: 1,
      hMove: false,
    ),
  ];
}
