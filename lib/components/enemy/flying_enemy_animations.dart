import 'package:flame/sprite.dart';

class FlyingEnemyAnimations {
  late SpriteAnimation idle;
  late SpriteAnimation attack;
  late SpriteAnimation hit;
  late SpriteAnimation death;

  Future<void> loadDeath(SpriteSheet spriteSheet) async {
    death = spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: 3);
  }

  Future<void> loadIdle(SpriteSheet spriteSheet) async {
    idle = spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: 7);
  }

  Future<void> loadAttack(SpriteSheet spriteSheet) async {
    attack = spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: 1);
  }

  Future<void> loadHit(SpriteSheet spriteSheet) async {
    hit = spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: 3);
  }
}
