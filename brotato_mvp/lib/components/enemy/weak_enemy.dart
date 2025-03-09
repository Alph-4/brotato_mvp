import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:space_botato/components/enemy/enemy.dart';
import 'package:space_botato/core/constants.dart';

class WeakEnemy extends Enemy {
  WeakEnemy() : super() {
    damage = kEnemyBaseDamage;
  }

  @override
  Future<void> onLoad() async {
    final defaultPaint = Paint()
      ..color = Colors.cyan
      ..style = PaintingStyle.stroke;

    hitbox = CircleHitbox()
      ..paint = defaultPaint
      ..renderShape = true
      ..collisionType = CollisionType.active;

    sprite = await game.loadSprite('flight_enemy.png');
    sprite?.srcSize = Vector2(kEnemySize, kEnemySize);

    anchor = Anchor.center;

    add(hitbox);
  }
} 