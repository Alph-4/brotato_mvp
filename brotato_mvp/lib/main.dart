import 'dart:io';
import 'dart:math';
import 'package:brotato_mvp/bullet.dart';
import 'package:brotato_mvp/enemy.dart';
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
  runApp(
    GameWidget(
      game: BrotatoGame(),
    ),
  );
}

enum GameState {
  menu,
  playing,
  paused,
  dead,
  shopping,
}

class BrotatoGame extends FlameGame with HasCollisionDetection {
  GameState state = GameState.menu;

  // Gestion des overlays
  static const String pauseButtonKey = 'pause_button';
  static const String pauseMenuKey = 'pause_menu';
  static const String deathMenuKey = 'death_menu';
  static const String shopMenuKey = 'shop_menu';
  static const String startMenuKey = 'start_menu';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: GameWidget(
      game: this,
      overlayBuilderMap: {
        MainMenu.id: (context, game) => MainMenu(game: game as BrotatoGame),
        pauseMenuKey: (context, game) => PauseMenu(game: game as BrotatoGame),
        deathMenuKey: (context, game) => DeathMenu(game: game as BrotatoGame),
        shopMenuKey: (context, game) => ShopMenu(game: game as BrotatoGame),
      },
    )));
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await Flame.device.setLandscape();
    await Flame.device.fullScreen();
    showMainMenu();
  }

  void showMainMenu() {
    state = GameState.menu;
    overlays.add(MainMenu.id);
  }

  void startNewGame() {
    state = GameState.playing;
    overlays.remove(MainMenu.id);
    // Réinitialiser le jeu
    children.whereType<Enemy>().forEach(remove);
    children.whereType<Bullet>().forEach(remove);
    // Ajouter le joueur si nécessaire
  }

  void pauseGame() {
    state = GameState.paused;
    pauseEngine();
    overlays.add(pauseMenuKey);
  }

  void resumeGame() {
    state = GameState.playing;
    overlays.remove(pauseMenuKey);
    resumeEngine();
  }

  void showDeathMenu() {
    state = GameState.dead;
    overlays.add(deathMenuKey);
  }

  void showShopMenu() {
    state = GameState.shopping;
    pauseEngine();
    overlays.add(shopMenuKey);
  }

  void resumeFromShop() {
    state = GameState.playing;
    overlays.remove(shopMenuKey);
    resumeEngine();
  }

  void buyUpgrade(String type) {
    // Logique d'achat
    resumeFromShop();
  }

  // Ajouter cette méthode pour gérer la mort du joueur
  void onPlayerDeath() {
    showDeathMenu();
    children.whereType<Enemy>().forEach(remove);
  }

  @override
  void update(double dt) {
    if (state != GameState.playing) return;
    super.update(dt);
  }
}

const textStyle = TextStyle(
  color: Colors.white,
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

final buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blueGrey[800],
  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
);
