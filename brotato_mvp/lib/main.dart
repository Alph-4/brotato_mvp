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
  late Player player;
  late JoystickComponent joystick;
  List<Enemy> enemies = [];
  int wave = 1;

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

    // Initialisation du joystick
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: Paint()..color = Colors.red),
      background: CircleComponent(
        radius: 60,
        paint: Paint()..color = Colors.grey.withAlpha(50),
      ),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    add(joystick);

    showMainMenu();
  }

  void showMainMenu() {
    state = GameState.menu;
    overlays.add(MainMenu.id);
  }

  void startNewGame() {
    state = GameState.playing;
    overlays.remove(MainMenu.id);
    wave = 1;

    // Réinitialiser le jeu
    enemies.clear();
    children.whereType<Enemy>().forEach(remove);
    children.whereType<Bullet>().forEach(remove);

    // Créer et ajouter le joueur
    player = Player();
    player.position = size / 2;
    add(player);
    add(player.healthBar);

    // Démarrer le spawn des ennemis et le tir automatique
    startSpawningEnemies();
    startAutoShoot();
  }

  void startAutoShoot() {
    da.Timer.periodic(Duration(seconds: 1), (timer) {
      if (state != GameState.playing) return;

      final enemies = children.whereType<Enemy>().toList();
      if (enemies.isEmpty) return;

      Vector2 playerPos = player.position;
      Enemy? closestEnemy;
      double closestDistance = double.infinity;

      for (final enemy in enemies) {
        final distance = (enemy.position - playerPos).length;
        if (distance < closestDistance) {
          closestDistance = distance;
          closestEnemy = enemy;
        }
      }

      if (closestEnemy != null) {
        final direction = (closestEnemy.position - playerPos).normalized();
        final bullet = Bullet(direction: direction);
        bullet.position = player.position;
        add(bullet);
      }
    });
  }

  void startSpawningEnemies() {
    for (int i = 0; i < wave * 5; i++) {
      da.Timer(
        Duration(seconds: (Random().nextDouble() * 5).toInt()),
        () {
          if (state != GameState.playing) return;

          final enemy = WeakEnemy();
          enemy.position = Vector2(
            Random().nextDouble() * size.x,
            Random().nextDouble() * size.y,
          );
          add(enemy);
          enemies.add(enemy);
        },
      );
    }
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
    wave++;
    startSpawningEnemies();
  }

  void buyUpgrade(String type) {
    // Logique d'achat
    resumeFromShop();
  }

  void onPlayerDeath() {
    showDeathMenu();
    enemies.clear();
    children.whereType<Enemy>().forEach(remove);
    children.whereType<Bullet>().forEach(remove);
    player.removeFromParent();
    player.healthBar.removeFromParent();
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
