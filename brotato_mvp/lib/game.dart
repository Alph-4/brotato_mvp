import 'dart:math';
import 'dart:async' as da;
import 'dart:ui';
import 'package:brotato_mvp/bullet.dart';
import 'package:brotato_mvp/enemy.dart';
import 'package:brotato_mvp/main.dart';
import 'package:brotato_mvp/player.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

class GamePlay extends Component with HasGameRef<BrotatoGame> {
  late JoystickComponent joystick;
  late Player player;

  int wave = 1;
  List<Enemy> enemies = [];

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await Flame.device.setLandscape();
    await Flame.device.fullScreen();
    player = Player();
    add(player);
    await setupJoystick();
    startSpawningEnemies();
    startAutoShoot();
    add(player..position = size / 2);
    add(player.healthBar);
  }

  Future<void> setupJoystick() async {
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: Paint()..color = Colors.red),
      background: CircleComponent(
          radius: 60, paint: Paint()..color = Colors.grey.withAlpha(50)),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    add(joystick);
  }

  void startAutoShoot() {
    da.Timer.periodic(Duration(seconds: 1), (timer) {
      final enemies = children.whereType<Enemy>().toList();
      if (enemies.isEmpty) return;

      Vector2 playerPos = player.position;
      Enemy? closestEnemy;
      double closestDistance = double.infinity;

      for (final enemy in enemies) {
        final distance = (enemy.position - playerPos).length;
        if (distance < closestDistance) {
          closestDistance = distance;
          closestEnemy = enemy;
        }
      }

      if (closestEnemy != null) {
        final direction = (closestEnemy.position - playerPos).normalized();
        final bullet = Bullet(direction: direction);
        bullet.position = player.position;
        add(bullet);
      }
    });
  }

  void startSpawningEnemies() {
    // if (state != GameState.playing) return;

    for (int i = 0; i < wave * 5; i++) {
      da.Timer(
        Duration(seconds: (Random().nextDouble() * 5).toInt()),
        () {
          final enemy = WeakEnemy();
          enemy.position = Vector2(
            Random().nextDouble() * size.x,
            Random().nextDouble() * size.y,
          );
          add(enemy);
          enemies.add(enemy);
        },
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (enemies.isEmpty) {
      //wave++;
      // startSpawningEnemies();
    }
  }
}
