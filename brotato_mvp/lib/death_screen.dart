import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class GameOverlay extends FlameGame with TapDetector {
  static const String description = '''
    In this example we show how the overlays system can be used.\n\n
    If you tap the canvas the game will start and if you tap it again it will
    pause.
  ''';

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  void onTap() {
    super.onTap();
  }
}

Widget _deathMenuBuild(
  BuildContext buildContext,
  GameOverlay game,
  GestureTapCallback? onTap,
) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Jeu en pause', style: TextStyle(fontSize: 24)),
        ElevatedButton(
          onPressed: () {
            //togglePause
          },
          child: const Text('Reprendre'),
        ),
        ElevatedButton(
          onPressed: () {
            //showStartMenu
          },
          child: const Text('Menu principal'),
        ),
      ],
    ),
  );
}

Widget _showStartMenuBuild(
  BuildContext buildContext,
  GameOverlay game,
  GestureTapCallback? onTap,
) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            //startNewGame
          },
          child: const Text('Commencer'),
        ),
        ElevatedButton(
          onPressed: () => print('Options'),
          child: const Text('Options'),
        ),
      ],
    ),
  );
}

Widget _showPauseButtonBuild(
  BuildContext buildContext,
  GameOverlay game,
  GestureTapCallback? onTap,
) {
  return Positioned(
    top: 20,
    right: 20,
    child: IconButton(
      icon: const Icon(Icons.pause),
      onPressed: () {
        //togglePause
      },
    ),
  );
}

Widget _shopMenuBuild(
  BuildContext buildContext,
  GameOverlay game,
  GestureTapCallback? onTap,
) {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(20),
      color: Colors.black54,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Boutique', style: TextStyle(fontSize: 24)),
          ElevatedButton(
            onPressed: () => {
              //buyUpgrade('speed')
            },
            child: const Text('Augmenter vitesse'),
          ),
          ElevatedButton(
            onPressed: () => {
              // resumeFromShop()
            },
            child: const Text('Continuer'),
          ),
        ],
      ),
    ),
  );
}
