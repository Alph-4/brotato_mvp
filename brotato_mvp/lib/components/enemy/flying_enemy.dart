import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:space_botato/components/enemy/enemy.dart';
import 'package:space_botato/core/constants.dart';

class FlyingEnemy extends Enemy {
  FlyingEnemy() : super() {
    damage = kEnemyBaseDamage;
  }

  @override
  Future<void> onLoad() async {
    // Charger et configurer l'animation
    //1200 × 150
    final spriteSheet = SpriteSheet(
      image: await game.images.load('flight_enemy.png'),
      srcSize: Vector2(150, 18), // Ajustez selon la taille de votre spritesheet
    );

    // Créer l'animation de vol
    animation = spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.1,
      from: 0,
      to: 8, // Ajustez selon le nombre de frames dans votre animation
    );

    size = Vector2(1500, 180);
    
    // Configurer la hitbox
    final defaultPaint = Paint()
      ..color = Colors.cyan
      ..style = PaintingStyle.stroke;

    hitbox = CircleHitbox(
      radius: kEnemyHitboxSize / 2,
      position: Vector2(
        size.x / 2 - kEnemyHitboxSize / 2,
        size.y / 2 - kEnemyHitboxSize / 2,
      ),
    )
      ..paint = defaultPaint
      ..renderShape = true
      ..collisionType = CollisionType.active;

    add(hitbox);
  }
} 