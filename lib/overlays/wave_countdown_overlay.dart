import 'package:flutter/material.dart';

class WaveCountdownOverlay extends StatelessWidget {
  static const String id = 'WaveCountdownOverlay';

  final int countdown;

  const WaveCountdownOverlay({Key? key, required this.countdown})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Next Wave in $countdown...',
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
