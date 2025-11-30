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
  int _gold = 0;
  double _timer = 0;
  int _level = 1;
  int _wave = 1;

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

  void updateGold(int gold) {
    _gold = gold;
  }

  void updateTimer(double timer) {
    _timer = timer;
  }
  

  void updateLevel(int level) {
    _level = level;
  }

  void updateWave(int wave) {
    _wave = wave;
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

    double currentY = 0;

    // Fond HUD
    canvas.drawRect(
      Rect.fromLTWH(-10, -10, barWidth + 40, 90),
      Paint()..color = Colors.black.withOpacity(0.7),
    );

    // Barre de vie (rouge)
    _drawBar(
      canvas,
      currentY,
      _displayedHealth,
      _maxHealth,
      Colors.red,
      'HP',
    );
    currentY += barHeight + 2;

    // Barre d'XP (verte) + niveau
    _drawBar(
      canvas,
      currentY,
      _displayedExp,
      _maxExp,
      Colors.green,
      'XP',
    );
    // Affichage du niveau LV
    final lvPainter = TextPainter(
      text: TextSpan(
        text: 'LV $_level',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    lvPainter.layout();
    lvPainter.paint(canvas, Offset(barWidth + 10, currentY));
    currentY += barHeight + 8;

    // Gold (icône + nombre)
    final goldPainter = TextPainter(
      text: TextSpan(
        text: '🟡 $_gold',
        style: const TextStyle(
          color: Colors.yellow,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    goldPainter.layout();
    goldPainter.paint(canvas, Offset(0, currentY));
    currentY += goldPainter.height + 8;

    // Indicateur de wave + timer (au centre en haut)
    final wavePainter = TextPainter(
      text: TextSpan(
        text: 'WAVE $_wave',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    wavePainter.layout();
    wavePainter.paint(
        canvas, Offset(barWidth / 2 - wavePainter.width / 2, -35));

    final timerPainter = TextPainter(
      text: TextSpan(
        text: _timer.toStringAsFixed(0),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    timerPainter.layout();
    timerPainter.paint(
        canvas, Offset(barWidth / 2 - timerPainter.width / 2, -5));
  }
}
