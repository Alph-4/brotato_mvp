import 'package:flutter/material.dart';
import 'package:space_botato/core/constants.dart';
import 'package:space_botato/core/game.dart';

class WinScreen extends StatelessWidget {
  static const id = 'WinScreenID';
  final SpaceBotatoGame game;
  const WinScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/space_background.png'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Victory Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.2),
                  border: Border.all(color: Colors.green, width: 3),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  size: 100,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 40),
              
              // Victory Text
              const Text(
                'VICTORY!',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  shadows: [
                    Shadow(
                      color: Colors.green,
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Message
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: const Text(
                  'You have successfully defended\nour space from alien invasion!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // Return to Menu Button
              GestureDetector(
                onTap: () => game.returnToMainMenu(),
                child: Container(
                  width: 250,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Return to Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
