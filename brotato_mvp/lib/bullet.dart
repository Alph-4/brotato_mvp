import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'dart:math';
import 'dart:async' as da;
import 'package:brotato_mvp/main.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class Bullet extends SpriteComponent with HasGameReference<BrotatoGame> {
  final Vector2 direction;
  Bullet({required this.direction}) : super(size: Vector2(20, 20));

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('projectile.png');
    add(RectangleHitbox()..collisionType = CollisionType.active);
  }

  @override
  void update(double dt) {
    position += direction * 500 * dt;
    if (position.x < 0 ||
        position.x > game.size.x ||
        position.y < 0 ||
        position.y > game.size.y) {
      removeFromParent();
    }
  }
}
