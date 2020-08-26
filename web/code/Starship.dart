import 'dart:math';
import 'dart:core';
import 'Room.dart';
import 'dart:async';
import 'Crew.dart';
import 'package:TextEngine/TextEngine.dart';
import 'package:CommonLib/Collection.dart';

final int MAX_SEED = 2147483647;

final String CATCHALL =
    " Nobody knows why this ship was built. Who did this, actually?";

//todo change naming system
final List<String> DEFAULT_FIRST_NAMES = [
  //planets
  "Mercury",
  "Venus",
  "Earth",
  "Mars",
  "Jupiter",
  "Saturn",
  "Uranus",
  "Neptune",
  "Pluto",
  //cities
  "Tokyo",
  "Memphis",
  "Atlanta",
  "Paris",
  "London",
  "Boston",
  "Dallas",
  "Fort Worth",
  "Nashville",

  //people
  "Einstein",
  "Lovelace",
  "Aldrin", //apollo 11
  "Armstrong",
  "Collins",
  "Galileo",

  //animals
  "Hedgehog",
  "Wolf",
  "Fox",
  "Beagle",
  "Cuttlefish",
  "Horse",
  "Bigfoot",
  "Bee",

  //miscellaneous
  "Needle",
  "Starshine",
  "Cowboy",
  "Thimble",
  "Husk",
];

final List<String> DEFAULT_DASHBOARD_LABELS = [
  "appeal",
  "belief",
  "charge",
  "coherence",
  "coins",
  "disaster lvl",
  "dreams",
  "efficiency",
  "energy",
  "errors",
  "holiday spirit",
  "love",
  "mass",
  "numbers",
  "pain",
  "points",
  "potential",
  "power",
  "propability",
  "rpm",
  "strength",
  "tears",
];

class Starship {
  List<Room> rooms;
  String defaultName;
  String trueName;
  int id;
  String description;
  List<String> dashboardLabels;
  Crew crew;

  //if you add new ship capabilities update getTraitText()
  bool manned = false;
  bool cryo = false;
  bool mobile = false;
  bool colonizing = false;
  bool hasPlants = false;
  bool construction = false;
  bool weaponized = false;
  bool shielded = false;
  bool scientific = false;
  bool warpCapable = false;
  bool warpAnchor = false;
  bool refueling = false;

  Starship(int seed) {
    id = seed;
    trueName = "";
    rooms = new List<Room>();
    dashboardLabels = new List<String>();
    description = "";
    defaultName = "Husk";
  }

  static Future<Starship> getRandomStarship(int seed) async {
    Starship starship = new Starship(seed);

    Random rand = new Random(seed);

    //determine size
    bool isValid = false;
    int size;
    while (!isValid) {
      size = rand.nextInt(50) + 4;
      if (size >= 4) {
        isValid = true;
        starship.rooms = new List<Room>(size);
      }
    }

    //assign rooms
    for (int i = 0; i < starship.rooms.length; i++) {
      starship.rooms[i] = new Room(rand.nextInt(Room.ROOMS.length));
    }
    starship.sortRooms();

    starship.dashboardLabels = new List<String>();
    starship.dashboardLabels.addAll(DEFAULT_DASHBOARD_LABELS);

    //assign description and name
    await starship.setDescriptionAndName(rand);

    return starship;
  }

  int getSize() {
    return rooms.length;
  }

  //check Room.dart for the room type IDs
  int getNumOfRoomType(int type) {
    int ret = 0;
    for (int i = 0; i < rooms.length; i++) {
      if (rooms[i].type == type) ret++;
    }
    return ret;
  }

  int getUniqueRoomTypes() {
    int ret = 0;
    for (int i = 0; i < Room.ROOMS.length; i++) {
      if (getNumOfRoomType(i) > 0) ret++;
    }
    return ret;
  }

  void sortRooms() {
    rooms.sort((a, b) => a.type.compareTo(b.type));
  }

  int getNumOfMaxRoom() {
    int ret = 0;
    for (int i = 0; i < Room.ROOMS.length; i++) {
      if (getNumOfRoomType(i) > ret) ret = getNumOfRoomType(i);
    }
    return ret;
  }

  String getName() {
    if (trueName == "") {
      return defaultName;
    } else {
      return trueName;
    }
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
    else if (getNumOfRoomType(Room.CREW_QUARTERS) > 10) return "unrealistic";
    return "unknown";
  }

