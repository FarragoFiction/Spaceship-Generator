
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

The "difficulty" of a quest check should usually fall on the easier end, with a few checks per quest landing harder than the others.
Having the difficulty of future checks increase with failed checks should be a mechanic.
quest difficulty should range from "insanely easy" to "nearly impossible with today's techniques". (though that last one should be rare).
 */
import 'crewStats.dart';
import 'Crew.dart';

class QuestComponent {
  String initialText;
  String successText;
  String failureText;
  int statID;
  int targetRoll;

  QuestComponent(String initialText, String successText, String failureText, int statID, int targetRoll) {
    this.initialText = initialText;
    this.successText = successText;
    this.failureText = failureText;
    this.statID = statID;
    this.targetRoll = targetRoll;
  }

  bool runTest(Crewmember crewmember) {
    return crewmember.stats[statID].checkRoll(targetRoll);
  }


}
//todo figure out what to do for having different penalties for failed quests
class Quest {
  String initialText;
  String successText;
  String failureText;
  List<QuestComponent> components;

  int componentsCompleted = 0;

  Quest(String initialText, String successText, String failureText, List<QuestComponent> components) {
    this.initialText = initialText;
    this.successText = successText;
    this.failureText = failureText;
    this.components = components;
  }

  void failurePenalty() {
    if(componentsCompleted < components.length - 1) {
      //the default quest penalty is making the last quest component harder
      int penalizedValue = components[components.length - 1].targetRoll;
      //don't want it to go beyond 120. this is above what would normally be the maximum, but still allows wiggle room for the skilled and lucky.
      if(penalizedValue < CrewStat.MAX_CHECK_DIFFICULTY - 10) {
        penalizedValue += 10;
      } else {
        penalizedValue = CrewStat.MAX_CHECK_DIFFICULTY;
      }
      components[components.length - 1].targetRoll = penalizedValue;
    }
    //todo add penalty for failing the final component in the chain
  }

  QuestComponent getCurrentComponent() {
    return components[componentsCompleted];
  }



}