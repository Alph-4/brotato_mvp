import 'dart:math';

import 'package:flutter/material.dart';
import 'package:space_botato/screens/death_menu.dart';
import 'package:space_botato/screens/main_menu.dart';
import 'package:space_botato/screens/pause_menu.dart';
import 'package:space_botato/screens/settings_button.dart';
import 'package:space_botato/screens/shop_menu.dart';
import 'package:space_botato/screens/win_screen.dart';

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


final gameOverlays = {
  MainMenu.id: (context, game) => MainMenu(game: game),
  PauseMenu.id: (context, game) => PauseMenu(game: game),
  DeathMenu.id: (context, game) => DeathMenu(game: game),
  ShopMenu.id: (context, game) => ShopMenu(game: game),
  SettingsButton.id: (context, game) => SettingsButton(game: game),
  WinScreen.id: (context, game) => WinScreen(game: game),
};

// Configuration du joueur
const kPlayerInitialHealth = 100.0;
const kPlayerInitialExp = 0.0;
const kPlayerMaxExp = 100.0;
const kPlayerSpeed = 450.0;
const kPlayerSize = 64.0;
const kPlayerHitboxSize = 50.0;

// Configuration des ennemis
const kEnemySize = 100.0;
const kEnemyHitboxSize = 25.0;
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
const kMaxSpawnDelay = 5; 
const kMaxWaves = 3;