import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_botato/core/game.dart';
import 'package:space_botato/main.dart';
import 'package:space_botato/models/player_class.dart';

final playerClassProvider = StateProvider<PlayerClassDetails>((ref) {
  // On peut aussi le charger depuis SharedPreferences si besoin
  return PlayerClassDetails.classes[PlayerClass.warrior]!; // ou celui choisi
});
final waveProvider = StateProvider<int>((_) => 1);
final gameStateProvider = StateProvider<GameState>((_) => GameState.menu);
final goldProvider = StateProvider<int>((ref) => 0);

final soundEnabledProvider = StateProvider<bool>((ref) => true);
final vibrationEnabledProvider = StateProvider<bool>((ref) => true);
final volumeProvider = StateProvider<double>((ref) => 1.0);

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});
