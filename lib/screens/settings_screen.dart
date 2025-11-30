import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_botato/core/game.dart';
import 'package:space_botato/core/providers.dart';
import 'package:space_botato/main.dart';

class SettingsScreen extends ConsumerWidget {
  static const id = 'SettingsScreenID';
  final SpaceBotatoGame game;

  const SettingsScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundEnabled = ref.watch(soundEnabledProvider);
    final vibrationEnabled = ref.watch(vibrationEnabledProvider);
    final volume = ref.watch(volumeProvider);

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            game.overlays.remove(id);
            // If we came from main menu, we might want to go back there.
            // But overlays are additive. If we are in menu state, we just remove this overlay.
            if (ref.read(gameStateProvider) == GameState.menu) {
              // Do nothing special, just close
            } else {
              // If paused, maybe show pause menu again?
              // For now, let's assume this is opened from MainMenu or PauseMenu
              // and we just close it to reveal what's behind.
            }
          },
        ),
      ),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Sound Effects',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                value: soundEnabled,
                onChanged: (value) {
                  ref.read(soundEnabledProvider.notifier).state = value;
                },
                secondary: Icon(
                  soundEnabled ? Icons.volume_up : Icons.volume_off,
                  color: Colors.white,
                ),
              ),
              const Divider(color: Colors.grey),
              ListTile(
                title: const Text('Volume',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                subtitle: Slider(
                  value: volume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: (volume * 100).toInt().toString(),
                  onChanged: (value) {
                    ref.read(volumeProvider.notifier).state = value;
                  },
                ),
                leading: const Icon(Icons.volume_down, color: Colors.white),
              ),
              SwitchListTile(
                title: const Text('Vibration',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                value: vibrationEnabled,
                onChanged: (value) {
                  ref.read(vibrationEnabledProvider.notifier).state = value;
                },
                secondary: Icon(
                  vibrationEnabled ? Icons.vibration : Icons.smartphone,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  game.overlays.remove(id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('Close', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
