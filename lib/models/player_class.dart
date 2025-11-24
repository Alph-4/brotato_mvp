enum PlayerClass { archer, warrior, mage }

enum FightStyleClass { melee, ranged, magic }

class PlayerClassDetails {
  final String name;
  final String description;
  final int maxHealth;
  final int attack;
  final int defense;
  final FightStyleClass fightStyle;
  final double moveSpeed;
  final double attackSpeed;
  final double dodgeRate;
  final int mana;
  final String startingWeapon;

  const PlayerClassDetails({
    required this.name,
    required this.description,
    required this.maxHealth,
    required this.attack,
    required this.defense,
    required this.fightStyle,
    required this.moveSpeed,
    required this.attackSpeed,
    required this.dodgeRate,
    required this.mana,
    required this.startingWeapon,
  });

  static const Map<PlayerClass, PlayerClassDetails> classes = {
    PlayerClass.archer: PlayerClassDetails(
      name: "Archer",
      description: "Un maître des arcs et des flèches, rapide et précis.",
      maxHealth: 80,
      attack: 15,
      defense: 5,
      fightStyle: FightStyleClass.ranged,
      moveSpeed: 1.2,
      attackSpeed: 1.5,
      dodgeRate: 0.2,
      mana: 50,
      startingWeapon: "bow",
    ),
    PlayerClass.warrior: PlayerClassDetails(
      name: "Guerrier",
      description: "Un combattant puissant avec une grande force et endurance.",
      maxHealth: 120,
      attack: 10,
      defense: 10,
      fightStyle: FightStyleClass.melee,
      moveSpeed: 1.0,
      attackSpeed: 1.0,
      dodgeRate: 0.1,
      mana: 30,
      startingWeapon: "sword",
    ),
    PlayerClass.mage: PlayerClassDetails(
      name: "Mage",
      description:
          "Un utilisateur de magie capable de lancer des sorts puissants.",
      maxHealth: 70,
      attack: 20,
      defense: 3,
      fightStyle: FightStyleClass.magic,
      moveSpeed: 1.1,
      attackSpeed: 1.3,
      dodgeRate: 0.15,
      mana: 100,
      startingWeapon: "staff",
    ),
  };

  static PlayerClassDetails get(PlayerClass playerClass) =>
      classes[playerClass]!;
}

class PlayerStats {
  double maxHealth;
  double currentHealth;
  double damage;
  double defense;
  double moveSpeed;
  double attackSpeed;
  double critChance;
  double range;

  PlayerStats({
    required this.maxHealth,
    required this.currentHealth,
    required this.damage,
    required this.defense,
    required this.moveSpeed,
    required this.attackSpeed,
    required this.critChance,
    required this.range,
  });

  factory PlayerStats.fromClass(PlayerClassDetails details) {
    return PlayerStats(
      maxHealth: details.maxHealth.toDouble(),
      currentHealth: details.maxHealth.toDouble(),
      damage: details.attack.toDouble(),
      defense: details.defense.toDouble(),
      moveSpeed: details.moveSpeed,
      attackSpeed: details.attackSpeed,
      critChance: details
          .dodgeRate, // Using dodgeRate as critChance for now or add crit to details
      range: 200, // Default range
    );
  }
}
