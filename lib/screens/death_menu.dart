import 'package:flutter/material.dart';
import 'package:space_botato/core/constants.dart';
import 'package:space_botato/core/game.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_botato/core/providers.dart';

class DeathMenu extends ConsumerWidget {
  static const id = 'DeathID';
  final SpaceBotatoGame game;
  const DeathMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wave = ref.read(waveProvider);
    final gold = ref.read(goldProvider);

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GAME OVER',
              style: kTextStyle.copyWith(fontSize: 48, color: Colors.red),
            ),
            const SizedBox(height: 20),
            Text(
              'Wave Reached: $wave',
              style: kTextStyle.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              'Gold Collected: $gold',
              style: kTextStyle.copyWith(fontSize: 24, color: Colors.amber),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: kButtonStyle,
              onPressed: () => game.startNewGame(game.player.selectedClass),
              child: const Text('Try Again'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: kButtonStyle,
              onPressed: () => game.showMainMenu(),
              child: const Text('Main Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
