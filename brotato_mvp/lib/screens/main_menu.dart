import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:space_botato/core/game.dart';

class MainMenu extends StatelessWidget {
  static const id = 'MainID';
  final SpaceBotatoGame game;
  const MainMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Space Botato',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                game.startNewGame();
              },
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue,
                ),
                child: Center(child: Text('Play')),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                //Navigator.of(context).pushNamed(SettingsMenu.id);
              },
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue,
                ),
                child: Center(child: Text('Settings')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
