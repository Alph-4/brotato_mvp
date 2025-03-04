import 'dart:async';
import 'dart:ui';

import 'package:brotato_mvp/enemy.dart';
import 'package:brotato_mvp/game.dart';
import 'package:brotato_mvp/main.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef<BrotatoGame>, CollisionCallbacks {
  Player() : super(size: Vector2(64, 104)) {
    {
      add(RectangleHitbox()..size = Vector2(50, 50));
    }
  }

  late SpriteAnimation astronautIdle;
  late SpriteAnimation astronautDown;
  late SpriteAnimation astronautRight;
  late SpriteAnimation astronautLeft;
  late SpriteAnimation astronautUp;
  late final HealthBar healthBar = HealthBar();
  late final ExpBar expBar = ExpBar();

  int health = 100;

  @override
  FutureOr<void> onLoad() async {
    await loadPlayer();

    return super.onLoad();
  }

  Future<void> loadPlayer() async {
    final spriteSheet = SpriteSheet(
      image: await game.images.load('astronaut.png'),
      srcSize: Vector2(32, 52),
    );

    astronautIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: 1);
    astronautDown = spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: 8);
    astronautRight = spriteSheet.createAnimation(row: 1, stepTime: 0.1, to: 8);
    astronautUp = spriteSheet.createAnimation(row: 2, stepTime: 0.1, to: 8);
    astronautLeft = SpriteAnimation(
      astronautRight.frames.reversed.toList(), // Inversion des frames
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: 1);
    size = Vector2(64, 104);
    anchor = Anchor.center;

    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  void takeDamage(int damage) {
    health -= damage;
    healthBar.updateHealth(health.toDouble());
    if (health <= 0) {
      game.onPlayerDeath();
    }
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
    if (game.state != GameState.playing) return;

    if (game.joystick.direction != JoystickDirection.idle) {
      position.add(game.joystick.relativeDelta * 450 * dt);
    }

    if (game.joystick.direction != JoystickDirection.idle) {
      // Gestion des animations
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

class HealthBar extends PositionComponent {
  double health = 100; // valeur initiale de la vie
  double maxWidth = 100; // largeur maximale de la barre de vie

  HealthBar() {
    width = maxWidth;
    height = 20;
  }

  void updateHealth(double newHealth) {
    health = newHealth;
  }

  @override
  void render(Canvas canvas) {
    double marginTop = 0; // add margin top
    double marginLeft = 0; // add margin left

    // Dessinez la barre de vie
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${health ~/ 1}/${maxWidth ~/ 1}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        marginLeft + (maxWidth - textPainter.width) / 2,
        marginTop + (height - textPainter.height) / 2,
      ),
    );
  }
}

class ExpBar extends PositionComponent {
  double exp = 0; // valeur initiale de la vie
  double maxExp = 10; // largeur maximale de la barre de vie

  ExpBar() {
    width = maxExp;
    height = 20;
  }

  void updateExp(double newExp) {
    exp = newExp;
  }

  @override
  void render(Canvas canvas) {
    double marginTop = 0; // add margin top
    double marginLeft = 0; // add margin left

    // Dessinez la barre de vie
    canvas.drawRect(Rect.fromLTWH(marginLeft, marginTop, width, height),
        Paint()..color = const Color.fromARGB(255, 54, 95, 244));

    // Dessinez la quantité de vie restante
    canvas.drawRect(
        Rect.fromLTWH(marginLeft, marginTop, exp / 100 * maxExp, height),
        Paint()..color = Colors.green);
  }
}