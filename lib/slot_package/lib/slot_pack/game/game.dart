import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame/sprite.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:slot_package/slot_pack/game/fense.dart';

import '../../const_colors.dart';
import '../game/ally.dart';
import '../game/ally_manager.dart';

import '../game/background.dart';

import '../widgets/overlays/pause_menu.dart';
import '../widgets/overlays/pause_button.dart';
import '../widgets/overlays/game_over_menu.dart';

import 'enemy.dart';
import 'health_bar.dart';
import 'player.dart';
import 'command.dart';
import 'enemy_manager.dart';
import 'audio_player_component.dart';

// This class is responsible for initializing and running the game-loop.

class MasksweirdGame extends FlameGame
    with
        HasDraggables,
        HasTappables,
        HasCollisionDetection,
        HasKeyboardHandlerComponents {
  // List of commands to be processed in current update.

  double health = 100;
  int currentScore = 0;
  double playerSpeed = 200;

  late final RouterComponent router;
  late TextComponent _playerScore;
  late TextComponent _playerScore2;

  // Displays player helth on top right.
  late TextComponent _playerHealth;
  late TextComponent _playerHealth2;
  late PositionComponent _playerHealthBar;

  @override
  Future<void> onLoad() async {
    add(
      router = RouterComponent(
        routes: {
          'level1': Route(Level1Page.new),
          // 'level2': Route(Level2Page.new),
        },
        initialRoute: 'level1',
      ),
    );
    _playerHealthBar = HealthBar(
        position: Vector2(size.x - 150, AppColors.randomPadding * 1.5));
    _playerScore = TextComponent(
      position: Vector2(
          size.x / 2 - AppColors.randomPadding * 2.5, AppColors.randomPadding),
      textRenderer: TextPaint(
        style: const TextStyle(
            letterSpacing: 5,
            fontFamily: 'LibreBaskerville',
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.normal),
      ),
    );
    _playerScore2 = TextComponent(
      position: Vector2(size.x / 2 - AppColors.randomPadding * 2.5,
          AppColors.randomPadding - 2),
      textRenderer: TextPaint(
          style: TextStyle(
              letterSpacing: 5,
              fontFamily: 'LibreBaskerville',
              fontSize: 22,
              fontStyle: FontStyle.normal,
              foreground: Paint()
                ..style = PaintingStyle.fill
                ..strokeWidth = 1
                ..color = AppColors.frontColor,
              fontWeight: FontWeight.normal)),
    );
    _playerHealth = TextComponent(
      position: Vector2(
          size.x - AppColors.randomPadding - 2, AppColors.randomPadding),
      textRenderer: TextPaint(
        style: const TextStyle(
            letterSpacing: 5,
            fontFamily: 'LibreBaskerville',
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.normal),
      ),
    );
    _playerHealth2 = TextComponent(
      position: Vector2(
          size.x - AppColors.randomPadding, AppColors.randomPadding - 2),
      textRenderer: TextPaint(
        style: TextStyle(
            letterSpacing: 5,
            fontFamily: 'LibreBaskerville',
            fontSize: 22,
            foreground: Paint()
              ..style = PaintingStyle.fill
              ..strokeWidth = 1
              ..color = AppColors.frontColor,
            fontWeight: FontWeight.normal),
      ),
    );
    _playerScore.positionType = PositionType.viewport;
    _playerScore2.positionType = PositionType.viewport;
    _playerHealthBar.positionType = PositionType.viewport;
    _playerHealth.positionType = PositionType.viewport;
    _playerHealth2.positionType = PositionType.viewport;
    _playerHealth.anchor = Anchor.topRight;
    _playerHealth2.anchor = Anchor.topRight;
    _playerHealthBar.anchor = Anchor.center;
    add(_playerHealthBar);
    add(_playerScore);
    add(_playerScore2);
    add(_playerHealth);
    add(_playerHealth2);
  }

  @override
  void onMount() {
    _playerScore.text = 'Score: $currentScore';
    _playerScore2.text = 'Score: $currentScore';
    _playerHealth.text = 'Health';
    _playerHealth2.text = 'Health';
    super.onMount();
  }

  @override
  void update(double dt) {
    for (var command in _commandList) {
      for (var component in children) {
        command.run(component);
      }
    }

    // Remove all the commands that are processed and
    // add all new commands to be processed in next update.
    _commandList.clear();
    _commandList.addAll(_addLaterCommandList);
    _addLaterCommandList.clear();
    super.update(dt);
  }

  void reset() {
    health = 100;
    children.whereType<Player>().forEach((pl) {
      pl.reset();
      pl.animation = pl.no_fire;
    });
    children.whereType<EnemyManager>().forEach((em) {
      em.reset();
    });
    children.whereType<AllyManager>().forEach((am) {
      am.reset();
    });
    children.whereType<AllyManager>().forEach((am) {
      am.reset();
    });

    children.whereType<Enemy>().forEach((enemy) {
      enemy.removeFromParent();
    });
  }

  final _commandList = List<Command>.empty(growable: true);

  // List of commands to be processed in next update.
  final _addLaterCommandList = List<Command>.empty(growable: true);
  // Adds given command to command list.
  void addCommand(Command command) {
    _addLaterCommandList.add(command);
  }

  void resetAlly() {
    children.whereType<Ally>().forEach((ally) {
      ally.removeFromParent();
    });
  }
}

class Level1Page extends Component with HasGameRef<MasksweirdGame> {
  // Stores a reference to player component.
  late Player player;
  late Fense fence;
  // Stores a reference to the main spritesheet.
  // late SpriteSheet spriteSheet;
  late Sprite sprite;

