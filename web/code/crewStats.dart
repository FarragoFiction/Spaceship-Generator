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

class crewStat {
  int value;
  String name;

  bool checkRoll(int check) {
    //dont use seeded random probably unless its decided later to rework where the random comes from
    Random rand = new Random();
    if(value >= 0) {
      int rolledValue = value + rand.nextInt(value ~/ 11.3);
      if (rolledValue >= check)
        return true;
      else
        return false;
    } else {
      int rolledValue = (value ~/ 11.3) + rand.nextInt(value);
      if (rolledValue >= check)
        return true;
      else
        return false;
    }

  }
}
