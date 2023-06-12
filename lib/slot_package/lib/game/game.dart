import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame/sprite.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../const/colors.dart';
import '../game/ally.dart';
import '../game/ally_manager.dart';
import '../game/background.dart';

import '../../widgets/overlays/pause_menu.dart';
import '../../widgets/overlays/pause_button.dart';
import '../../widgets/overlays/game_over_menu.dart';

import 'enemy.dart';
import 'health_bar.dart';
import 'player.dart';
import 'command.dart';
import 'audio_player_component.dart';

// This class is responsible for initializing and running the game-loop.
class MasksweirdGame extends FlameGame
    with
        HasDraggables,
        HasTappables,
        HasCollisionDetection,
        HasKeyboardHandlerComponents {
  // Stores a reference to player component.
  late Player player;
  // Stores a reference to the main spritesheet.
  // late SpriteSheet spriteSheet;
  late SpriteSheet spriteSheet;
  late SpriteAnimation noFire;
  late SpriteAnimation fire;
  late SpriteAnimation animationSlide;
  late SpriteAnimation animationJump;
  late SpriteAnimation animationKick;
  late SpriteAnimation animation5;

  // Stores a reference to an enemy manager component.
  // late EnemyManager _enemyManager;
  late AllyManager _allyManager;

  // Displays player score on top left.
  late TextComponent _playerScore;
  late TextComponent _playerScore2;

  // Displays player helth on top right.
  late TextComponent _playerHealth;
  late TextComponent _playerHealth2;
  late PositionComponent _healthBar;

  late final Background _background;

  late AudioPlayerComponent _audioPlayerComponent;

  // List of commands to be processed in current update.
  final _commandList = List<Command>.empty(growable: true);

  // List of commands to be processed in next update.
  final _addLaterCommandList = List<Command>.empty(growable: true);

  // Indicates wheater the game world has been already initilized.
  bool _isAlreadyLoaded = false;

  // This method gets called by Flame before the game-loop begins.
  // Assets loading and adding component should be done here.
  @override
  Future<void> onLoad() async {
    // Makes the game use a fixed resolution irrespective of the windows size.
    camera.viewport = FixedResolutionViewport(Vector2(540, 960));
    images.prefix = 'packages/slot_package/assets/images/';
    // Initilize the game world only one time.
    if (!_isAlreadyLoaded) {
      // Loads and caches all the images for later use.
      await images.loadAll([
        'show_case.png',
        'animation_fire.png',
        'animation_jump.png',
        'animation_kick.png',
        'animation_slide.png',
        'ally.png',
        'animation_run.png'
      ]);

      _audioPlayerComponent = AudioPlayerComponent();
      add(_audioPlayerComponent);

      _background = Background();
      await add(_background);
      spriteSheet = SpriteSheet(
        image: images.fromCache('ally.png'),
        srcSize: Vector2(100, 100),
      );

      final stars = await ParallaxComponent.load(
        [ParallaxImageData('fore.png')],
        fill: LayerFill.height,
        repeat: ImageRepeat.repeat,
        baseVelocity: Vector2(50, 0),
        velocityMultiplierDelta: Vector2(1.5, 0),
      );
      add(stars);
      noFire = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache('animation_run.png'),
        columns: 9,
        rows: 1,
      ).createAnimation(from: 0, to: 9, row: 0, stepTime: 0.08, loop: true);
      animationSlide = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache('animation_slide.png'),
        columns: 10,
        rows: 1,
      ).createAnimation(from: 0, to: 10, row: 0, stepTime: 0.1, loop: true);
      animationJump = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache('animation_jump.png'),
        columns: 8,
        rows: 1,
      ).createAnimation(from: 0, to: 8, row: 0, stepTime: 0.1, loop: true);
      animationKick = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache('animation_kick.png'),
        columns: 9,
        rows: 1,
      ).createAnimation(from: 0, to: 9, row: 0, stepTime: 0.08, loop: false);
      fire = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache('animation_fire.png'),
        columns: 6,
        rows: 1,
      ).createAnimation(from: 0, to: 5, row: 0, stepTime: 0.25, loop: true);
      // Create a basic joystick component on left.
      final joystick = JoystickComponent(
        anchor: Anchor.bottomLeft,
        position: Vector2(size.x / 2 - size.x / 3, size.y - 32),
        background: CircleComponent(
          radius: 50,
          paint: Paint()..color = AppColors.buttonColor.withOpacity(0.5),
        ),
        knob: CircleComponent(radius: 30),
      );
      add(joystick);
      player = Player(
        joystick: joystick,
        animation: noFire,
        size: Vector2(62 * 1.5, 120 * 1.5),
        position: Vector2(0, size.y / 1.8),
      );

      // Makes sure that the sprite is centered.
      player.anchor = Anchor.center;
      add(player);
      _healthBar = HealthBar(
          player: player, position: Vector2(size.x - 150, size.y - 250));
      add(_healthBar);
      _allyManager = AllyManager(spriteSheet: spriteSheet);
      add(_allyManager);
      // add(_enemyManager);
      final button = ButtonComponent(
        button: CircleComponent(
          radius: 60,
          paint: Paint()..color = AppColors.buttonColor.withOpacity(0.5),
        ),
        anchor: Anchor.bottomRight,
        position: Vector2(
            size.x - AppColors.randomPadding, size.y - AppColors.randomPadding),
        onPressed: player.jump,
      );
      add(button);
      // Create text component for player score.
      _playerScore = TextComponent(
        position: Vector2(30, size.y - 250),
        textRenderer: TextPaint(
          style: TextStyle(
              background: Paint()..color = AppColors.backColor.withOpacity(0.5),
              letterSpacing: 5,
              fontFamily: 'RobotoSlab',
              fontSize: 22,
              color: AppColors.backColor,
              fontWeight: FontWeight.normal),
        ),
      );
      _playerScore2 = TextComponent(
        position: Vector2(28, size.y - 250 - 2),
        textRenderer: TextPaint(
            style: TextStyle(
                letterSpacing: 5,
                fontFamily: 'RobotoSlab',
                fontSize: 22,
                fontStyle: FontStyle.normal,
                foreground: Paint()
                  ..style = PaintingStyle.fill
                  ..strokeWidth = 3
                  ..color = AppColors.frontColor,
                fontWeight: FontWeight.normal)),
      );
      // Setting positionType to viewport makes sure that this component
      // does not get affected by camera's transformations.
      _playerScore.positionType = PositionType.viewport;
      _playerScore2.positionType = PositionType.viewport;
      _healthBar.positionType = PositionType.viewport;

      add(_playerScore);
      add(_playerScore2);

      // Create text component for player health.
      _playerHealth = TextComponent(
        position: Vector2(size.x - 70, size.y - 180),
        textRenderer: TextPaint(
          style: TextStyle(
              background: Paint()..color = AppColors.backColor.withOpacity(0.5),
              letterSpacing: 5,
              fontFamily: 'Jost',
              fontSize: 22,
              color: AppColors.backColor,
              fontWeight: FontWeight.normal),
        ),
      );
      _playerHealth2 = TextComponent(
        position: Vector2(size.x - 70, size.y - 180 - 2),
        textRenderer: TextPaint(
          style: TextStyle(
              letterSpacing: 5,
              fontFamily: 'Jost',
              fontSize: 22,
              foreground: Paint()
                ..style = PaintingStyle.fill
                ..strokeWidth = 1
                ..color = Colors.pink,
              fontWeight: FontWeight.normal),
        ),
      );

      // Anchor to top right as we want the top right
      // corner of this component to be at a specific position.
      _playerHealth.anchor = Anchor.topRight;
      _playerHealth2.anchor = Anchor.topRight;
      _healthBar.anchor = Anchor.center;

      // // Setting positionType to viewport makes sure that this component
      // // does not get affected by camera's transformations.
      _playerHealth.positionType = PositionType.viewport;
      _playerHealth2.positionType = PositionType.viewport;

      add(_playerHealth);
      add(_playerHealth2);

      // Set this to true so that we do not initilize
      // everything again in the same session.
      _isAlreadyLoaded = true;
    }
  }

  // This method gets called when game instance gets attached
  // to Flutter's widget tree.
  @override
  void onAttach() {
    if (buildContext != null) {}
    _audioPlayerComponent.playBgm('music.mp3');
    super.onAttach();
  }

  @override
  void onDetach() {
    _audioPlayerComponent.stopBgm();
    super.onDetach();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (animationKick.isLastFrame) {
      player.compl();
    }
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

    if (player.isMounted) {
      // Update score and health components with latest values.
      _playerScore.text = 'Score: ${player.score}';
      _playerScore2.text = 'Score: ${player.score}';
      _playerHealth.text = 'Life';
      _playerHealth2.text = 'Life';

      /// Display [GameOverMenu] when [Player.health] becomes
      /// zero and camera stops shaking.
      if (player.health <= 0 && (!camera.shaking)) {
        pauseEngine();
        overlays.remove(PauseButton.id);
        overlays.add(GameOverMenu.id);
      }
    }
  }

  // This method handles state of app and pauses
  // the game when necessary.
  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (player.health > 0) {
          pauseEngine();
          overlays.remove(PauseButton.id);
          overlays.add(PauseMenu.id);
        }
        break;
    }

    super.lifecycleStateChange(state);
  }

  // Adds given command to command list.
  void addCommand(Command command) {
    _addLaterCommandList.add(command);
  }

  // Resets the game to inital state. Should be called
  // while restarting and exiting the game.
  void reset() {
    // First reset player, enemy manager and power-up manager .
    player.reset();
    _allyManager.reset();
    player.animation = noFire;
    children.whereType<Enemy>().forEach((enemy) {
      enemy.removeFromParent();
    });
  }

  void resetAlly() {
    children.whereType<Ally>().forEach((ally) {
      ally.removeFromParent();
    });
  }
}
