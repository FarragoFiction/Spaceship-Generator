
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

  static Map<int, String> rooms = {
     0: "plating", //ideally never used //haha nevermind it has a use

     1: "life support",
     2: "robot arm",
     3: "munitions storage",
     4: "weapons array",
     5: "repair parts locker",
     6: "commons area",
     7: "fuel storage",
     8: "thrusters",
     9: "shields",
    10: "warp key",
    11: "crew quarters",
    12: "science equipment",
  };

  int type;
  Room(int type) {
    this.type = type;
  }

  String toString() {
    return rooms[type];
  }

}
