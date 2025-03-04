import 'package:brotato_mvp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainMenu extends StatelessWidget {
  static const id = 'main_menu';
  final BrotatoGame game;
  const MainMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Brotato',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                game.startNewGame();
                //Navigator.of(context).pushNamed(BrotatoGame.id);
              },
              child: Text('Play'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                //Navigator.of(context).pushNamed(SettingsMenu.id);
              },
              child: Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
