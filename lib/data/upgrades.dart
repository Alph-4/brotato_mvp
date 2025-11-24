import 'package:flutter/material.dart';
import 'package:space_botato/models/upgrade.dart';

final List<Upgrade> allUpgrades = [
  Upgrade(
    id: 'muscle',
    name: 'Muscles',
    description: '+5 Dégâts',
    icon: Icons.fitness_center,
    color: Colors.red,
    cost: 50,
    effects: {StatType.damage: 5},
  ),
  Upgrade(
    id: 'coffee',
    name: 'Café',
    description: '+10% Vitesse d\'attaque\n-2 Dégâts',
    icon: Icons.coffee,
    color: Colors.brown,
    cost: 40,
    effects: {
      StatType.attackSpeed: 0.10,
      StatType.damage: -2,
    },
  ),
  Upgrade(
    id: 'sneakers',
    name: 'Baskets',
    description: '+5% Vitesse de déplacement',
    icon: Icons.directions_run,
    color: Colors.blue,
    cost: 30,
    effects: {StatType.moveSpeed: 0.05},
  ),
  Upgrade(
    id: 'helmet',
    name: 'Casque',
    description: '+3 Défense',
    icon: Icons.security,
    color: Colors.grey,
    cost: 45,
    effects: {StatType.defense: 3},
  ),
  Upgrade(
    id: 'heart',
    name: 'Cœur Vital',
    description: '+20 PV Max',
    icon: Icons.favorite,
    color: Colors.green,
    cost: 60,
    effects: {StatType.maxHealth: 20},
  ),
  Upgrade(
    id: 'scope',
    name: 'Lunette',
    description: '+5% Chance Critique',
    icon: Icons.remove_red_eye,
    color: Colors.purple,
    cost: 55,
    effects: {StatType.critChance: 5},
  ),
];
