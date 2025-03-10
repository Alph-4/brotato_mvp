import 'package:flutter/material.dart';
import 'package:space_botato/core/constants.dart';
import 'package:space_botato/core/game.dart';

class DeathMenu extends StatelessWidget {
  static const id = 'DeathID';
  final SpaceBotatoGame game;
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
              style: kTextStyle,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: kButtonStyle,
              onPressed: () => game.startNewGame(),
              child: const Text('Try Again'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: kButtonStyle,
              onPressed: () => game.showMainMenu(),
              child: const Text('Main Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
