import 'dart:math';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_botato/data/upgrades.dart';
import 'package:space_botato/models/upgrade.dart';

final shopOptionsProvider = StateProvider<List<Upgrade>>((ref) => []);

void generateShopOptions(WidgetRef ref) {
  final random = Random();
  final List<Upgrade> options = [];
  final List<Upgrade> available = List.from(allUpgrades);

  for (int i = 0; i < 3; i++) {
    if (available.isEmpty) break;
    final index = random.nextInt(available.length);
    options.add(available[index]);
    // Optional: remove if you don't want duplicates in the same shop roll
    // available.removeAt(index);
  }
  ref.read(shopOptionsProvider.notifier).state = options;
}

// Overload for ComponentRef (used in Game class)
void generateShopOptionsComponentRef(ComponentRef ref) {
  final random = Random();
  final List<Upgrade> options = [];
  final List<Upgrade> available = List.from(allUpgrades);

  for (int i = 0; i < 3; i++) {
    if (available.isEmpty) break;
    final index = random.nextInt(available.length);
    options.add(available[index]);
  }
  ref.read(shopOptionsProvider.notifier).state = options;
}
