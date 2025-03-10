import 'package:flutter/material.dart';
import 'package:space_botato/core/constants.dart';
import 'package:space_botato/core/game.dart';

class ShopMenu extends StatelessWidget {
  static const id = 'ShopID';
  final SpaceBotatoGame game;
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
              style: kTextStyle.copyWith(fontSize: 48),
            ),
            const SizedBox(height: 40),
            _buildUpgradeCard(
              title: 'Damage Up',
              icon: Icons.local_fire_department,
              color: Colors.red,
              onTap: () => game.buyUpgrade('damage'),
            ),
            const SizedBox(height: 20),
            _buildUpgradeCard(
              title: 'Speed Up',
              icon: Icons.speed,
              color: Colors.blue,
              onTap: () => game.buyUpgrade('speed'),
            ),
            const SizedBox(height: 20),
            _buildUpgradeCard(
              title: 'Health Up',
              icon: Icons.favorite,
              color: Colors.green,
              onTap: () => game.buyUpgrade('health'),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () => game.resumeFromShop(),
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.purple,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: color.withOpacity(0.2),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
