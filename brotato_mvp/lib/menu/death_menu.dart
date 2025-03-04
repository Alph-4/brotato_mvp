import 'package:brotato_mvp/game.dart';
import 'package:brotato_mvp/main.dart';
import 'package:flutter/material.dart';

class DeathMenu extends StatelessWidget {
  static const id = 'DeathID';
  final BrotatoGame game;
  const DeathMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GAME OVER',
              style: textStyle,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () => game.startNewGame(),
              child: const Text('Try Again'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () => game.showMainMenu(),
              child: const Text('Main Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
