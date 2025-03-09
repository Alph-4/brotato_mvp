import 'package:flutter/material.dart';
import 'package:space_botato/core/game.dart';

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
            GestureDetector(
              onTap: () => game.resumeGame(),
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue,
                ),
                child: Center(child: Text('Resume')),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                game.resetGame();
                game.showMainMenu();
              },
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue,
                ),
                child: Center(child: Text('Main Menu')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
