import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:space_botato/components/bullet/bullet.dart';
import 'package:space_botato/components/enemy/enemy.dart';
import 'package:space_botato/components/enemy/flying_enemy.dart';
import 'dart:async' as da;
import 'package:space_botato/components/enemy/mushroom_enemy.dart';
import 'package:space_botato/core/constants.dart';
import 'package:space_botato/core/providers.dart';
import 'package:space_botato/main.dart';
import 'package:space_botato/components/player/player.dart';
import 'package:space_botato/models/player_class.dart';
import 'package:space_botato/overlays/wave_countdown_overlay.dart';
import 'package:space_botato/core/shop_logic.dart';
import 'package:space_botato/models/upgrade.dart';
import 'package:space_botato/screens/class_selection_screen.dart';
import 'package:space_botato/screens/death_menu.dart';
import 'package:space_botato/screens/main_menu.dart';
import 'package:space_botato/screens/pause_menu.dart';
import 'package:space_botato/screens/settings_screen.dart';
import 'package:space_botato/screens/shop_menu.dart';
import 'package:space_botato/screens/settings_button.dart';
import 'package:space_botato/screens/win_screen.dart';

enum Phase { shop, countdown, combat }

class SpaceBotatoGame extends FlameGame
    with RiverpodGameMixin, HasCollisionDetection, KeyboardEvents {
  late Player player;
  late JoystickComponent joystick;
  TimerComponent? waveTimer;
  late TextComponent waveTimerText;

  List<Enemy> enemies = [];
  bool waveCompleted = false;
  Phase currentPhase = Phase.shop;
  double waveDuration = 30.0;

  // Taille de la map
  final double mapWidth = 2000;
  final double mapHeight = 2000;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final prefs = await ref.read(sharedPreferencesProvider.future);
    ref.read(waveProvider.notifier).state = prefs.getInt('wave') ?? 1;
    ref.read(goldProvider.notifier).state = prefs.getInt('gold') ?? 0;

    // Ajoute le background (remplace background.png par ton image)
    add(SpriteComponent(
      sprite: await loadSprite('background.png'),
      size: Vector2(mapWidth, mapHeight),
      position: Vector2.zero(),
      priority: -1,
    ));

    joystick = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: Paint()..color = Colors.grey),
      background: CircleComponent(
        radius: 60,
        paint: Paint()..color = Colors.grey.withAlpha(50),
      ),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    add(joystick);

    waveTimerText = TextComponent(
      text: '',
      position: Vector2(size.x / 2, 20),
      anchor: Anchor.topCenter,
      priority: 100,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(waveTimerText);

    showMainMenu();
  }

  void startWaveCountdown() {
    currentPhase = Phase.countdown;
    overlays.add(WaveCountdownOverlay.id);

    Future.delayed(const Duration(seconds: 2), () {
      overlays.remove(WaveCountdownOverlay.id);
      startCombatPhase();
    });
  }

  void startCombatPhase() {
    currentPhase = Phase.combat;
    ref.read(gameStateProvider.notifier).state = GameState.playing;

    // Timer décompté : manche N = N×30s
    int wave = ref.read(waveProvider.notifier).state;
    waveDuration = wave * 30.0;

    waveTimer = TimerComponent(
      period: waveDuration,
      repeat: false,
      onTick: onWaveCompleted,
    );
    add(waveTimer!);

    waveTimerText.text = waveDuration.toStringAsFixed(0);

    startSpawningEnemies();
  }

  void onWaveCompleted() {
    if (currentPhase != Phase.combat) return;
    currentPhase = Phase.shop;

    enemies.clear();
    children.whereType<Enemy>().forEach(remove);

    // Nettoie le timer HUD
    waveTimerText.text = '';
    waveTimer?.removeFromParent();

    // Generate shop options
    generateShopOptionsComponentRef(ref);

    ref.read(gameStateProvider.notifier).state = GameState.shopping;
    overlays.add(ShopMenu.id);
  }

  void showMainMenu() {
    ref.read(gameStateProvider.notifier).state = GameState.menu;
    overlays.add(MainMenu.id);
    // Nettoie la boucle de jeu et le HUD
    waveTimerText.text = '';
    waveTimer?.removeFromParent();
  }

  void startNewGame(PlayerClassDetails selectedClass) {
    ref.read(waveProvider.notifier).state = 1;
    ref.read(gameStateProvider.notifier).state = GameState.playing;
    ref.read(playerClassProvider.notifier).state = selectedClass;
    overlays.clear();
    enemies.clear();

    children.whereType<Player>().forEach(remove);
    children.whereType<Enemy>().forEach(remove);
    children.whereType<Bullet>().forEach(remove);

    overlays.add(SettingsButton.id);

    // Place le joueur au centre de la map
    player =
        Player(selectedClass: ref.read(playerClassProvider.notifier).state);
    player.position = Vector2(mapWidth / 2, mapHeight / 2);
    add(player);

    // Caméra qui suit le joueur
    camera.follow(player);

    startWaveCountdown();
  }

  void classSelection() {
    ref.read(gameStateProvider.notifier).state = GameState.classSelection;
    overlays.add(ClassSelectionScreen.id);
  }

  void startSpawningEnemies() {
    while (true) {
      da.Timer(
          Duration(seconds: (Random().nextDouble() * kMaxSpawnDelay).toInt()),
          () {
        if (ref.read(gameStateProvider.notifier).state != GameState.playing)
          return;

        final enemy = FlyingEnemy();

        Vector2 enemyPosition;
        do {
          enemyPosition = Vector2(
            Random().nextDouble() * size.x,
            Random().nextDouble() * size.y,
          );
        } while ((enemyPosition - player.position).length < kEnemySize);

        enemy.position = enemyPosition;

        if (ref.read(waveProvider.notifier).state == 2 ||
            ref.read(waveProvider.notifier).state == 3) {
          final mushroomEnemy = MushroomEnemy();
          do {
            enemyPosition = Vector2(
              Random().nextDouble() * size.x,
              Random().nextDouble() * size.y,
            );
          } while ((enemyPosition - player.position).length < kEnemySize);

          mushroomEnemy.position = enemyPosition;
        }
        add(enemy);
        enemies.add(enemy);
      });
    }
    waveCompleted = true;
  }

  void pauseGame() {
    pauseEngine();
    ref.read(gameStateProvider.notifier).state = GameState.paused;
    overlays.remove(SettingsButton.id);
    overlays.add(PauseMenu.id);
  }

  void resetGame() {
    enemies.clear();
    player.removeFromParent();
    children.whereType<Enemy>().forEach(remove);
    children.whereType<Bullet>().forEach(remove);
    player.removeFromParent();
    overlays.clear();
    ref.read(gameStateProvider.notifier).state = GameState.menu;
    showMainMenu();
    resumeEngine();
  }

  void resumeGame() {
    ref.read(gameStateProvider.notifier).state = GameState.playing;
    overlays.remove(PauseMenu.id);
    overlays.add(SettingsButton.id);
    resumeEngine();
  }

  void showDeathMenu() {
    ref.read(gameStateProvider.notifier).state = GameState.dead;
    overlays.add(DeathMenu.id);
  }

  void returnToMainMenu() {
    ref.read(gameStateProvider.notifier).state = GameState.menu;
    overlays.clear();
    overlays.add(MainMenu.id);
    resetGame();
  }

  void showShopMenu() {
    ref.read(gameStateProvider.notifier).state = GameState.shopping;
    pauseEngine();
    overlays.add(ShopMenu.id);
    // Nettoie le timer HUD
    waveTimerText.text = '';
    waveTimer?.removeFromParent();
  }

  void resumeFromShop() {
    ref.read(gameStateProvider.notifier).state = GameState.playing;
    overlays.remove(ShopMenu.id);
    resumeEngine();
    ref.read(waveProvider.notifier).state++;
    startWaveCountdown();
  }

  void buyUpgrade(Upgrade upgrade) {
    final currentGold = ref.read(goldProvider);
    if (currentGold >= upgrade.cost) {
      ref.read(goldProvider.notifier).state -= upgrade.cost;

      // Apply stats
      upgrade.effects.forEach((stat, value) {
        switch (stat) {
          case StatType.maxHealth:
            player.stats.maxHealth += value;
            player.stats.currentHealth += value;
            break;
          case StatType.damage:
            player.stats.damage += value;
            break;
          case StatType.attackSpeed:
            player.stats.attackSpeed += value;
            break;
          case StatType.moveSpeed:
            player.stats.moveSpeed += value;
            break;
          case StatType.defense:
            player.stats.defense += value;
            break;
          case StatType.critChance:
            player.stats.critChance += value;
            break;
        }
      });

      // Remove the bought item from the shop (optional, but good UX)
      final currentOptions = ref.read(shopOptionsProvider);
      ref.read(shopOptionsProvider.notifier).state =
          currentOptions.where((u) => u.id != upgrade.id).toList();
    }
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
    // La boucle de jeu ne s'exécute que pendant la phase de combat
    if (ref.read(gameStateProvider.notifier).state != GameState.playing ||
        currentPhase != Phase.combat) return;

    // Sécurise l'accès au timer
    double timerValue = waveDuration;
    if (waveTimer?.timer.isRunning() ?? false) {
      timerValue =
          (waveDuration - waveTimer!.timer.current).clamp(0, waveDuration);
      waveTimerText.text = timerValue.toStringAsFixed(0);
    }

    // Met à jour le HUD du joueur si présent
    player.hud.updateGold(ref.read(goldProvider));
    player.hud.updateExp(player.exp);
    player.hud.updateHealth(player.stats.currentHealth);
    player.hud.updateTimer(timerValue);
    player.hud.updateLevel(player.stats.level);
    player.hud.updateWave(ref.read(waveProvider));

    if (currentPhase == Phase.combat &&
        enemies.isEmpty &&
        !(waveTimer?.timer.isRunning() ?? true)) {
      onWaveCompleted();
    }

    if (waveCompleted &&
        enemies.isEmpty &&
        ref.read(waveProvider.notifier).state == kMaxWaves) {
      print("Win");
      ref.read(gameStateProvider.notifier).state = GameState.win;
      overlays.add(WinScreen.id);
    }

    // Met à jour le timer HUD pendant la phase de combat
    if (currentPhase == Phase.combat && waveTimer?.timer.isRunning() == true) {
      waveTimerText.text = waveTimer!.timer.current.toStringAsFixed(0);
    }
    super.update(dt);
  }

  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (ref.read(gameStateProvider.notifier).state != GameState.playing) {
      return KeyEventResult.ignored;
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      player.position.x -= 400 * 0.016;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      player.position.x += 400 * 0.016;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      player.position.y -= 400 * 0.016;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      player.position.y += 400 * 0.016;
    }
    if (keysPressed.contains(LogicalKeyboardKey.escape)) {
      pauseGame();
    }

    return KeyEventResult.handled;
  }
}
