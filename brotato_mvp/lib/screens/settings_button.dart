import 'package:flutter/material.dart';
import 'package:space_botato/core/game.dart';

class SettingsButton extends StatelessWidget {
  static const id = 'SettingsButtonID';
  final SpaceBotatoGame game;

  const SettingsButton({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: IconButton(
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
            size: 32,
          ),
          onPressed: () => game.pauseGame(),
          style: IconButton.styleFrom(
            backgroundColor: Colors.black38,
            padding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
} 