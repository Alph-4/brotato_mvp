import 'package:flame/game.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_botato/core/constants.dart';
import 'package:space_botato/core/game.dart';
import 'package:space_botato/core/providers.dart';
import 'package:space_botato/core/shared_preferences.dart';
import 'package:space_botato/screens/main_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences
      .getInstance(); // charger avant runApp :contentReference[oaicite:9]{index=9}

  runApp(
    ProviderScope(overrides: [
      sharedPreferencesProvider.overrideWith((ref) async => prefs),
    ], child: MyApp()),
  );
}

enum GameState {
  menu,
  playing,
  paused,
  dead,
  shopping,
  win,
  settings,
  classSelection,
}

final gameInstance = SpaceBotatoGame();
final GlobalKey<RiverpodAwareGameWidgetState> gameWidgetKey =
    GlobalKey<RiverpodAwareGameWidgetState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Space Botato',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: RiverpodAwareGameWidget(
          key: gameWidgetKey,
          game: gameInstance,
          initialActiveOverlays: const [MainMenu.id],
          overlayBuilderMap: gameOverlays,
        ),
      ),
    ));
  }
}
