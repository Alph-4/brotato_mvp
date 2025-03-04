import 'dart:io';
import 'dart:math';
import 'package:brotato_mvp/bullet.dart';
import 'package:brotato_mvp/enemy.dart';
import 'package:brotato_mvp/game.dart';
import 'package:brotato_mvp/menu/death_menu.dart';
import 'package:brotato_mvp/menu/main_menu.dart';
import 'package:brotato_mvp/menu/pause_menu.dart';
import 'package:brotato_mvp/menu/shop_menu.dart';
import 'package:brotato_mvp/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'dart:async' as da;

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

final _game = BrotatoGame();

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
          body: GameWidget<BrotatoGame>(
            game: kDebugMode ? BrotatoGame() : _game,
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
