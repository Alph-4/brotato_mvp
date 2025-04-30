import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:space_botato/components/enemy/enemy.dart';
import 'package:space_botato/components/enemy/flying_enemy_animations.dart';
import 'package:space_botato/core/constants.dart';

class FlyingEnemy extends Enemy {
  late final FlyingEnemyAnimations animations;

  FlyingEnemy() : super() {
    damage = kEnemyBaseDamage;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    animations = FlyingEnemyAnimations();
    // Charger et configurer l'animation
    animations.loadIdle(SpriteSheet(
      image: await game.images.load('flying_eye_idle.png'),
      srcSize: Vector2(150, 150), // Taille d'une frame
    ));

    animations.loadDeath(SpriteSheet(
      image: await game.images.load('flying_eye_death.png'),
      srcSize: Vector2(150, 150), // Taille d'une frame
    ));

    animations.loadAttack(SpriteSheet(
      image: await game.images.load('flying_eye_attack.png'),
      srcSize: Vector2(150, 150), // Taille d'une frame
    ));

    animations.loadHit(SpriteSheet(
      image: await game.images.load('flying_eye_hit.png'),
      srcSize: Vector2(150, 150), // Taille d'une frame
    ));

    // Créer l'animation de vol
    animation = animations.idle;

    // Définir la taille du composant
    size = Vector2(150, 150);
    
    // Configurer la hitbox
    final defaultPaint = Paint()
      ..color = Colors.cyan
      ..style = PaintingStyle.stroke;

    hitbox = CircleHitbox(
      radius: 60, // Taille de la hitbox plus petite que le sprite
    )
      ..paint = defaultPaint
      ..renderShape = true
      ..anchor = Anchor.center
      ..collisionType = CollisionType.active;

    hitbox.position = Vector2(size.x/2, size.y/2);  
    add(hitbox);
  }
} 