enum PlayerClass {
  archer,
  warrior,
  mage,
  assassin,
  engineer,
  priest,
  tank,
  gunner,
  necromancer,
  paladin
}

enum FightStyleClass { melee, ranged, magic, tech }

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
  final String passive;

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
    required this.passive,
  });

  static const Map<PlayerClass, PlayerClassDetails> classes = {
    PlayerClass.archer: PlayerClassDetails(
      name: "Archer",
      description: "Maître des arcs, rapide et précis.",
      maxHealth: 80,
      attack: 15,
      defense: 5,
      fightStyle: FightStyleClass.ranged,
      moveSpeed: 1.2,
      attackSpeed: 1.5,
      dodgeRate: 0.2,
      mana: 50,
      startingWeapon: "bow",
      passive: "+20% vitesse d'attaque si pas touché depuis 5s",
    ),
    PlayerClass.warrior: PlayerClassDetails(
      name: "Guerrier",
      description: "Force et endurance.",
      maxHealth: 120,
      attack: 10,
      defense: 10,
      fightStyle: FightStyleClass.melee,
      moveSpeed: 1.0,
      attackSpeed: 1.0,
      dodgeRate: 0.1,
      mana: 30,
      startingWeapon: "sword",
      passive: "+10% dégâts si vie > 50%",
    ),
    PlayerClass.mage: PlayerClassDetails(
      name: "Mage",
      description: "Sorts puissants.",
      maxHealth: 70,
      attack: 20,
      defense: 3,
      fightStyle: FightStyleClass.magic,
      moveSpeed: 1.1,
      attackSpeed: 1.3,
      dodgeRate: 0.15,
      mana: 100,
      startingWeapon: "staff",
      passive: "+1 mana/sec, +10% dégâts magiques",
    ),
    PlayerClass.assassin: PlayerClassDetails(
      name: "Assassin",
      description: "Frappe rapide, critique élevé.",
      maxHealth: 75,
      attack: 18,
      defense: 4,
      fightStyle: FightStyleClass.melee,
      moveSpeed: 1.4,
      attackSpeed: 1.7,
      dodgeRate: 0.25,
      mana: 40,
      startingWeapon: "dagger",
      passive: "+30% dégâts sur les ennemis isolés",
    ),
    PlayerClass.engineer: PlayerClassDetails(
      name: "Ingénieur",
      description: "Utilise des tourelles et gadgets.",
      maxHealth: 90,
      attack: 12,
      defense: 6,
      fightStyle: FightStyleClass.tech,
      moveSpeed: 1.0,
      attackSpeed: 1.2,
      dodgeRate: 0.12,
      mana: 60,
      startingWeapon: "turret",
      passive: "Pose une tourelle toutes les 20s",
    ),
    PlayerClass.priest: PlayerClassDetails(
      name: "Prêtre",
      description: "Soigne et protège.",
      maxHealth: 85,
      attack: 10,
      defense: 8,
      fightStyle: FightStyleClass.magic,
      moveSpeed: 1.1,
      attackSpeed: 1.0,
      dodgeRate: 0.18,
      mana: 120,
      startingWeapon: "book",
      passive: "Soigne 2 PV toutes les 10s",
    ),
    PlayerClass.tank: PlayerClassDetails(
      name: "Tank",
      description: "Très résistant, lent.",
      maxHealth: 180,
      attack: 8,
      defense: 20,
      fightStyle: FightStyleClass.melee,
      moveSpeed: 0.8,
      attackSpeed: 0.8,
      dodgeRate: 0.05,
      mana: 20,
      startingWeapon: "shield",
      passive: "Réduit les dégâts subis de 20%",
    ),
    PlayerClass.gunner: PlayerClassDetails(
      name: "Gunner",
      description: "Armes à feu multiples.",
      maxHealth: 100,
      attack: 14,
      defense: 7,
      fightStyle: FightStyleClass.ranged,
      moveSpeed: 1.2,
      attackSpeed: 1.6,
      dodgeRate: 0.13,
      mana: 35,
      startingWeapon: "gun",
      passive: "+1 projectile par arme équipée",
    ),
    PlayerClass.necromancer: PlayerClassDetails(
      name: "Nécromancien",
      description: "Invoque des sbires.",
      maxHealth: 80,
      attack: 16,
      defense: 5,
      fightStyle: FightStyleClass.magic,
      moveSpeed: 1.0,
      attackSpeed: 1.2,
      dodgeRate: 0.15,
      mana: 110,
      startingWeapon: "orb",
      passive: "Invoque un sbire toutes les 15s",
    ),
    PlayerClass.paladin: PlayerClassDetails(
      name: "Paladin",
      description: "Guerrier sacré.",
      maxHealth: 130,
      attack: 13,
      defense: 12,
      fightStyle: FightStyleClass.melee,
      moveSpeed: 1.0,
      attackSpeed: 1.1,
      dodgeRate: 0.10,
      mana: 80,
      startingWeapon: "hammer",
      passive: "Bouclier sacré toutes les 30s",
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
  int currentExp;
  int level;
  List<String> weapons;

  PlayerStats({
    required this.maxHealth,
    required this.currentHealth,
    required this.damage,
    required this.defense,
    required this.moveSpeed,
    required this.attackSpeed,
    required this.critChance,
    required this.range,
    required this.currentExp,
    this.level = 1,
    List<String>? weapons,
  }) : weapons = weapons ?? [];

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
      currentExp: 0,
      level: 1,
    );
  }
}
