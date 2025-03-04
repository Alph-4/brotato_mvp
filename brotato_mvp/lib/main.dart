import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:space_botato/menu/death_menu.dart';
import 'package:space_botato/menu/main_menu.dart';
import 'package:space_botato/menu/pause_menu.dart';

import 'game.dart';
import 'menu/shop_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
   MyApp()
  );
}

enum GameState {
  menu,
  playing,
  paused,
  dead,
  shopping,
}

final _game = SpaceBotatoGame();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Platformer',
      theme: ThemeData.dark(),
      home: SafeArea(
        child: Scaffold(
          body: GameWidget<SpaceBotatoGame>(
            game: kDebugMode ? SpaceBotatoGame() : _game,
            overlayBuilderMap: {
              MainMenu.id: (context, game) => MainMenu(game: game),
              PauseMenu.id: (context, game) => PauseMenu(game: game),
              DeathMenu.id: (context, game) => DeathMenu(game: game),
              ShopMenu.id: (context, game) => ShopMenu(game: game),
            },
            initialActiveOverlays: const [MainMenu.id],
          ),
        ),
      ),
    );
  }
}
