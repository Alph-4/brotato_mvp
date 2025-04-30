import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_botato/core/game.dart';
import 'package:space_botato/core/shared_preferences.dart';
import 'package:space_botato/main.dart';


final waveProvider = StateProvider<int>((_) => 1);
final gameStateProvider = StateProvider<GameState>((_) => GameState.menu);
final goldProvider = StateProvider<int>((ref) => 0);
final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

/// Dans un fichier de providers, par exemple lib/providers/game_providers.dart
void registerPersistenceListeners(Ref ref) {
  // À chaque changement de vague, on enregistre dans SharedPreferences
  ref.listen<int>(waveProvider, (previous, next) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setInt('wave', next);
  });
  // Même logique pour l'or du joueur
  ref.listen<int>(goldProvider, (previous, next) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setInt('gold', next);
  });
}