  //this is probably VERY bad practice?
  //but it works.
  void setDescriptionAndName(Random rand) async {
    int cutoff = 3; //imma maybe change this later?
    String description = "";
    List<String> firstNames = DEFAULT_FIRST_NAMES;
    List<String> secondNames = [
      ""
    ]; //Want having NO second name to be a possibility.
    //second names should be capitalized and have a space before them.

    /*
    if(getSize() > 40) {
      secondNames.add(" Overcoat"); //was originally a homestuck ref but it's innaccurate
    }*/

    if (getNumOfRoomType(Room.CREW_QUARTERS) > 0 &&
        getNumOfRoomType(Room.LIFE_SUPPORT) > 0) {
      String sizeAdj = crewSize();
      description += " It has a $sizeAdj sized crew.";
      dashboardLabels.add("crew");
      manned = true;
    } else if (getNumOfRoomType(Room.CREW_QUARTERS) <= 0 &&
        getNumOfRoomType(Room.LIFE_SUPPORT) > 0) {
      description += " It has a pilot and no other crew.";
      manned = true;
    } else if (getNumOfRoomType(Room.CREW_QUARTERS) > 0 &&
        getNumOfRoomType(Room.LIFE_SUPPORT) <= 0) {
      String sizeAdj = crewSize();
      description += " It has a $sizeAdj group of people frozen in cryostasis.";
      dashboardLabels.add("lives");
      manned = false;
      cryo = true;
    } else {
      description += " It is a drone.";
      secondNames.add(" Drone");
      manned = false;
    }

    if (getNumOfRoomType(Room.HULL) > 0) {
      dashboardLabels.add("hull integrity");
    }

    if (getNumOfRoomType(Room.THRUSTERS) <= 0) {
      description += " It is a stationary satellite.";
      secondNames.add(" Station");
      secondNames.add(" Space Station");
      mobile = false;
    } else {
      secondNames.add(" Ship");
      secondNames.add(" Starship");

      dashboardLabels.add("velocity");
      mobile = true;
    }

    if (getNumOfRoomType(Room.LIFE_SUPPORT) > 0) {
      dashboardLabels.add("oxygen");
      dashboardLabels.add("air cyclers");
      dashboardLabels.add("water cyclers");
    }

    if (getNumOfRoomType(Room.LIFE_SUPPORT) > cutoff) {
      if (getNumOfRoomType(Room.CREW_QUARTERS) > cutoff &&
          getNumOfRoomType(Room.THRUSTERS) > 0) {
        description += " It is a colonizing ship.";

        dashboardLabels.add("days left of voyage");

        secondNames.add(" Mayflower");
        colonizing = true;
      }

      description +=
          " It contains an artificial ecosystem, with many plants.";

      secondNames.add(" Arboreum");

      dashboardLabels.add("specimens");

      hasPlants = true;
    }

    if (getNumOfRoomType(Room.REPAIR_PARTS) > 0) {
      dashboardLabels.add("scrap metal");
    }

    if (getNumOfRoomType(Room.ROBOT_ARM) > 0) {
      dashboardLabels.add("armwrestling wins");
    }

    if (getNumOfRoomType(Room.REPAIR_PARTS) > cutoff &&
        getNumOfRoomType(Room.ROBOT_ARM) > cutoff &&
        getSize() > 10) {
      description += " It has the capacity to build other spacecraft.";
      secondNames.add(" Shipwright");
      if (getNumOfRoomType(Room.CREW_QUARTERS) == 0) {
        description +=
            " It has an experimental onboard AI which can design and build new spacecraft.";
        dashboardLabels.add("ships built");
      }
      construction = true;
    }

    if (getNumOfRoomType(Room.THRUSTERS) > cutoff &&
        getNumOfRoomType(Room.FUEL_STORAGE) == 0) {
      description += ' It uses massive solar sails for propulsion.';
    } else if (getNumOfRoomType(Room.THRUSTERS) > 0 &&
        getNumOfRoomType(Room.FUEL_STORAGE) == 0) {
      description +=
          " It uses advanced thrusters which require very little fuel.";
    }

    if (getNumOfRoomType(Room.FUEL_STORAGE) > cutoff &&
        getNumOfRoomType(Room.THRUSTERS) / getNumOfRoomType(Room.FUEL_STORAGE) <
            cutoff) {
      dashboardLabels.add("fuel");
      if (getNumOfRoomType(Room.THRUSTERS) > 0) {
        description +=
        " It is designed to transport fuel between distant colonies.";
        secondNames.add(" Freighter");
      } else {
        description += " It serves as a refueling station.";
        refueling = true;
      }
    }

    if (getNumOfRoomType(Room.MUNITIONS_STORAGE) > 0) {
      dashboardLabels.add("torpedoes");
      dashboardLabels.add("bullets");
      if (getNumOfRoomType(Room.WEAPONS_ARRAY) > cutoff) {
        description += " It is incredibly well armed.";
        secondNames.add(
            " Destroyer"); //space stations can be destroyers, ala Death Star
        weaponized = true;
      } else if (getNumOfRoomType(Room.WEAPONS_ARRAY) > 0) {
        description += " It has light firepower for combatting pirates.";
        weaponized = true;
      } else if (getNumOfRoomType(Room.MUNITIONS_STORAGE) > cutoff) {
        description += " It is used to store wartime supplies.";
        secondNames.add(" Cache");
        if (getNumOfRoomType(Room.CREW_QUARTERS) > 0) {
          dashboardLabels.add("marines");
        }
      } else {
        description += " It has a good security system.";
      }
    } else if (getNumOfRoomType(Room.WEAPONS_ARRAY) > 0) {
      description +=
          " It appears to have weapons, but they are fake and only meant to intimidate potential attackers.";
    }

    if (getNumOfRoomType(Room.WEAPONS_ARRAY) > 0) dashboardLabels.add("guns");

    if (getNumOfRoomType(Room.SHIELDS) > cutoff) {
      description += " It has strong protection against heavily armed ships.";
    }
    if (getNumOfRoomType(Room.SHIELDS) > 0) {
      dashboardLabels.add("shield strength");
      if (getNumOfRoomType(Room.WEAPONS_ARRAY) > 0 &&
          getNumOfRoomType(Room.MUNITIONS_STORAGE) > 0) {
        description +=
            " It was designed for incredibly dangerous star systems.";
      }
      shielded = true;
    }

    if (getNumOfRoomType(Room.SCIENCE_EQUIPMENT) > cutoff) {
      dashboardLabels.add("days without accident");
      dashboardLabels.add("blasphemies");
      scientific = true;
      if (getNumOfRoomType(Room.THRUSTERS) == 0) {
        description += " It is an orbital research institute.";
        secondNames.add(" Laboratories");
      } else {
        secondNames.add(" Research Vessel");
      }
      if (getNumOfRoomType(Room.LIFE_SUPPORT) > cutoff) {
        description +=
            " It is used for research on life in the rigors of space.";
      }
    }

    if (getNumOfRoomType(Room.STARGATE_KEY) > 0) {
      dashboardLabels.add("spatial distortion");
      if (getNumOfRoomType(Room.THRUSTERS) > 0) {
        description += " It can travel between systems.";
        dashboardLabels.add("jumps remaining");
        warpCapable = true;
      } else if (getNumOfRoomType(Room.STARGATE_KEY) > cutoff) {
        description +=
            " It is marked as a warp location for interstellar starships.";
        secondNames.add(" Anchor");
        warpAnchor = true;

      }
    }

    if (getNumOfRoomType(Room.COMMONS_AREA) > cutoff) {
      if (getNumOfRoomType(Room.CREW_QUARTERS) > 0) {
        description += " It is very luxurious.";
        secondNames.add(" Yacht");
        dashboardLabels.add("joy");
        dashboardLabels.add("enthusiasm");
      } else {
        description += " It is filled with seemingly empty corridors.";
      }
    }

    //put the placeholder here if the ship is somehow descriptionless
    if (description.length == 0) {
      description += CATCHALL;
    }

    this.description = description;

    /*this.defaultName =
        "${firstNames[rand.nextInt(firstNames.length)]}"
        "${secondNames[rand.nextInt(secondNames.length)]}";
    */ //todo fix this
    this.defaultName = await nameFromTextEngineTest(firstNames, secondNames);
    //print(defaultName);
  }

