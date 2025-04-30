import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:space_botato/components/bullet/bullet.dart';
import 'package:space_botato/components/enemy/mushroom_enemy.dart';
import 'package:space_botato/components/player/player.dart';
import 'package:space_botato/core/constants.dart';
import 'package:space_botato/core/game.dart';
import 'package:space_botato/main.dart';
import 'package:space_botato/components/enemy/flying_enemy.dart';

abstract class Enemy extends SpriteAnimationComponent
    with HasGameReference<SpaceBotatoGame>, CollisionCallbacks {
  Enemy() : super(size: Vector2(kEnemySize, kEnemySize)) {
    anchor = Anchor.center;
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
      //moveTowardsPlayer(playerPos, dt);
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
      if (this is FlyingEnemy) {
        final flyingEnemy = this as FlyingEnemy;
        flyingEnemy.animation = flyingEnemy.animations.death;
        // Wait for the death animation to complete before removing
        
        Future.delayed(Duration(milliseconds: 400), () {
          if (flyingEnemy.isMounted) {
            flyingEnemy.removeFromParent();
            game.enemies.remove(flyingEnemy);
          }
        });
      }
      else if (this is MushroomEnemy) {
        final mushroomEnemy = this as MushroomEnemy;
        mushroomEnemy.animation = mushroomEnemy.animations.death;
        Future.delayed(Duration(milliseconds: 600), () {
          if (mushroomEnemy.isMounted) {
            mushroomEnemy.removeFromParent();
            game.enemies.remove(mushroomEnemy);
          }
        });
      }
      else {
        removeFromParent();
        game.enemies.remove(this);
      }
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