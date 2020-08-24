import 'dart:core';
import 'dart:async';
import 'dart:math' as math;
import 'Starship.dart';

import 'package:TextEngine/TextEngine.dart';


final int MIN_STARS = 15;
final int MAX_STARS = 100;


/*star map is just a 3 dimensional SPACE CUBE. this is not how stars work but i dont care

*/
class Starmap {
  static final double DENSITY_FACTOR = 8.0;

  double mapDimension; //the dimensions of your space cube.
  List<Star> stars;



  Starmap(int numStars) {
    stars = new List();
    mapDimension = math.pow(numStars, 1.0/3) * DENSITY_FACTOR;
  }

  static Future<Starmap> makeRandomStarmap(int seed) async {
    math.Random rand = new math.Random(seed);
    int numStars = rand.nextInt(MAX_STARS - MIN_STARS) + MIN_STARS;
    Starmap ret = new Starmap(numStars);
    TextEngine textEngine = new TextEngine(seed);
    TextStory textStory = new TextStory();
    await textEngine.loadList("Star");

    for(int i = 0; i < numStars; i++) {
      double x = rand.nextDouble() * ret.mapDimension;
      double y = rand.nextDouble() * ret.mapDimension;
      double z = rand.nextDouble() * ret.mapDimension;
      String name = textEngine.phrase("planetNameFinal", story: textStory);
      Star newStar = new Star(x, y, z, name);
      ret.stars.add(newStar);
    }
    return ret;
  }
  @override
  toString() {
    String ret = "(STAR COORDINATES)   |dist(near, avg)\n";
    double closestFinalAvg = 0;
    double totalFinalAvg = 0;
    for(int i = 0; i < stars.length; i++) {
      ret += stars[i].toString();
      double closestDistance = mapDimension;
      double avgDistance = 0;
      for(int j = 0; j < stars.length; j++) {
        if(j != i) {
          double dist = stars[i].distanceTo(stars[j]);
          if(dist < closestDistance) closestDistance = dist;
          avgDistance += dist;
        }
      }
      avgDistance = avgDistance / (stars.length - 1);
      closestFinalAvg += closestDistance;
      totalFinalAvg += avgDistance;
      ret += "   |NEAREST: $closestDistance AVG: $avgDistance\n\n";
    }

    closestFinalAvg = closestFinalAvg / stars.length;
    totalFinalAvg = totalFinalAvg / stars.length;
    ret += "FINAL RESULTS:\n";
    ret += "average distance to nearest neighbor: $closestFinalAvg \n";
    ret += "average distance between all stars: $totalFinalAvg";

    return ret;
  }
}

class Star {
  List<double> coordinates;
  String name;

  Star(double x, double y, double z, String name) {
    coordinates = new List(3);
    coordinates[0] = x;
    coordinates[1] = y;
    coordinates[2] = z;
    this.name = name;
    print("$name at (${x.round()}, ${y.round()}, ${z.round()})");
  }

  double distanceTo(Star target) {
    double relX = (target.coordinates[0] - coordinates[0]).abs();
    double relY = (target.coordinates[1] - coordinates[1]).abs();
    double relZ = (target.coordinates[2] - coordinates[2]).abs();

    return math.sqrt(math.pow(relX, 2)+math.pow(relY, 2)+math.pow(relZ, 2));
  }

  @override
  toString() {
    return Starship.capitalize(name);
  }
}