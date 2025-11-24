import 'package:flutter/material.dart';
import 'package:space_botato/core/game.dart';

class WaveCountdownOverlay extends StatelessWidget {
  static const String id = 'WaveCountdownOverlay';
  final SpaceBotatoGame game;

  const WaveCountdownOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          'Get Ready!',
          style: TextStyle(
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
