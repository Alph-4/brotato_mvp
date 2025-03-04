import 'package:flutter/material.dart';
import 'package:space_botato/game.dart';

class PauseMenu extends StatelessWidget {
  static const id = 'PauseID';
  final SpaceBotatoGame game;
  const PauseMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PAUSED',
              style: textStyle,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () => game.resumeGame(),
              child: const Text('Resume'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                game.showMainMenu();
              },
              child: const Text('Main Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