  String getDescription() {
    //have a bunch of strings that can get added together based on stats.
    //default to "Nobody Knows" explanation
    String ret = "";

    //comment about ship size
    if (getSize() <= 15) {
      ret += " It is a small spacecraft.";
    } else if (getSize() <= 35) {
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

  List<int> getNumRooms() {
    List<int> ret = [];
    for (int i = 0; i < Room.ROOMS.length; i++) {
      ret.add(getNumOfRoomType(i));
    }
    return ret;
  }

  Future<Crew> getCrew() async {
    if(crew == null) {
      crew = await Crew.makeRandomCrewForStarship(this);
    }
    return crew;
  }

  //gonna make a test version, and ask JR how to improve it later

  /*
  this version is pretty simple.
  -string starts number of rooms at each index in order
  -each is seperated by a dash, which signifies the next one
  -in case i make future room additions the ship name is seperated from the numbers by two(2) dashes
  */
  static String getDatastring(List<int> numRooms, String name) {
    String ret = "";
    for (int i = 0; i < Room.ROOMS.length; i++) {
      ret = "$ret${numRooms[i]}-";
    }
    ret = "$ret-${name}";

    //gotta encode it so i can shove into URLs
    ret = Uri.encodeComponent(ret);

    return ret;
  }

  static Future<Starship> parseDataString(
      String betaDataString, int seed) async {
    String decodedString = Uri.decodeComponent(betaDataString);
    Starship starship = new Starship(seed);

    bool doubleDashes = false;
    //outer loop for each portion
    int roomId = 0;
    while (decodedString.codeUnitAt(0) != "-".codeUnitAt(0)) {
      String dataPiece = "";
      while (decodedString.codeUnitAt(0) != "-".codeUnitAt(0)) {
        dataPiece = "$dataPiece${decodedString.substring(0, 1)}";
        decodedString = decodedString.substring(1);
      }
      int numOfRooms = int.parse(dataPiece);
      for (int i = 0; i < numOfRooms; i++) {
        starship.rooms.add(new Room(roomId));
      }
      decodedString = decodedString.substring(1);
      roomId++;
    }

    starship.trueName = decodedString.substring(1);
    starship.dashboardLabels = new List<String>();
    starship.dashboardLabels.addAll(DEFAULT_DASHBOARD_LABELS);
    await starship.setDescriptionAndName(new Random(seed));
    return starship;
  }

  Future<String> nameFromTextEngineTest(
      List<String> newFirstNames, List<String> newSecondNames) async {
    TextEngine textEngine = new TextEngine(id);

    TextStory textStory = new TextStory();
    await textEngine.loadList("Spaceship");
    List<Word> secondWords = makeIntoWordlist(newSecondNames);
    //List<Word> firstWords = makeIntoWordlist(newFirstNames);
    textEngine.sourceWordLists["starshipSecondName"].addAll(secondWords);
    //textEngine.sourceWordLists["companionTraits"].addAll(firstWords);
    String phrase = textEngine.phrase("starshipFullName", story: textStory);
    return capitalize(phrase);
  }

  static List<Word> makeIntoWordlist(List<String> list) {
    List<Word> ret = new List<Word>();
    for (int i = 0; i < list.length; i++) {
      Word word = new Word(list[i]);
      ret.add(word);
      //print("adding ${list[i]}");
    }
    return ret;
  }

  //Returns The Input But With The First Letter Of Each Word Capitalized
  //Kanaya Style
  static String capitalize(String input) {
    String ret;

    ret = input.toLowerCase();
    ret = ret.replaceAllMapped(new RegExp(r"(\s)([a-z])"),
        (Match m) => "${m[1]}${m[2].toUpperCase()}");
    ret = ret.replaceAllMapped(new RegExp(r"(^[a-z])"),
        (Match m) => "${m[1].toUpperCase()}");
    return ret;
  }

  //displays a brief list of this ship's traits.
  //TODO if you add new ship capabilities update here
  List<String> getTraitText() {
    List<String> ret = new List();
    //time to feel guilty for a bunch of if statements
    if(manned) {
      ret.add("Crewed");
    }
    if(cryo) ret.add("Cryogenic Chambers");
    if(mobile) ret.add("Ship");
    if(colonizing) ret.add("Colony");
    if(hasPlants) ret.add("Vegetation");
    if(construction) ret.add("Construction Capabilities");
    if(weaponized) ret.add("Armed");
    if(shielded) ret.add("Shielded");
    if(scientific) ret.add("Research");
    if(warpCapable) ret.add("Warp Capable");
    if(warpAnchor) ret.add("Warp Anchor");
    if(refueling) ret.add("Refueling Station");

    return ret;
  }

}
