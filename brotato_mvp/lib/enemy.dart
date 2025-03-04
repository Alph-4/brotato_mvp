import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:space_botato/bullet.dart';
import 'package:space_botato/game.dart';
import 'package:space_botato/player.dart';

abstract class Enemy extends SpriteComponent
    with HasGameReference<SpaceBotatoGame>, CollisionCallbacks {
  Enemy() : super(size: Vector2(150, 150)) {
    add(RectangleHitbox()..size = Vector2(50, 50));
  }
  late ShapeHitbox hitbox;
  late SpriteAnimationComponent flight;
  final _defaultColor = Colors.cyan;
  final _collisionStartColor = Colors.amber;
  final _collisionBulletHitColor = Colors.red;
  final _collisionPlayerHitColor = Colors.pink;
  int damage = 1; // Valeur par défaut pour tous les ennemis

  @override
  void update(double dt) {
    if (game.player != null) {
      final playerPos = game.player!.position;
      moveTowardsPlayer(
          Vector2(playerPos.x, playerPos.y), dt); // Centre du joueur
    }
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
