import 'dart:math';
import 'Room.dart';

final String CATCHALL = " Nobody knows why this ship was built. Who did this, actually?";

//todo change naming system
final List<String> DEFAULT_FIRST_NAMES = [
  "Husk",
  "Einstein",
  "Mercury",
  "Venus",
  "Earth",
  "Mars",
  "Jupiter",
  "Saturn",
  "Uranus",
  "Neptune",
  "Pluto",
  "Needle",
  "Starshine",
  "Cowboy",
  "Thimble",
];

class Starship {

List<Room> rooms;
String name;
int id;
String description;

  Starship(int seed){
    Random rand = new Random(seed);
    id = seed;

    //determine size
    bool isValid = false;
    int size;
    while (!isValid) {
      size = rand.nextInt(50) + 4;
      if(size >= 4) {
        isValid = true;
        rooms = new List<Room>(size);
      }
    }

    //assign rooms
    for(int i = 0; i < rooms.length; i++) {
      rooms[i] = new Room(rand.nextInt(Room.rooms.length));
    }
    sortRooms();

    //assign description and name
    setDescriptionAndName(rand);
  }

  int getSize() {
    return rooms.length;
  }

  //check Room.dart for the room type IDs
  int getNumOfRoomType(int type) {
    int ret = 0;
    for(int i=0; i < rooms.length; i++) {
      if(rooms[i].type == type)
        ret++;
    }
    return ret;
  }

  int getUniqueRoomTypes() {
    int ret = 0;
    for(int i=0; i < Room.rooms.length; i++) {
      if (getNumOfRoomType(i) > 0)
        ret++;
    }
    return ret;
  }

  void sortRooms() {
    rooms.sort((a,b) => a.type.compareTo(b.type));
  }

  int getNumOfMaxRoom() {
    int ret = 0;
    for(int i=0; i < Room.rooms.length; i++) {
      if (getNumOfRoomType(i) > ret)
        ret = getNumOfRoomType(i);
    }
    return ret;
  }

  String getName() { //todo implement names
    return name;
  }


  String crewSize() {
    if (getNumOfRoomType(Room.CREW_QUARTERS) == 0)
      return "nonexistant";
    else if (getNumOfRoomType(Room.CREW_QUARTERS) <= 3)
      return "small";
    else if (getNumOfRoomType(Room.CREW_QUARTERS) <= 6)
      return "large";
    else if (getNumOfRoomType(Room.CREW_QUARTERS) <= 10)
      return "massive";
    else if (getNumOfRoomType(Room.CREW_QUARTERS) > 10)
      return "unrealistic";
    return "unknown";
  }




