import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class PlayerAnimations {
  late SpriteAnimation idle;
  late SpriteAnimation down;
  late SpriteAnimation right;
  late SpriteAnimation left;
  late SpriteAnimation up;

  Future<void> load(SpriteSheet spriteSheet) async {
    idle = spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: 1);
    down = spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: 8);
    right = spriteSheet.createAnimation(row: 1, stepTime: 0.1, to: 8);
    up = spriteSheet.createAnimation(row: 2, stepTime: 0.1, to: 8);
    left = SpriteAnimation(right.frames.reversed.toList());
  }
} 