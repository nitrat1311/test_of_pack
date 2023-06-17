library slot_package;

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../const_colors.dart';
import '../pause_menu.dart';
import '../pause_btn.dart';
import '../over_menu.dart';

import 'background.dart';
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

  late SpriteSheet spriteSheet;

  // List of commands to be processed in next update.
  final _addLaterCommandList = List<Command>.empty(growable: true);

  late AudioPlayerComponent audioPlayerComponent;
  late final Background _background;
  // List of commands to be processed in current update.
  final _commandList = List<Command>.empty(growable: true);

  // Indicates wheater the game world has been already initilized.
  bool _isAlreadyLoaded = false;

  late TextComponent _playerScore;
  late TextComponent _playerScore2;

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

  // This method gets called when game instance gets attached
  // to Flutter's widget tree.
  @override
  void onAttach() {
    if (buildContext != null) {}

    audioPlayerComponent.playBgm('music.mp3');
    super.onAttach();
  }

  @override
  void onDetach() {
    audioPlayerComponent.stopBgm();
    super.onDetach();
  }

  // This method gets called by Flame before the game-loop begins.
  // Assets loading and adding component should be done here.
  @override
  Future<void> onLoad() async {
    // Makes the game use a fixed resolution irrespective of the windows size.
    camera.viewport = FixedResolutionViewport(Vector2(540, 960));

    // Initilize the game world only one time.
    if (!_isAlreadyLoaded) {
      // Loads and caches all the images for later use.
      // await images.loadAll([
      //   'lib/screens/slot_pack/assets/images/show_case.png',
      // ]);

      audioPlayerComponent = AudioPlayerComponent();
      add(audioPlayerComponent);

      _background = Background();
      await add(_background);

      player = Player(
        size: Vector2(62 * 1.5, 120 * 1.5),
        position: Vector2(0, size.y / 1.8),
      );

      // // Makes sure that the sprite is centered.
      player.anchor = Anchor.center;
      add(player);

      _playerScore = TextComponent(
        position:
            Vector2(size.x / 2 - 35, AppColors.scoreY.toDouble() / 2 - 40),
        textRenderer: TextPaint(
          style: TextStyle(
              letterSpacing: 10,
              fontFamily: 'Delicious',
              fontSize: 40,
              fontStyle: FontStyle.italic,
              foreground: Paint()
                ..maskFilter = MaskFilter.blur(BlurStyle.outer, 10)
                ..style = PaintingStyle.fill
                ..strokeWidth = 1
                ..color = Colors.redAccent,
              fontWeight: FontWeight.normal),
        ),
      );
      _playerScore2 = TextComponent(
        position:
            Vector2((size.x / 2 - 35), AppColors.scoreY.toDouble() / 2 - 42),
        textRenderer: TextPaint(
            style: TextStyle(
                letterSpacing: 10,
                fontFamily: 'Delicious',
                fontSize: 40,
                fontStyle: FontStyle.italic,
                foreground: Paint()
                  ..maskFilter = MaskFilter.blur(BlurStyle.inner, 2)
                  ..style = PaintingStyle.fill
                  ..strokeWidth = 1
                  ..color = Colors.white,
                fontWeight: FontWeight.bold)),
      );
      // Setting positionType to viewport makes sure that this component
      // does not get affected by camera's transformations.
      _playerScore.positionType = PositionType.viewport;
      _playerScore2.positionType = PositionType.viewport;

      add(_playerScore);
      add(_playerScore2);

      // Set this to true so that we do not initilize
      // everything again in the same session.
      _isAlreadyLoaded = true;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // if (animationKick.isLastFrame) {
    //   player.compl();
    // }
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
      _playerScore.text = '${player.score + 50}';
      _playerScore2.text = '${player.score + 50}';

      /// Display [GameOverMenu] when [Player.health] becomes
      /// zero and camera stops shaking.
      if (player.health <= 0 && (!camera.shaking)) {
        pauseEngine();
        overlays.remove(PauseButton.id);
        overlays.add(OverMenu.id);
      }
    }
  }

  // Adds given command to command list.
  void addCommand(Command command) {
    _addLaterCommandList.add(command);
  }

  // Resets the game to inital state. Should be called
  // while restarting and exiting the game.
  void reset(context) {
    // First reset player, enemy manager and power-up manager .
    player.reset();
  }
}
