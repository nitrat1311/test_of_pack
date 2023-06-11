import 'package:flame/experimental.dart';
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
        HasTappableComponents,
        HasCollisionDetection,
        HasTappablesBridge,
        HasKeyboardHandlerComponents {
  // List of commands to be processed in current update.
  bool isReset = false;
  double health = 100;
  int currentScore = 0;
  double playerSpeed = 200;

  late final RouterComponent router;
  late TextComponent _playerScore;
  late TextComponent _playerScore2;
  late TextComponent _playerHealth;
  late TextComponent _playerHealth2;
  late PositionComponent _playerHealthBar;

  @override
  Future<void> onLoad() async {
    add(
      router = RouterComponent(
        routes: {
          'home': Route(StartPage.new),
          'level1': Route(Level1Page.new, maintainState: false),
          'level2': Route(Level2Page.new),
        },
        initialRoute: 'home',
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

  void reset() {
    health = 100;
    isReset = true;
    children.whereType<Enemy>().forEach((e) => e.removeFromParent());
    children.whereType<Ally>().forEach((e) => e.removeFromParent());
    children.whereType<EnemyManager>().forEach((e) => e.removeFromParent());
    children.whereType<AllyManager>().forEach((e) => e.reset());
  }

  void resetAlly() {
    children.whereType<Ally>().forEach((e) => e.removeFromParent());
    children.whereType<AllyManager>().forEach((e) => e.reset());
  }
}

class Level1Page extends Component with HasGameRef<MasksweirdGame> {
  late Player player;
  late Fense fence;
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

  bool _isAlreadyLoaded = false;

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

      _background = Background(gameBackPath: 'game_back.png');
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
        fireImgPath: 'animation_fire.png',
        animationRightPath: 'animation_right.png',
        animationForwardPath: 'animation_forward.png',
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

    if (gameRef.isReset && fence.fenceHealth < 100 ||
        _allyManager.allies.length < 2) {
      fence.fenseReset();
      if (fence.isRemoved) {
        add(fence);
      }
      if (_allyManager.isRemoved) {
        add(_allyManager);
      }

      gameRef.isReset = false;
    }
    if (player.animationRight.isLastFrame) {
      player.compl();
    }

    if (player.isMounted) {
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

class Level2Page extends Component with HasGameRef<MasksweirdGame> {
  late Player player;
  late Fense fence;
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

  bool _isAlreadyLoaded = false;

  @override
  Future<void> onLoad() async {
    // images.prefix = 'packages/${AppColors.myPackage}/assets/images/';
    // Makes the game use a fixed resolution irrespective of the windows size.
    gameRef.camera.viewport = FixedResolutionViewport(Vector2(540, 960));

    // Initilize the game world only one time.
    if (!_isAlreadyLoaded) {
      // Loads and caches all the images for later use.

      await game.images.loadAll([
        'animation_fire2.png',
        'animation_right2.png',
        'animation_forward2.png',
        'ally2.png'
      ]);

      _audioPlayerComponent = AudioPlayerComponent();
      add(_audioPlayerComponent);

      _background = Background(gameBackPath: 'game_back2.png');
      await add(_background);
      sprite = Sprite(gameRef.images.fromCache('ally2.png'));

      no_fire = SpriteSheet.fromColumnsAndRows(
        image: gameRef.images.fromCache('animation_right2.png'),
        columns: 4,
        rows: 1,
      ).createAnimation(from: 0, to: 1, row: 0, stepTime: 0.2, loop: false);

      fire = SpriteSheet.fromColumnsAndRows(
        image: gameRef.images.fromCache('animation_fire2.png'),
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
        fireImgPath: 'animation_fire2.png',
        animationRightPath: 'animation_right2.png',
        animationForwardPath: 'animation_forward2.png',
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

    if (gameRef.isReset && fence.fenceHealth < 100 ||
        _allyManager.allies.length < 2) {
      fence.fenseReset();
      if (fence.isRemoved) {
        add(fence);
      }
      if (_allyManager.isRemoved) {
        add(_allyManager);
      }

      gameRef.isReset = false;
    }
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

class StartPage extends Component with HasGameRef<MasksweirdGame> {
  StartPage() {
    addAll([
      _logo = TextComponent(
        text: 'Syzygy',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 64,
            color: Color(0xFFC8FFF5),
            fontWeight: FontWeight.w800,
          ),
        ),
        anchor: Anchor.center,
      ),
      _button1 = RoundedButton(
        text: 'Level 1',
        action: () => gameRef.router.pushNamed('level1'),
        color: const Color(0xffadde6c),
        borderColor: const Color(0xffedffab),
      ),
      _button2 = RoundedButton(
        text: 'Level 2',
        action: () => gameRef.router.pushNamed('level2'),
        color: const Color(0xffdebe6c),
        borderColor: const Color(0xfffff4c7),
      ),
    ]);
  }

  late final TextComponent _logo;
  late final RoundedButton _button1;
  late final RoundedButton _button2;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _logo.position = Vector2(size.x / 2, size.y / 3);
    _button1.position = Vector2(size.x / 2, _logo.y + 80);
    _button2.position = Vector2(size.x / 2, _logo.y + 140);
  }
}

class RoundedButton extends PositionComponent with TapCallbacks {
  RoundedButton({
    required this.text,
    required this.action,
    required Color color,
    required Color borderColor,
    super.anchor = Anchor.center,
  }) : _textDrawable = TextPaint(
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFF000000),
            fontWeight: FontWeight.w800,
          ),
        ).toTextPainter(text) {
    size = Vector2(150, 40);
    _textOffset = Offset(
      (size.x - _textDrawable.width) / 2,
      (size.y - _textDrawable.height) / 2,
    );
    _rrect = RRect.fromLTRBR(0, 0, size.x, size.y, Radius.circular(size.y / 2));
    _bgPaint = Paint()..color = color;
    _borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = borderColor;
  }

  final String text;
  final void Function() action;
  final TextPainter _textDrawable;
  late final Offset _textOffset;
  late final RRect _rrect;
  late final Paint _borderPaint;
  late final Paint _bgPaint;

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_rrect, _bgPaint);
    canvas.drawRRect(_rrect, _borderPaint);
    _textDrawable.paint(canvas, _textOffset);
  }

  @override
  void onTapDown(TapDownEvent event) {
    scale = Vector2.all(1.05);
  }

  @override
  void onTapUp(TapUpEvent event) {
    scale = Vector2.all(1.0);
    action();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    scale = Vector2.all(1.0);
  }
}
