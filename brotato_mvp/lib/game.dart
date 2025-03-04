
import 'package:flame/components.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:space_botato/bullet.dart';
import 'package:space_botato/enemy.dart';
import 'dart:async' as da;

import 'package:space_botato/main.dart';
import 'package:space_botato/menu/death_menu.dart';
import 'package:space_botato/menu/main_menu.dart';
import 'package:space_botato/menu/pause_menu.dart';
import 'package:space_botato/menu/shop_menu.dart';
import 'package:space_botato/player.dart';
class SpaceBotatoGame extends FlameGame with HasCollisionDetection {

  GameState state = GameState.menu;
  late Player player;
  late JoystickComponent joystick;
  List<Enemy> enemies = [];
  int wave = 1;

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
    add(player.lifeAndExpBar);

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
    overlays.add(PauseMenu.id);
  }

  void resumeGame() {
    state = GameState.playing;
    overlays.remove(PauseMenu.id);
    resumeEngine();
  }

  void showDeathMenu() {
    state = GameState.dead;
    overlays.add(DeathMenu.id);
  }

  void showShopMenu() {
    state = GameState.shopping;
    pauseEngine();
    overlays.add(ShopMenu.id);
  }

  void resumeFromShop() {
    state = GameState.playing;
    overlays.remove(ShopMenu.id);
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
    player.lifeAndExpBar.removeFromParent();
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
