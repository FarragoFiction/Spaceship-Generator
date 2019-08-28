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
  i'll say that a  check can be between anywere between 1 and 150, though usually they wouldn't go that high or that low

*/

import 'dart:math';

class CrewStat {
  int value;
  String name;

  CrewStat(String name) {
    value = 0;
    this.name = name;
  }
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

    int spread = (113 + value) ~/ 5;

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

/*
sample quest: examine mysterious organic object
(failing each check in this example is assumed to only cause a minor setback, possibly injuring crew. it features a small check of each type but focuses on sanity)
-examine and match object's movement patterns (Engineering)
-communications interference occurs. keep the crew calm (sanity)
-harvest a sample of it's trunk (combat, very small)
-examine sample's properties(Research)
-ship systems go down, evacuate to safe location (Sanity)
-treat infected crewmember's wounds (Medicine)
-inform next of kin (diplomacy)
-console infected crewmember (Sanity. This is a higher difficulty check and it is raised slightly with each failed check earlier in the mission)
    -that last sanity check determines whether or not the crewmember lives and becomes Corrupted, or Dies.

this particular quest wouldn't be a common one. it would be fairly rare and would have different
 */