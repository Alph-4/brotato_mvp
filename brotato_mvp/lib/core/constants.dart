import 'package:flutter/material.dart';

// Styles communs
const kTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

final kButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blueGrey[800],
  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
);

// Configuration du joueur
const kPlayerInitialHealth = 100.0;
const kPlayerInitialExp = 0.0;
const kPlayerMaxExp = 100.0;
const kPlayerSpeed = 450.0;
const kPlayerSize = 64.0;
const kPlayerHitboxSize = 50.0;

// Configuration des ennemis
const kEnemySize = 150.0;
const kEnemyHitboxSize = 50.0;
const kEnemySpeed = 250.0;
const kEnemyBaseDamage = 1;

// Configuration des projectiles
const kBulletSize = 20.0;
const kBulletSpeed = 500.0;

// Configuration du HUD
const kHudBarWidth = 200.0;
const kHudBarHeight = 20.0;
const kHudPadding = 10.0;
const kHudCornerRadius = 5.0;

// Configuration du jeu
const kEnemiesPerWave = 5;
const kMaxSpawnDelay = 5; 