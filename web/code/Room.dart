class Room {
  static final int HULL = 0;
  static final int LIFE_SUPPORT = 1;
  static final int ROBOT_ARM = 2;
  static final int MUNITIONS_STORAGE = 3;
  static final int WEAPONS_ARRAY = 4;
  static final int REPAIR_PARTS = 5;
  static final int COMMONS_AREA = 6;
  static final int FUEL_STORAGE = 7;
  static final int THRUSTERS = 8;
  static final int SHIELDS = 9;
  static final int STARGATE_KEY = 10;
  static final int CREW_QUARTERS = 11;
  static final int SCIENCE_EQUIPMENT = 12;

  static final Map<int, String> ROOMS = {
     HULL: "plating", //ideally never used //haha nevermind it has a use

     LIFE_SUPPORT: "life support",
     ROBOT_ARM: "robot arm",
     MUNITIONS_STORAGE: "munitions storage",
     WEAPONS_ARRAY: "weapons array",
     REPAIR_PARTS: "repair parts locker",
     COMMONS_AREA: "commons area",
     FUEL_STORAGE: "fuel storage",
     THRUSTERS: "thrusters",
     SHIELDS: "shields",
     STARGATE_KEY: "warp key",
     CREW_QUARTERS: "crew quarters",
     SCIENCE_EQUIPMENT: "science equipment",
  };

  int type;
  Room(int type) {
    this.type = type;
  }

  @override
  String toString() {
    return ROOMS[type];
  }

}

class PlanetTrait extends Room {

  static final int ROCK = 0;
  static final int WATER = 1;
  static final int ATMOSPHERE = 2;

  static final Map<int, String> PLANET_TRAITS = {
    ROCK: "rock",
    WATER: "water",
    ATMOSPHERE: "atmosphere",
  };

  PlanetTrait(int type) : super(type);

}