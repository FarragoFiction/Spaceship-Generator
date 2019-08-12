import 'dart:core';
import 'dart:async';
import 'dart:math';
import 'Room.dart';
import 'Starship.dart';
/*
planets are gonna be pretty simple.
  -distance from sun
  -size
  -composition
    -rockiness
    -water
    -atmosphere

  *conditions for life:
    -water/atmosphere ratios are close to 1:1, with neither being at 0
    -middle distance from sun
    -average size
    -maybe include some check involving the sun's stats? i havent worked those out yet though

  *add descriptions for what lifeforms are like probably

 */
//todo make Starship and Planet extend from the same generic class
class Planet extends Starship{
  int sunDistance; //sun distance is determined by solar system generator, since you can't have 2 planets in the same spot.

  //todo remember to allow for hardcoded planets, not just random ones!
  Planet(int sunDistance, int seed):super(seed) {
    this.sunDistance = sunDistance;
  }

  static Future<Planet> getRandomPlanet(int seed) async {
    Planet planet = new Planet(0, seed);

    Random rand = new Random(seed);

    //determine size
    bool isValid = false;
    int size;
    while (!isValid) {
      size = rand.nextInt(10) + 2;
      if (size >= 2) {
        isValid = true;
        planet.rooms = new List<PlanetTrait>(size);
      }
    }

    //assign rooms
    for (int i = 0; i < planet.rooms.length; i++) {
      planet.rooms[i] = new PlanetTrait(rand.nextInt(PlanetTrait.PLANET_TRAITS.length));
    }
    planet.sortRooms();

    await planet.setDescriptionAndName(rand);

    return planet;
  }

  @override
  void setDescriptionAndName(Random rand) async {
    int cutoff = 2; //imma maybe change this later?
    String description = "";
    List<String> firstNames = DEFAULT_FIRST_NAMES;
    List<String> secondNames = [
      ""
    ]; //Want having NO second name to be a possibility.
    //second names should be capitalized and have a space before them.

    //todo planet description bits go here, as do DETERMINING LIFE

    //put the placeholder here if the planet is somehow descriptionless
    if (description.length == 0) {
      description += CATCHALL;
    }

    this.description = description;

    /*this.defaultName =
        "${firstNames[rand.nextInt(firstNames.length)]}"
        "${secondNames[rand.nextInt(secondNames.length)]}";
    */ //todo fix this
    this.defaultName = await nameFromTextEngineTest(firstNames, secondNames);
    print(defaultName);
  }

  @override
  String getDescription() {
    //have a bunch of strings that can get added together based on stats.
    //default to "Nobody Knows" explanation
    String ret = "";

    //todo adjust for typical planet sizes
    if (getSize() <= 15) {
      ret += " It is a small planet.";
    } else if (getSize() <= 35) {
      ret += " It is a mid-sized planet.";
    } else {
      ret += " It is a large planet.";
    }

    ret += description;

    return ret;
  }

  
}