import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:space_botato/components/enemy/enemy.dart';
import 'package:space_botato/components/player/player_animations.dart';
import 'package:space_botato/core/game.dart';
import 'package:space_botato/core/providers.dart';
import 'package:space_botato/main.dart';
import 'package:space_botato/components/hud/hud.dart';
import 'package:space_botato/models/player_class.dart';

class Player extends SpriteAnimationComponent
    with
        HasGameReference<SpaceBotatoGame>,
        CollisionCallbacks,
        RiverpodComponentMixin {
  Player({required this.selectedClass}) : super(size: Vector2(64, 104)) {
    // Initialize stats based on the selected class
    health = selectedClass.maxHealth.toDouble();
    maxHealth = selectedClass.maxHealth.toDouble();
    selectedClass =
        selectedClass; // Additional stats like attack and defense can be initialized here if needed
    add(RectangleHitbox()..size = Vector2(50, 50));
  }

  late SpriteAnimation astronautIdle;
  late SpriteAnimation astronautDown;
  late SpriteAnimation astronautRight;
  late SpriteAnimation astronautLeft;
  late SpriteAnimation astronautUp;
  late PlayerClassDetails selectedClass;

  double health = 100;
  double maxHealth = 100;
  double exp = 0;
  double maxExp = 100;

  late final GameHUD hud;

  @override
  FutureOr<void> onLoad() async {
    await loadPlayer();
    game.children.whereType<GameHUD>().forEach(game.remove);
    hud = GameHUD();
    // Initialiser et ajouter le HUD
    hud.initAttributes(selectedClass);
    // game.add(hud);

    return super.onLoad();
  }

  Future<void> loadPlayer() async {
    final spriteSheet = SpriteSheet(
      image: await game.images.load('astronaut.png'),
      srcSize: Vector2(32, 52),
    );

    final playerAnimations = PlayerAnimations();
    await playerAnimations.load(spriteSheet);
    astronautIdle = playerAnimations.idle;
    astronautDown = playerAnimations.down;
    astronautRight = playerAnimations.right;
    astronautUp = playerAnimations.up;
    astronautLeft = playerAnimations.left;
    animation = playerAnimations.idle;
    size = Vector2(32, 52);
    anchor = Anchor.center;

    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  void takeDamage(int damage) {
    health -= damage;
    hud.updateHealth(health);
    if (health <= 0) {
      // game.onPlayerDeath();
    }
  }

  void gainExp(double amount) {
    exp += amount;
    if (exp >= maxExp) {
      // Logique de niveau supérieur ici
      exp = 0;
    }
    hud.updateExp(exp);
  }

  void reset() {
    hud.reset();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Enemy) {
      takeDamage(other.damage);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (ref.watch(gameStateProvider.notifier).state != GameState.playing) {
      return;
    }

    if (game.joystick.direction != JoystickDirection.idle) {
      position.add(
          game.joystick.relativeDelta * (selectedClass.moveSpeed * 400) * dt);
    }

    if (game.joystick.direction != JoystickDirection.idle) {
      if (game.joystick.relativeDelta.x.abs() >
          game.joystick.relativeDelta.y.abs()) {
        if (game.joystick.relativeDelta.x > 0) {
          animation = astronautRight;
        } else {
          animation = astronautLeft;
        }
      } else {
        animation =
            game.joystick.relativeDelta.y > 0 ? astronautDown : astronautUp;
      }
    } else {
      animation = astronautIdle;
    }

    position.x = position.x.clamp(0, game.size.x - size.x);
    position.y = position.y.clamp(0, game.size.y - size.y);
  }
}
