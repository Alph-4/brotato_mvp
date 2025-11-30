import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/palette.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:space_botato/core/game.dart';
import 'package:space_botato/core/providers.dart';
import 'package:space_botato/components/player/player.dart';
import 'package:flame/sprite.dart';

class GoldDrop extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<SpaceBotatoGame> {
  GoldDrop({required Vector2 position})
      : super(
          position: position,
          size: Vector2.all(24),
          anchor: Anchor.center,
          priority: 50,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
    // Charge l'animation à partir des 4 PNGs
    final frames = [
      await gameRef.images.load('coin_1.png'),
      await gameRef.images.load('coin_2.png'),
      await gameRef.images.load('coin_3.png'),
      await gameRef.images.load('coin_4.png'),
    ];
    animation = SpriteAnimation.spriteList(
      frames.map((img) => Sprite(img)).toList(),
      stepTime: 0.12,
      loop: true,
    );
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      final currentGold = gameRef.ref.read(goldProvider);
      gameRef.ref.read(goldProvider.notifier).state = currentGold + 1;
      removeFromParent();
      // Optionnel: feedback visuel ou son
    }
  }
}