  late SpriteAnimation fire;
  late SpriteAnimation no_fire;
  // Stores a reference to an enemy manager component.
  late EnemyManager _enemyManager;
  late AllyManager _allyManager;
  late PositionComponent _healthBar2;
  // Displays player score on top left.

  late final Background _background;

  late AudioPlayerComponent _audioPlayerComponent;

  // Indicates wheater the game world has been already initilized.
  bool _isAlreadyLoaded = false;

  // This method gets called by Flame before the game-loop begins.
  // Assets loading and adding component should be done here.
  @override
  Future<void> onLoad() async {
    // images.prefix = 'packages/${AppColors.myPackage}/assets/images/';
    // Makes the game use a fixed resolution irrespective of the windows size.
    gameRef.camera.viewport = FixedResolutionViewport(Vector2(540, 960));

    // Initilize the game world only one time.
    if (!_isAlreadyLoaded) {
      // Loads and caches all the images for later use.

      await game.images.loadAll([
        'animation_fire.png',
        'animation_right.png',
        'animation_forward.png',
        'ally.png'
      ]);

      _audioPlayerComponent = AudioPlayerComponent();
      add(_audioPlayerComponent);

      _background = Background();
      await add(_background);
      sprite = Sprite(gameRef.images.fromCache('ally.png'));

      no_fire = SpriteSheet.fromColumnsAndRows(
        image: gameRef.images.fromCache('animation_right.png'),
        columns: 4,
        rows: 1,
      ).createAnimation(from: 0, to: 1, row: 0, stepTime: 0.2, loop: false);

      fire = SpriteSheet.fromColumnsAndRows(
        image: gameRef.images.fromCache('animation_fire.png'),
        columns: 6,
        rows: 1,
      ).createAnimation(from: 0, to: 5, row: 0, stepTime: 0.25, loop: true);
      // Create a basic joystick component on left.
      final joystick = JoystickComponent(
        anchor: Anchor.bottomLeft,
        position: Vector2(
            gameRef.size.x / 2 - gameRef.size.x / 3, gameRef.size.y - 32),
        background: CircleComponent(
          radius: 50,
          paint: Paint()..color = AppColors.buttonColor.withOpacity(0.5),
        ),
        knob: CircleComponent(radius: 28),
      );
      add(joystick);
      fence = Fense(
          sprite: sprite,
          position: Vector2(gameRef.size.x / 2 + 20, gameRef.size.y / 2),
          size: Vector2(64 * 1.3, 64 * 1.3));
      add(fence);

      _healthBar2 = HealthBar(
        fence: fence,
        position: Vector2(gameRef.size.x / 2 + 20, gameRef.size.y / 2 - 50),
      );

      add(_healthBar2);
      player = Player(
        joystick: joystick,
        animation: no_fire,
        size: Vector2(179 / 2, 250 / 2),
        position: Vector2(0, gameRef.size.y / 1.9),
      );

      // Makes sure that the sprite is centered.
      player.anchor = Anchor.center;
      add(player);

      _enemyManager = EnemyManager(spriteSheet: fire, player: player);
      _allyManager = AllyManager(sprite: sprite);
      add(_allyManager);
      add(_enemyManager);
      final button = ButtonComponent(
        button: CircleComponent(
          radius: 60,
          paint: Paint()..color = AppColors.buttonColor.withOpacity(0.5),
        ),
        anchor: Anchor.bottomRight,
        position: Vector2(gameRef.size.x - 30, gameRef.size.y - 30),
        onPressed: player.jump,
      );
      add(button);
      // Create text component for player score.

      // // Setting positionType to viewport makes sure that this component
      // // does not get affected by camera's transformations.

      // Set this to true so that we do not initilize
      // everything again in the same session.
      _isAlreadyLoaded = true;
    }
  }

  // This method gets called when game instance gets attached
  // to Flutter's widget tree.
  void onAttach() {
    if (gameRef.buildContext != null) {
      // Get the PlayerData from current build context without registering a listener.
      // final playerData = Provider.of<PlayerData>(buildContext!, listen: false);
      // Update the current spaceship type of player.
      // _player.setSpaceshipType(playerData.spaceshipType);
    }
    _audioPlayerComponent.playBgm('music.mp3');
    super.gameRef.onAttach();
  }

  void onDetach() {
    _audioPlayerComponent.stopBgm();
    super.gameRef.onDetach();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // if (_player.health < 80 && _player.health > 40) {
    //   _player.animation = animation2;
    // }

    if (player.animationRight.isLastFrame) {
      player.compl();
    }

    if (player.isMounted) {
      // Update score and health components with latest values.

      /// Display [GameOverMenu] when [Player.health] becomes
      /// zero and camera stops shaking.
      if (gameRef.health <= 0 && (!gameRef.camera.shaking)) {
        // _audioPlayerComponent.playSfx('audio/game_over.mp3');
        gameRef.pauseEngine();
        gameRef.overlays.remove(PauseButton.id);
        gameRef.overlays.add(GameOverMenu.id);
      }
    }
  }

  // This method handles state of app and pauses
  // the game when necessary.
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (gameRef.health > 0) {
          gameRef.pauseEngine();
          gameRef.overlays.remove(PauseButton.id);
          gameRef.overlays.add(PauseMenu.id);
        }
        break;
    }

    super.gameRef.lifecycleStateChange(state);
  }

  // Resets the game to inital state. Should be called
  // while restarting and exiting the game.
}
