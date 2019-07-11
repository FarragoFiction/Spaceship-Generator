import 'dart:core';
import 'dart:async';
import 'dart:html';
//import 'dart:math';

import 'Starship.dart';
import 'Room.dart';

import 'package:DollLibCorrect/DollRenderer.dart';
import 'package:TextEngine/TextEngine.dart';
import 'package:CommonLib/Random.dart';



class Crewmember {
  Doll doll;
  int id;
  CanvasElement dollCanvas;
  //todo rip these out and plant in real stats.
  static final int OTHER_JOB = -1;
  static final int ENGINEERING = 0;
  static final int TACTICAL = 1;
  static final int SCIENCE = 2;

  static final int MAX = 10;

  List<int> stats = new List<int>(3);
  
  Crewmember(int id, Doll doll) {
    this.id = id;
    this.doll = doll;
    assignStats(id);
    buildCanvas();
  }

  void assignStats(int id) {
    Random random = new Random(id);
    for(int i = 0; i < stats.length; i++) {
      stats[i] = random.nextInt(MAX);
    }
  }

  Future<void> buildCanvas() async{
    dollCanvas = await doll.getNewCanvas();
  }
  
  Future<DivElement> getDivOutput() async {
    DivElement ret = new DivElement();
    ret.append(await doll.getNewCanvas());
    DivElement text = new DivElement();

    //NAME EXCEPTIONS, BLAAH
    //dollsets 37(smol human) and 28(fek) should use human names.
    String name;
    if(doll.renderingType == 37 || doll.renderingType == 28) {
      TextEngine textEngine = new TextEngine(id);
      TextStory textStory = new TextStory();
      await textEngine.loadList("names");
      name = textEngine.phrase("kidname_all", story: textStory);
    } else if(doll.renderingType == 38){ //smol trols use troll names
      TextEngine textEngine = new TextEngine(id);
      TextStory textStory = new TextStory();
      await textEngine.loadList("names");
      name = textEngine.phrase("trollname_all", story: textStory);
    } else if(doll.renderingType == 35) { //fruits have it at dollName
      name = await doll.dollName;
    } else if(doll.renderingType == 26) {
      TextEngine textEngine = new TextEngine(id);
      TextStory textStory = new TextStory();
      await textEngine.loadList("names");
      name = textEngine.phrase("docname_temp", story: textStory);
    } else {
      name = await doll.getNameFromEngine();
    }
    text.appendHtml("<h3>${name}</h3>");

    ret.append(text);

    ret.appendText(stats.toString());
    ret.appendText(await getJob());
    return ret;
  }
  
  static Future<Crewmember> randomCrewmember(int id, int dolltype) async {
    Random rand = new Random(id);
    await Doll.loadFileData();
    Doll doll = Doll.randomDollOfType(dolltype);
    print(doll.rand.toString());
    print(rand.toString());
    doll.rand = rand;
    doll.randomize();
    return new Crewmember(id, doll);
  }

  Future<String> getJob() async{
    List<int> possibleJobs = [OTHER_JOB, OTHER_JOB, OTHER_JOB];
    for (int i = 0; i < stats.length; i++) {
      for (int j = 0; j < stats[i]; j++) {
        possibleJobs.add(i);
      }
    }
    print("possibleJobs: ${possibleJobs.length}");
    Random rand = new Random(id);
    int jobType = possibleJobs[rand.nextInt(possibleJobs.length)];

    String ret = "UNIDENTIFIED PASSENGER";
    TextEngine textEngine = new TextEngine(id);
    TextStory textStory = new TextStory();
    await textEngine.loadList("Spaceship");
    if(jobType == OTHER_JOB) {
      ret = textEngine.phrase("crewmemberJobsOther", story: textStory);
    } else if(jobType == ENGINEERING) {
      ret = textEngine.phrase("crewmemberJobsEngineering", story: textStory);
    } else if(jobType == TACTICAL) {
      ret = textEngine.phrase("crewmemberJobsTactical", story: textStory);
    } else if(jobType == SCIENCE) {
      ret = textEngine.phrase("crewmemberJobsScience", story: textStory);
    }
    return ret;
  }
}

class Crew {
  List<Crewmember> crewList;
  
  Crew(List<Crewmember> crewList) {
    this.crewList = crewList;
  }

  Future<DivElement> getAllMemberDivs() async{
    DivElement ret = new DivElement();
    for(int i = 0; i < crewList.length; i++) {
      ret.append(await crewList[i].getDivOutput());
    }
    return ret;
  }


  
  static Future<Crew> makeRandomCrewForStarship(Starship starship) async{
    print("my id is ${starship.id}");
    Random rand = new Random(starship.id);
    int numCrew = starship.getNumOfRoomType(Room.CREW_QUARTERS) * (1 + rand.nextInt(5));

    //am i predominantly one species, or a mixed bag?
    bool isMonoSpecies = rand.nextBool();

    int mainSpeciesId;
    if(isMonoSpecies) {
      mainSpeciesId = Doll.allDollTypes[rand.nextInt(Doll.allDollTypes.length)];
    }

    //build the crew
    List<Crewmember> crewList = [];
    for(int i = 0; i < numCrew; i++) {
      int memberId = rand.nextInt(2147483647);
      Crewmember member;

      if(isMonoSpecies && rand.nextDouble() <= 0.9) {
        member = await Crewmember.randomCrewmember(memberId, mainSpeciesId);
      } else {
        int memberSpeciesId = Doll.allDollTypes[rand.nextInt(Doll.allDollTypes.length)];
        member = await Crewmember.randomCrewmember(memberId, memberSpeciesId);
      }
      crewList.add(member);
    }
    return new Crew(crewList);
  }
  
}

