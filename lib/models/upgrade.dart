import 'package:flutter/material.dart';

enum StatType {
  maxHealth,
  damage,
  attackSpeed,
  moveSpeed,
  defense,
  critChance,
}

class Upgrade {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int cost;
  final Map<StatType, double> effects;

  const Upgrade({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.cost,
    required this.effects,
  });
}
