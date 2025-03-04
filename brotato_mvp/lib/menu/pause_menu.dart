import 'package:brotato_mvp/game.dart';
import 'package:brotato_mvp/main.dart';
import 'package:flutter/material.dart';

class PauseMenu extends StatelessWidget {
  static const id = 'PauseID';
  final BrotatoGame game;
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
