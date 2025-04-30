
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class MushroomEnemyAnimations {
  late final SpriteAnimation idle;
  late final SpriteAnimation attack;
  late final SpriteAnimation hit;
  late final SpriteAnimation death;

  Future<void> loadIdle(SpriteSheet spriteSheet) async {
    idle = spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: 3);
  }

  Future<void> loadAttack(SpriteSheet spriteSheet) async {
    attack = spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: 1);
  }

  Future<void> loadHit(SpriteSheet spriteSheet) async {
    hit = spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: 3);
  }

  Future<void> loadDeath(SpriteSheet spriteSheet) async {
    death = spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: 3);
  }
  
  
}
