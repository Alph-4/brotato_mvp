import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:space_botato/core/game.dart';
import 'package:space_botato/models/player_class.dart';

class GameHUD extends PositionComponent with HasGameReference<SpaceBotatoGame> {
  // Constants for visual configuration
  static const double barWidth = 200;
  static const double barHeight = 20;
  static const double padding = 10;
  static const double cornerRadius = 5;

  // Layout constants
  static const double initialX = 10;
  static const double initialY = 50;
  static const double attributeSpacing = 20;

  // Current and maximum values
  double _maxExp = 100;
  double _maxHealth = 100;
  double _health = 100;
  double _exp = 0;
  int _attack = 0;
  int _defense = 0;
  int _mana = 0;
  double _dodgeRate = 0;

  double _displayedHealth = 100;
  double _displayedExp = 0;

  GameHUD() {
    // Use constants for initial position
    position = Vector2(initialX, initialY);
  }

  void initAttributes(PlayerClassDetails details) {
    _attack = details.attack;
    _defense = details.defense;
    _mana = details.mana;
    _dodgeRate = details.dodgeRate;
    _displayedExp = 0;
    _maxHealth = details.maxHealth.toDouble();

    _displayedHealth = details.maxHealth.toDouble();

    updateHealth(_maxHealth);
  }

  void updateAttributes(PlayerClassDetails details) {
    _attack = details.attack;
    _defense = details.defense;
    _mana = details.mana;
    _dodgeRate = details.dodgeRate;

    updateHealth(_maxHealth);
  }

  void updateHealth(double newHealth) {
    _health = newHealth.clamp(0, _maxHealth);
  }

  void updateExp(double newExp) {
    _exp = newExp.clamp(0, _maxExp);
  }

  void reset() {
    _health = _maxHealth;
    _exp = 0;
    _attack = 0;
    _defense = 0;
    _mana = 0;
    _dodgeRate = 0;
    _displayedHealth = _maxHealth;
    _displayedExp = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Smooth animation for bars
    const animationSpeed = 5.0;
    _displayedHealth += (_health - _displayedHealth) * dt * animationSpeed;
    _displayedExp += (_exp - _displayedExp) * dt * animationSpeed;
  }

  void _drawBar(
    Canvas canvas,
    double y,
    double current,
    double max,
    Color fillColor,
    String label,
  ) {
    final backgroundPaint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.fill;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw background
    final backgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, y, barWidth, barHeight),
      const Radius.circular(cornerRadius),
    );
    canvas.drawRRect(backgroundRect, backgroundPaint);

    // Draw fill bar
    if (current > 0) {
      final fillWidth = (current / max * barWidth).clamp(0, barWidth);
      final fillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, y, fillWidth.toDouble(), barHeight),
        const Radius.circular(cornerRadius),
      );
      canvas.drawRRect(fillRect, fillPaint);
    }

    // Draw border
    canvas.drawRRect(backgroundRect, borderPaint);

    // Draw text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$label: ${current.toInt()}/${max.toInt()}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (barWidth - textPainter.width) / 2,
        y + (barHeight - textPainter.height) / 2,
      ),
    );
  }

  void _drawAttribute(
    Canvas canvas,
    double y,
    String label,
    String value,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$label: $value',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(0, y));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Calculate positions dynamically
    double currentY = 0;

    // Draw health bar
    _drawBar(
      canvas,
      currentY,
      _displayedHealth,
      _maxHealth,
      Colors.red,
      'HP',
    );
    currentY += barHeight + padding;

    // Draw experience bar
    _drawBar(
      canvas,
      currentY,
      _displayedExp,
      _maxExp,
      Colors.blue,
      'EXP',
    );
    currentY += barHeight + padding;

    // Draw attributes
    _drawAttribute(canvas, currentY, 'Attack', _attack.toString());
    currentY += attributeSpacing;
    _drawAttribute(canvas, currentY, 'Defense', _defense.toString());
    currentY += attributeSpacing;
    _drawAttribute(canvas, currentY, 'Mana', _mana.toString());
    currentY += attributeSpacing;
    _drawAttribute(
        canvas, currentY, 'Dodge', '${(_dodgeRate * 100).toStringAsFixed(1)}%');
  }
}
