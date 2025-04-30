import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_botato/core/constants.dart';
import 'package:space_botato/core/game.dart';
import 'package:space_botato/core/providers.dart';
import 'package:space_botato/core/shared_preferences.dart';
import 'package:space_botato/main.dart';

class SpaceBotatoGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents {
  SpaceBotatoGame({required this.ref});
  final Ref ref;

  // Corriger les méthodes non définies
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Load persisted state
    final prefs = await ref.read(sharedPreferencesProvider.future);

    ref.read(waveProvider.notifier).state = prefs.getInt('wave') ?? 1;
    ref.read(goldProvider.notifier).state = prefs.getInt('gold') ?? 0;
  }

  void saveState() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);

    await prefs.setInt('wave', ref.read(waveProvider));
    await prefs.setInt('gold', ref.read(goldProvider));
  }

  void resumeGame() {
    ref.read(gameStateProvider.notifier).state = GameState.playing;
  }

  void pauseGame() {
    ref.read(gameStateProvider.notifier).state = GameState.paused;
  }

  void showShopMenu() {
    ref.read(gameStateProvider.notifier).state = GameState.shopping;
  }

  void resumeFromShop() {
    ref.read(gameStateProvider.notifier).state = GameState.playing;
  }
}
