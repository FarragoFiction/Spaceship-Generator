/*NOTES ABOUT CREW STATS.\
  |    consistent       |             |    experimental     |
  | Aspect | Wigglersim | SPACE SKILL | Wigglersim | Aspect |
  | Doom   | Calm       | Medicine    | Energetic  | Life   |
  | Heart  | Internal   | Research    | External   | Mind   |
  | Void   | Accepting  | Engineering | Curious    | Light  |
  | Blood  | Loyal      | Diplomacy   |FreeSpirited| Breath |
  | Space  | Patient    | Combat      | Impatient  | Time   |
  | Rage   | Realistic  | Sanity      | Idealistic | Hope   |

  so how i see it, a "stat" class can be a value between -113 and 113.
  i'll say that a check can be between anywere between 1 and 150, though usually they wouldn't go that high or that low

*/

import 'dart:math';

class CrewStat {
  int value;
  String name;

  bool checkRoll(int check) {
    int rolledValue = getRollFromValue(value);
    if(check <= rolledValue)
      return true;
    else
      return false;
  }


  static int getRollFromValue(int value) {
    Random rand = new Random();
    //always roll 0 if they have no skill there.
    if(value == 0) {
      print("value of $value has rolled 0 and had no skill");
      return 0;
    }
    int rolledValue;

    int spread = (113 + value) ~/ 10;

    if(spread > 0) {
      rolledValue = value.abs() + rand.nextInt(spread) - spread ~/ 2;
    }
    if(value < 0) {
      print("value of $value has rolled $rolledValue and tried to be CONSISTENT");
    } else {
      print("value of $value has rolled $rolledValue and tried to be EXPERIMENTAL");
    }

  }

  static void testStatRolls() {
    for(int i = -113; i < 1; i++) {
      for(int j = 0; j < 50; j++) {
        getRollFromValue(i);
      }
      for(int j = 0; j < 50; j++) {
        getRollFromValue(i.abs());
      }
    }
  }
}