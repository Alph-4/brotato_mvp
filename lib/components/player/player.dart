import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:space_botato/components/bullet/bullet.dart';
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
    // Stats will be initialized in onLoad
    add(RectangleHitbox()..size = Vector2(50, 50));
  }

  late SpriteAnimation astronautIdle;
  late SpriteAnimation astronautDown;
  late SpriteAnimation astronautRight;
  late SpriteAnimation astronautLeft;
  late SpriteAnimation astronautUp;
  late PlayerClassDetails selectedClass;

  // Remplacer les champs individuels par un objet stats
  late PlayerStats stats;

  // Keep exp separate as it's not really a "stat" in the same way
  double exp = 0;
  double maxExp = 100;
  double _shootTimer = 0;

  late final GameHUD hud;

  @override
  FutureOr<void> onLoad() async {
    // Initialize stats from the selected class
    stats = PlayerStats.fromClass(selectedClass);

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
    // Apply defense calculation here if needed (e.g., damage reduction)
    double actualDamage = damage.toDouble(); // Simplified for now
    stats.currentHealth -= actualDamage;
    hud.updateHealth(stats.currentHealth);
    if (stats.currentHealth <= 0) {
      game.onPlayerDeath();
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

    _autoShoot(dt);

    if (game.joystick.direction != JoystickDirection.idle) {
      position.add(game.joystick.relativeDelta * (stats.moveSpeed * 400) * dt);
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

  void _autoShoot(double dt) {
    _shootTimer += dt;
    // Calculate attack interval based on attackSpeed (attacks per second)
    // Ensure attackSpeed is at least something small to avoid division by zero
    final attackSpeed = stats.attackSpeed > 0 ? stats.attackSpeed : 0.1;
    final interval = 1.0 / attackSpeed;

    if (_shootTimer >= interval) {
      final enemies = game.children.whereType<Enemy>().toList();
      if (enemies.isNotEmpty) {
        Enemy? closestEnemy;
        double closestDistance = double.infinity;
        final range = stats.range; // Use range from stats

        for (final enemy in enemies) {
          final distance = (enemy.position - position).length;
          if (distance < closestDistance && distance <= range) {
            closestDistance = distance;
            closestEnemy = enemy;
          }
        }

        if (closestEnemy != null) {
          final direction = (closestEnemy.position - position).normalized();
          final bullet = Bullet(direction: direction);
          bullet.position = position.clone(); // Start at player position
          game.add(bullet);
          _shootTimer = 0;
        }
      }
    }
  }
}
