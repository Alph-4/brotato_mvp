import 'dart:math';
import 'dart:async' as da;
import 'package:brotato_mvp/bullet.dart';
import 'package:brotato_mvp/main.dart';
import 'package:brotato_mvp/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

abstract class Enemy extends SpriteComponent
    with HasGameReference<BrotatoGame>, CollisionCallbacks {
  Enemy() : super(size: Vector2(150, 150)) {
    add(RectangleHitbox()..size = Vector2(50, 50));
  }
  late ShapeHitbox hitbox;
  late SpriteAnimationComponent flight;
  final _defaultColor = Colors.cyan;
  final _collisionStartColor = Colors.amber;
  final _collisionBulletHitColor = Colors.red;
  final _collisionPlayerHitColor = Colors.pink;

  @override
  void update(double dt) {
    final playerPos = game.player.position;
    moveTowardsPlayer(
        Vector2(playerPos.x, playerPos.y), dt); // Centre du joueur

    super.update(dt);
  }

  void moveTowardsPlayer(Vector2 playerPosition, double dt) {
    position.add((playerPosition - position).normalized() * 250 * dt);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bullet) {
      other.removeFromParent();
      removeFromParent();
      game.enemies.remove(this);
    } else if (other is Player) {
      hitbox.paint.color = _collisionPlayerHitColor;
    } else if (other is WeakEnemy) {
      hitbox.paint.color = _collisionStartColor;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    hitbox.paint.color = _defaultColor;
  }
}

class WeakEnemy extends Enemy {
  WeakEnemy() : super();

  final damage = 1;

  @override
  Future<void> onLoad() async {
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;
    hitbox = CircleHitbox()
      ..paint = defaultPaint
      ..renderShape = true
      ..collisionType = CollisionType.active;

    sprite = await game.loadSprite('flight_enemy.png');
    sprite?.srcSize = Vector2(150, 150);

    anchor = Anchor.center;

    add(hitbox);
  }
}
