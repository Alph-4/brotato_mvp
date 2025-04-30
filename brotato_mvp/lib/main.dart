import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:space_botato/core/constants.dart';
import 'package:space_botato/core/game.dart';
import 'package:space_botato/screens/main_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

enum GameState {
  menu,
  playing,
  paused,
  dead,
  shopping,
  win,
}

final _game = SpaceBotatoGame();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Space Botato',
      theme: ThemeData.dark(),
      home: SafeArea(
        child: Scaffold(
          body: GameWidget<SpaceBotatoGame>(
            game: kDebugMode ? SpaceBotatoGame() : _game,
            overlayBuilderMap: gameOverlays,
            initialActiveOverlays: const [MainMenu.id],
          ),
        ),
      ),
    );
  }
}
