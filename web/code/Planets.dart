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
}