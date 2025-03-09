import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:space_botato/components/bullet/bullet.dart';
import 'package:space_botato/components/player/player.dart';
import 'package:space_botato/core/constants.dart';
import 'package:space_botato/core/game.dart';

abstract class Enemy extends SpriteComponent
    with HasGameReference<SpaceBotatoGame>, CollisionCallbacks {
  Enemy() : super(size: Vector2(kEnemySize, kEnemySize)) {
    add(RectangleHitbox()..size = Vector2(kEnemyHitboxSize, kEnemyHitboxSize));
  }

  late ShapeHitbox hitbox;
  int damage = kEnemyBaseDamage;

  final _defaultColor = Colors.cyan;
  final _collisionStartColor = Colors.amber;
  final _collisionBulletHitColor = Colors.red;
  final _collisionPlayerHitColor = Colors.pink;

  @override
  void update(double dt) {
    if (game.player != null) {
      final playerPos = game.player.position;
      moveTowardsPlayer(playerPos, dt);
    }
    super.update(dt);
  }

  void moveTowardsPlayer(Vector2 playerPosition, double dt) {
    position.add((playerPosition - position).normalized() * kEnemySpeed * dt);
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
    } else if (other is Enemy) {
      hitbox.paint.color = _collisionStartColor;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    hitbox.paint.color = _defaultColor;
  }
} 