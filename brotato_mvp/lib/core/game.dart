import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:space_botato/components/bullet/bullet.dart';
import 'package:space_botato/components/enemy/enemy.dart';
import 'package:space_botato/components/enemy/flying_enemy.dart';
import 'dart:async' as da;
import 'package:flame/input.dart';
import 'package:space_botato/components/enemy/mushroom_enemy.dart';
import 'package:space_botato/core/constants.dart';

import 'package:space_botato/main.dart';

import 'package:space_botato/components/player/player.dart';
import 'package:space_botato/screens/death_menu.dart';
import 'package:space_botato/screens/main_menu.dart';
import 'package:space_botato/screens/pause_menu.dart';
import 'package:space_botato/screens/shop_menu.dart';
import 'package:space_botato/screens/settings_button.dart';
import 'package:space_botato/screens/win_screen.dart';

class SpaceBotatoGame extends FlameGame with HasCollisionDetection, KeyboardEvents {

  GameState state = GameState.menu;
  late Player player;
  late JoystickComponent joystick;
  List<Enemy> enemies = [];
  int wave = 1;
  bool waveCompleted = false;
  

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await Flame.device.setLandscape();
    await Flame.device.fullScreen();

    // Initialisation du joystick
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: Paint()..color = Colors.grey),
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
    enemies.clear();
    children.whereType<Enemy>().forEach(remove);
    children.whereType<Bullet>().forEach(remove);

    wave = 1;

    player = Player();
    player.position = size / 2;
    add(player);

    overlays.remove(MainMenu.id);

      state = GameState.playing;
    overlays.add(SettingsButton.id);

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
        //FlameAudio.play('simple_shoot.mp3');
        add(bullet);
      }
    });
  }

  /// Starts spawning [wave * 5] enemies at random intervals between 0 and 5
  /// seconds. The spawned enemies are added to the [enemies] list.
  ///
  /// This is intended to be called when the game starts, or when the player
  /// reaches a new wave.
  void startSpawningEnemies() {
    var maxEnemies = wave * Random().nextInt(3) + 2;
    for (int i = 0; i < maxEnemies; i++) {
      da.Timer(
        Duration(seconds: (Random().nextDouble() * kMaxSpawnDelay).toInt()),
        () {
          if (state != GameState.playing) return;

          final enemy = FlyingEnemy();
        
          enemy.position = Vector2(
            Random().nextDouble() * size.x,
            Random().nextDouble() * size.y,
          );

          if(wave == 2 || wave == 3){
            final enemy = MushroomEnemy();
            enemy.position = Vector2(
              Random().nextDouble() * size.x,
              Random().nextDouble() * size.y,
            );
            add(enemy);
            enemies.add(enemy);
          }
          add(enemy);
          enemies.add(enemy);
        },
      );
    }
    waveCompleted = true;
  }

  void pauseGame() {
    state = GameState.paused;
    pauseEngine();
    overlays.remove(SettingsButton.id);
    overlays.add(PauseMenu.id);
  }

  void resetGame() {
    pauseEngine();
    enemies.clear();
    children.whereType<Enemy>().forEach(remove);
    children.whereType<Bullet>().forEach(remove);
    // Supprimer le joueur actuel
      player.removeFromParent();
    // Retirer tous les overlays de jeu
    overlays.clear();
    // Réinitialiser l'état
    state = GameState.menu;
    // Afficher le menu principal
    showMainMenu();
    // Redémarrer le moteur de jeu
    resumeEngine();
  }

  void resumeGame() {
    state = GameState.playing;
    overlays.remove(PauseMenu.id);
    overlays.add(SettingsButton.id);
    resumeEngine();
  }

  void showDeathMenu() {
    state = GameState.dead;
    overlays.add(DeathMenu.id);
  }

  void returnToMainMenu() {
    state = GameState.menu;
    overlays.clear();
    overlays.add(MainMenu.id);
    resetGame();
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
  }


  @override
  void update(double dt) {
    if (state != GameState.playing) return;
    print("enemies.length: ${enemies.length}");
    print("current wave: $wave");

    if(waveCompleted && enemies.isEmpty && wave < kMaxWaves){
      print("wave completed, showing shop");
      state = GameState.shopping;
      pauseEngine();
      overlays.add(ShopMenu.id);
    }
    if(waveCompleted && enemies.isEmpty && wave == kMaxWaves){
      print("Win");
      state = GameState.win;
      overlays.add(WinScreen.id);
    }
    super.update(dt);
  }

  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      player.position.x -= 450 * 0.016; // dt approximatif
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      player.position.x += 450 * 0.016; // dt approximatif
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      player.position.y -= 450 * 0.016; // dt approximatif
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      player.position.y += 450 * 0.016; // dt approximatif
    }
    if(keysPressed.contains(LogicalKeyboardKey.escape)) {
      pauseGame();
    }
    
    return KeyEventResult.handled;
  

  }

}


