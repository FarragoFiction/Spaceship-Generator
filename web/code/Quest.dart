
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

/*todo list based on my old plans:
  -incorporate different end effects
  -incorporate optional success/failure text
  -text engine???
 */
import 'crewStats.dart';
import 'Crew.dart';
import 'dart:math';
import 'dart:async';

class QuestComponent {
  String initialText;
  int statID;
  int targetRoll;

  QuestComponent(String initialText, int statID, int targetRoll) {
    this.initialText = initialText;
    this.statID = statID;
    this.targetRoll = targetRoll;
  }

  /* gets a crewmember from the Crew given to solve with the following priority:
  1. a random crewmember with a job in the relevant stat.
  2. any random crewmember.
   */
  //todo is unseeded random ok here?
  Crewmember getProblemSolver(Crew crew) {
    Crewmember ret;
    List<Crewmember> candidates = [];
    Random rand = new Random();
    for(int i = 0; i < crew.crewList.length; i++) {
      Crewmember member = crew.crewList[i];
      if(member.jobType == statID) {
        candidates.add(member);
      }
    }
    if(candidates.length > 0) {
      ret = candidates[rand.nextInt(candidates.length)];
    } else {
      ret = crew.crewList[rand.nextInt(crew.crewList.length)];
    }
    return ret;
  }

  bool runTest(Crewmember crewmember) {
    return crewmember.stats[statID].checkRoll(targetRoll);
  }


}
//todo figure out what to do for having different penalties for failed quests
class Quest {
  String initialText;

  List<QuestComponent> components;

  int componentsCompleted = 0;

  Quest(String initialText, List<QuestComponent> components) {
    this.initialText = initialText;
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

  //todo make this do something other than print results.
  //runs the checks for the whole crew on the whole quest.
  Future<bool> attemptQuest(Crew crew) async {
    int numWins = 0;
    print(initialText);
    for (componentsCompleted = 0; componentsCompleted <
        components.length; componentsCompleted++) {
      QuestComponent currentComponent = components[componentsCompleted];
      Crewmember problemSolver = currentComponent.getProblemSolver(crew);
      print("${currentComponent.initialText} ${await problemSolver
          .getName()} the ${await problemSolver.getJob()} will attempt it.");

      //run the check
      bool success = currentComponent.runTest(problemSolver);
      if (success) {
        numWins++;
        print("Success! On to the next component.");
      } else {
        print("Failure. The next component will be more difficult."); //todo make variable
        failurePenalty();
      }
    }
    if(numWins >= components.length / 2) {
      print("QUEST VICTORY");
      return true;
    } else {
      print("QUEST DEFEAT");
      return false;
    }
  }

  //todo make sure final game does not reference this
  static Quest getDebugQuest() {
    //medicine check
    QuestComponent debugMedicine = new QuestComponent("This is a challenge for someone skilled in MEDICINE.", 0, 60);
    QuestComponent debugResearch = new QuestComponent("This is a challenge for someone skilled in RESEARCH.", 1, 60);
    QuestComponent debugEngineering = new QuestComponent("This is a challenge for someone skilled in ENGINEERING.", 2, 60);
    QuestComponent debugDiplomacy = new QuestComponent("This is a challenge for someone skilled in DIPLOMACY.", 3, 60);
    QuestComponent debugCombat = new QuestComponent("This is a challenge for someone skilled in COMBAT.", 4, 60);
    QuestComponent debugSanity = new QuestComponent("This is a challenge for someone skilled in STAYING SANE.", 5, 60);

    Quest ret = new Quest("Debug quest begin!", [debugMedicine, debugResearch, debugEngineering, debugDiplomacy, debugCombat, debugSanity]);
    return ret;
  }

}