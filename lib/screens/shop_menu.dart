import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_botato/core/constants.dart';
import 'package:space_botato/core/game.dart';
import 'package:space_botato/core/providers.dart';
import 'package:space_botato/core/shop_logic.dart';
import 'package:space_botato/models/upgrade.dart';

class ShopMenu extends ConsumerWidget {
  static const id = 'ShopID';
  final SpaceBotatoGame game;
  const ShopMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upgrades = ref.watch(shopOptionsProvider);
    final gold = ref.watch(goldProvider);

    return Scaffold(
        backgroundColor: Colors.black87,
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'SHOP',
                  style: kTextStyle.copyWith(fontSize: 48, color: Colors.amber),
                ),
                const SizedBox(height: 10),
                Text(
                  'Gold: $gold',
                  style:
                      kTextStyle.copyWith(fontSize: 24, color: Colors.yellow),
                ),
                const SizedBox(height: 40),
                if (upgrades.isEmpty)
                  const Text(
                    "Sold Out!",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  )
                else
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: upgrades.map((upgrade) {
                      final canAfford = gold >= upgrade.cost;
                      return _buildUpgradeCard(
                        upgrade: upgrade,
                        canAfford: canAfford,
                        onTap: () {
                          if (canAfford) {
                            game.buyUpgrade(upgrade);
                          }
                        },
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (gold >= 5) {
                          ref.read(goldProvider.notifier).state -= 5;
                          generateShopOptions(ref);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                      ),
                      child: const Text('Reroll (5 Gold)',
                          style: TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () => game.resumeFromShop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                      ),
                      child: const Text('Next Wave',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.settings, color: Colors.white, size: 32),
                onPressed: () => game.pauseGame(),
              ),
            )
          ],
        ));
  }

  Widget _buildUpgradeCard({
    required Upgrade upgrade,
    required bool canAfford,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: canAfford ? onTap : null,
      child: Container(
          width: 200,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: canAfford
                ? upgrade.color.withOpacity(0.2)
                : Colors.grey.withOpacity(0.2),
            border: Border.all(
                color: canAfford ? upgrade.color : Colors.grey, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  upgrade.icon,
                  size: 50,
                  color: canAfford ? upgrade.color : Colors.grey,
                ),
                Text(
                  upgrade.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: canAfford ? upgrade.color : Colors.grey,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  upgrade.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  '${upgrade.cost} G',
                  style: TextStyle(
                    color: canAfford ? Colors.yellow : Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
