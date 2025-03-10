import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:space_botato/components/enemy/enemy.dart';
import 'package:space_botato/components/enemy/mushroom_enemy_animations.dart';
import 'package:space_botato/core/constants.dart';

class MushroomEnemy extends Enemy {
  late final MushroomEnemyAnimations animations;
  
  MushroomEnemy() : super(){
    damage = kEnemyBaseDamage*10;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
   animations = MushroomEnemyAnimations();
   animations.loadIdle(SpriteSheet(
      image: await game.images.load('mushroom_enemy_idle.png'),
      srcSize: Vector2(150, 150), // Taille d'une frame
    ));
    animations.loadDeath(SpriteSheet(
      image: await game.images.load('mushroom_enemy_death.png'),
      srcSize: Vector2(150, 150), // Taille d'une frame
    ));

    animation = animations.idle;
    size = Vector2(300, 300);
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

