import 'package:brotato_mvp/main.dart';
import 'package:flutter/material.dart';

class ShopMenu extends StatelessWidget {
  final BrotatoGame game;
  const ShopMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SHOP',
              style: textStyle,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () => game.buyUpgrade('damage'),
              child: const Text('Increase Damage'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () => game.buyUpgrade('speed'),
              child: const Text('Increase Speed'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () => game.buyUpgrade('health'),
              child: const Text('Increase Health'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () => game.resumeFromShop(),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
