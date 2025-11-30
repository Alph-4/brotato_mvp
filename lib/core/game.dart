import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
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
  void onPlayerDeath() {
    showDeathMenu();
    enemies.clear();
    children.whereType<Enemy>().forEach(remove);
    children.whereType<Bullet>().forEach(remove);
    player.removeFromParent();
  }

  late Player player;
  late JoystickComponent joystick;
  TimerComponent? waveTimer;
  TimerComponent? enemySpawner;
  late TextComponent waveText;
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

    waveText = TextComponent(
      text: ref.watch(waveProvider).toString(),
      position: Vector2(size.x / 2, 10),
      anchor: Anchor.topCenter,
      priority: 100,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 64,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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
        ));
    add(waveTimerText);

    showMainMenu();
  }

  void startWaveCountdown() {
    currentPhase = Phase.countdown;
    overlays.add(WaveCountdownOverlay.id);

    Future.delayed(const Duration(seconds: 2), () {
      overlays.clear(); // Force la suppression de tous les overlays
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

    // Stop enemy spawner
    enemySpawner?.removeFromParent();

    enemies.clear();
    children.whereType<Enemy>().forEach(remove);

    // Nettoie le timer HUD
    waveTimerText.text = '';
    waveTimer?.removeFromParent();

    // Generate shop options
    generateShopOptionsComponentRef(ref);

    ref.read(gameStateProvider.notifier).state = GameState.shopping;
    overlays.add(ShopMenu.id);
    waveCompleted = true;
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
    // Remove previous spawner if exists
    enemySpawner?.removeFromParent();
    enemySpawner = TimerComponent(
      period: (kMaxSpawnDelay.toDouble() *
          ref.read(waveProvider.notifier).state), // Or dynamic value
      repeat: true,
      onTick: spawnEnemy,
    );
    add(enemySpawner!);
  }

  void spawnEnemy() {
    if (currentPhase != Phase.combat) return;
    if (ref.read(gameStateProvider) != GameState.playing) return;

    final enemy = FlyingEnemy();
    Vector2 enemyPosition;
    // Spawn sur un bord aléatoire
    int side = Random().nextInt(4); // 0: haut, 1: bas, 2: gauche, 3: droite
    switch (side) {
      case 0:
        enemyPosition = Vector2(Random().nextDouble() * mapWidth, 0);
        break;
      case 1:
        enemyPosition = Vector2(Random().nextDouble() * mapWidth, mapHeight);
        break;
      case 2:
        enemyPosition = Vector2(0, Random().nextDouble() * mapHeight);
        break;
      case 3:
        enemyPosition = Vector2(mapWidth, Random().nextDouble() * mapHeight);
        break;
      default:
        enemyPosition = Vector2(mapWidth / 2, 0);
    }
    enemy.position = enemyPosition;
    add(enemy);
    enemies.add(enemy);

    int wave = ref.read(waveProvider);
    if (wave == 2 || wave == 3) {
      final mush = MushroomEnemy();
      int side2 = Random().nextInt(4);
      Vector2 pos2;
      switch (side2) {
        case 0:
          pos2 = Vector2(Random().nextDouble() * mapWidth, 0);
          break;
        case 1:
          pos2 = Vector2(Random().nextDouble() * mapWidth, mapHeight);
          break;
        case 2:
          pos2 = Vector2(0, Random().nextDouble() * mapHeight);
          break;
        case 3:
          pos2 = Vector2(mapWidth, Random().nextDouble() * mapHeight);
          break;
        default:
          pos2 = Vector2(mapWidth / 2, 0);
      }
      mush.position = pos2;
      add(mush);
      enemies.add(mush);
    }
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
    }
    // Unifie l'affichage du timer HUD
    waveTimerText.text = timerValue.toStringAsFixed(0);

    // Met à jour le HUD du joueur si présent
    player.hud.updateGold(ref.read(goldProvider));
    player.hud.updateExp(player.exp);
    player.hud.updateHealth(player.stats.currentHealth);
    player.hud.updateTimer(timerValue);
    player.hud.updateLevel(player.stats.level);
    player.hud.updateWave(ref.read(waveProvider));

    // Nouvelle condition de fin de manche
    bool timerFinished = !(waveTimer?.timer.isRunning() ?? true);
    bool noEnemiesLeft = enemies.isEmpty;
    if (currentPhase == Phase.combat && timerFinished && noEnemiesLeft) {
      onWaveCompleted();
    }

    if (waveCompleted &&
        enemies.isEmpty &&
        ref.read(waveProvider.notifier).state == kMaxWaves) {
      print("Win");
      ref.read(gameStateProvider.notifier).state = GameState.win;
      overlays.add(WinScreen.id);
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