  //this is probably VERY bad practice?
  //but it works.
  void setDescriptionAndName(Random rand) {
    int cutoff = 3; //imma maybe change this later?
    String description = "";
    List<String> firstNames = DEFAULT_FIRST_NAMES;
    List<String> secondNames = [""]; //Want having NO second name to be a possibility.



    if(getNumOfRoomType(Room.CREW_QUARTERS) > 0 && getNumOfRoomType(Room.LIFE_SUPPORT) > 0) {
      String sizeAdj = crewSize();
      description += " It has a $sizeAdj sized crew.";
    } else if(getNumOfRoomType(Room.CREW_QUARTERS) <= 0 && getNumOfRoomType(Room.LIFE_SUPPORT) > 0) {
      description += " It has a pilot and no other crew.";
    } else if(getNumOfRoomType(Room.CREW_QUARTERS) > 0 && getNumOfRoomType(Room.LIFE_SUPPORT) <= 0) {
      String sizeAdj = crewSize();
      description += " It has a $sizeAdj group of people frozen in cryostasis.";
    } else {
      description += " It is a drone.";

      secondNames.add(" Drone");
    }



    if (getNumOfRoomType(Room.THRUSTERS) <= 0) {
      description += " It is a stationary satellite.";

      secondNames.add(" Station");
      secondNames.add(" Space Station");
    } else {
      secondNames.add(" Ship");
      secondNames.add(" Starship");
    }



    if(getNumOfRoomType(Room.LIFE_SUPPORT) > cutoff) {
      if(getNumOfRoomType(Room.CREW_QUARTERS) > cutoff && getNumOfRoomType(Room.THRUSTERS) > 0) {
        description += " It is a colonizing ship.";

        secondNames.add(" Mayflower");
      }

      description += " It contains an artificial ecosystem, with many plants and animals.";

      secondNames.add(" Biospace"); //todo this is a shitty name. please please come up with a better one.
    }



    if(getNumOfRoomType(Room.REPAIR_PARTS) > cutoff && getNumOfRoomType(Room.ROBOT_ARM) > cutoff && getSize() > 10) {
      description += " It has the capacity to build other spacecraft.";
      secondNames.add(" Shipwright");
      if(getNumOfRoomType(Room.CREW_QUARTERS) == 0) {
        description += " It has an experimental onboard AI which can design and build new spacecraft.";

      }
    }



    if(getNumOfRoomType(Room.THRUSTERS) > cutoff && getNumOfRoomType(Room.FUEL_STORAGE) == 0) {
      description += ' It uses massive solar sails for propulsion.';
    } else if(getNumOfRoomType(Room.THRUSTERS) > 0 && getNumOfRoomType(Room.FUEL_STORAGE) == 0) {
      description += " It uses advanced thrusters which require very little fuel.";
    }



    if(getNumOfRoomType(Room.FUEL_STORAGE) > cutoff && getNumOfRoomType(Room.THRUSTERS)/getNumOfRoomType(Room.FUEL_STORAGE) < cutoff) {
      if (getNumOfRoomType(Room.THRUSTERS) > 0) {
        description += " It is designed to transport fuel between distant colonies.";
        secondNames.add(" Freighter");
    }
      else
        description += " It serves as a refueling station.";
    }



    if(getNumOfRoomType(Room.MUNITIONS_STORAGE) > 0) {
      if(getNumOfRoomType(Room.WEAPONS_ARRAY) > cutoff) {
        description += " It is incredibly well armed.";
        secondNames.add(" Destroyer"); //space stations can be destroyers, ala Death Star
      } else if(getNumOfRoomType(Room.WEAPONS_ARRAY) > 0) {
        description += " It has light firepower for combatting pirates.";
      } else if(getNumOfRoomType(Room.MUNITIONS_STORAGE) > cutoff) {
        description += " It is used to store wartime supplies.";
        secondNames.add(" Cache");
      } else {
        description += " It has a good security system.";
      }
    } else if(getNumOfRoomType(Room.WEAPONS_ARRAY) > 0 ) {
      description += " It appears to have weapons, but they are fake and only meant to intimidate potential attackers.";
    }



    if(getNumOfRoomType(Room.SHIELDS) > cutoff) {
      description += " It has strong protection against heavily armed ships.";
    } if(getNumOfRoomType(Room.SHIELDS) > 0) {
      if(getNumOfRoomType(Room.WEAPONS_ARRAY) > 0 && getNumOfRoomType(Room.MUNITIONS_STORAGE) > 0) {
        description += " It was designed for incredibly dangerous star systems.";
      }
    }



    if(getNumOfRoomType(Room.SCIENCE_EQUIPMENT) > cutoff) {
      if(getNumOfRoomType(Room.THRUSTERS) == 0) {
        description += " It is an orbital research institute.";
        secondNames.add(" Laboratories");
      } else {
        secondNames.add(" Research Vessel");
      }
      if(getNumOfRoomType(Room.LIFE_SUPPORT) > cutoff) {
        description += " It is used for research on life in the rigors of space.";
      }
    }



    if(getNumOfRoomType(Room.STARGATE_KEY) > 0) {
      if(getNumOfRoomType(Room.THRUSTERS) > 0) {
        description += " It can travel between systems.";
      } else if(getNumOfRoomType(Room.STARGATE_KEY) > cutoff) {
        description += " It is marked as a warp location for interstellar starships.";
        secondNames.add(" Anchor");
      }
    }



    if(getNumOfRoomType(Room.COMMONS_AREA) > cutoff) {
      if(getNumOfRoomType(Room.CREW_QUARTERS) > 0) {
        description += " It is very luxorious.";
        secondNames.add(" Yacht");
      }else {
        description += " It is filled with seemingly empty corridors.";
      }
    }


    //put the placeholder here if the ship is somehow descriptionless
    if(description.length == 0) {
      description += CATCHALL;
    }

    this.description = description;

    this.name =
        "${firstNames[rand.nextInt(firstNames.length)]}"
        "${secondNames[rand.nextInt(secondNames.length)]}";

  }

  String getDescription() {
    //have a bunch of strings that can get added together based on stats.
    //default to "Nobody Knows" explanation
    String ret = "";

    //comment about ship size
    if(getSize() <= 15) {
      ret += " It is a small spacecraft.";
    } else if(getSize() <= 35) {
      ret += " It is a mid-sized spacecraft.";
    } else {
      ret += " It is a large spacecraft.";
    }


    ret += description;

    return ret;
  }

  int getId() {
    return id;
  }


}