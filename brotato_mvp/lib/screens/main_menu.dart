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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_screen.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Space Botato',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 20),
              Flexible(
                  child: Align(
                    alignment: AlignmentDirectional(0,0),
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  SizedBox(height: 8),
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
              ),)),
              Text(
                'v1.0.0',
                style: Theme.of(context).textTheme.bodyLarge,
              )
            ],
          ),
        ),
      ),
    );
  }
}
