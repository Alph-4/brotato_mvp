import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:space_botato/core/game.dart';

class GameHUD extends PositionComponent with HasGameRef<SpaceBotatoGame> {
  // Constantes pour la configuration visuelle
  static const double barWidth = 200;
  static const double barHeight = 20;
  static const double padding = 10;
  static const double cornerRadius = 5;
  
  // Valeurs actuelles et maximales
  double _health = 100;
  double _maxHealth = 100;
  double _exp = 0;
  double _maxExp = 100;

  // Valeurs pour l'animation fluide
  double _displayedHealth = 100;
  double _displayedExp = 0;

  GameHUD() {
    // Position fixe en haut à gauche
    position = Vector2(20, 20);
  }

  void updateHealth(double newHealth) {
    _health = newHealth.clamp(0, _maxHealth);
  }

  void updateExp(double newExp) {
    _exp = newExp.clamp(0, _maxExp);
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Animation fluide des barres
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

    // Dessiner le fond
    final backgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, y, barWidth, barHeight),
      const Radius.circular(cornerRadius),
    );
    canvas.drawRRect(backgroundRect, backgroundPaint);

    // Dessiner la barre de remplissage
    if (current > 0) {
      final fillWidth = (current / max * barWidth).clamp(0, barWidth);
      final fillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, y, fillWidth.toDouble(), barHeight),
        const Radius.circular(cornerRadius),
      );
      canvas.drawRRect(fillRect, fillPaint);
    }

    // Dessiner la bordure
    canvas.drawRRect(backgroundRect, borderPaint);

    // Dessiner le texte
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

  @override
  void render(Canvas canvas) {
    // Dessiner la barre de vie
    _drawBar(
      canvas,
      0,
      _displayedHealth,
      _maxHealth,
      Colors.red,
      'HP',
    );

    // Dessiner la barre d'expérience
    _drawBar(
      canvas,
      barHeight + padding,
      _displayedExp,
      _maxExp,
      Colors.blue,
      'EXP',
    );
  }
} 