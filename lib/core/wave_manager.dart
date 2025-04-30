import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:space_botato/components/enemy/enemy.dart';

class WaveManager {
  final FlameGame game;
  int currentWave = 0;
  late Timer waveTimer;

  WaveManager(this.game) {
    waveTimer = Timer(30, onTick: finishWave); // 30s par vague
  }

/*
  void startWave() {
    currentWave++;
    final spawnInterval = 1.0 - (currentWave * 0.05);
    game.add(SpawnComponent(
      factory: (i) => Enemy(),
      period: spawnInterval.clamp(0.2, 1.0),
      area: Rectangle.fromLTWH(0, 0, game.size.x, -Enemy.size),
    ));
    waveTimer.start();
  }*/

  void finishWave() {
    game.overlays.add('ShopMenu');
  }
}
