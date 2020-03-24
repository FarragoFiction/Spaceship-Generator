import 'dart:core';
import 'dart:async';
import 'dart:html';
import 'crewStats.dart';
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
  String name;

  static final int MAX_CANVAS_HEIGHT = 300;
  static final int MAX_CANVAS_WIDTH = 400;

  static final int OTHER_JOB = -1;

  static final int MEDICINE = 0;
  static final int RESEARCH = 1;
  static final int ENGINEERING = 2;
  static final int DIPLOMACY = 3;
  static final int COMBAT = 4;
  static final int SANITY = 5;

  static final int MAX = 113;

  List<CrewStat> stats = new List<CrewStat>(6);
  
  Crewmember(int id, Doll doll) {
    this.id = id;
    this.doll = doll;
    assignStats(id);
    //buildName();
    //buildCanvas();

  }


  //todo this is shitty and awful and please rework this when you arent tired please
  void assignStats(int id) {
    Random random = new Random(id);
    stats[MEDICINE] = new CrewStat("Medicine");
    stats[MEDICINE].value = random.nextInt(MAX);
    if(random.nextBool()) {
      stats[MEDICINE].value = 0 - stats[MEDICINE].value;
    }

    stats[RESEARCH] = new CrewStat("Research");
    stats[RESEARCH].value = random.nextInt(MAX);
    if(random.nextBool()) {
      stats[RESEARCH].value = 0 - stats[RESEARCH].value;
    }

    stats[ENGINEERING] = new CrewStat("Engineering");
    stats[ENGINEERING].value = random.nextInt(MAX);
    if(random.nextBool()) {
      stats[ENGINEERING].value = 0 - stats[ENGINEERING].value;
    }

    stats[DIPLOMACY] = new CrewStat("Diplomacy");
    stats[DIPLOMACY].value = random.nextInt(MAX);
    if(random.nextBool()) {
      stats[DIPLOMACY].value = 0 - stats[DIPLOMACY].value;
    }

    stats[COMBAT] = new CrewStat("Combat");
    stats[COMBAT].value = random.nextInt(MAX);
    if(random.nextBool()) {
      stats[COMBAT].value = 0 - stats[COMBAT].value;
    }

    stats[SANITY] = new CrewStat("Sanity");
    stats[SANITY].value = random.nextInt(MAX);
    if(random.nextBool()) {
      stats[SANITY].value = 0 - stats[SANITY].value;
    }
  }


  //gets the canvas for the doll and scales it to a set size
  Future<CanvasElement> buildCanvas() async{
    print("running buildCanvas of ${await buildName()}");
    if(dollCanvas  != null) {
      return dollCanvas;
    }

    CanvasElement copy = await doll.getNewCanvas(); //todo replace this with call to rescaling function
    //return await doll.getNewCanvas();
    //CanvasElement temp = new CanvasElement(width:MAX_CANVAS_WIDTH, height:MAX_CANVAS_HEIGHT);
    double scaleX = 1;
    double scaleY = 1;
    if(copy.width > MAX_CANVAS_WIDTH) {
      print("adjusting by width of ${await buildName()}");
      scaleX = MAX_CANVAS_WIDTH/copy.width;
    }

    if(copy.height > MAX_CANVAS_HEIGHT) {
      print("adjusting by height of ${await buildName()}");
      scaleY = MAX_CANVAS_HEIGHT / copy.height;
    }
    if(scaleY > scaleX) {
      copy.style.transform = "scale($scaleX)";
    } else {
      copy.style.transform = "scale($scaleY)";
    }
    dollCanvas = copy;
    return dollCanvas;

  }
  
  Future<DivElement> getDivOutput() async {
    DivElement ret = new DivElement();
    //await buildCanvas();
    ret.append(await buildCanvas());
    DivElement text = new DivElement();

    //NAME EXCEPTIONS, BLAAH
    //dollsets 37(smol human) and 28(fek) should use human names.

    text.appendHtml("<h3>${await buildName()}</h3>");

    ret.append(text);

    //ret.appendText(stats.toString());
    ret.appendText(await getJob());

    for(int i = 0; i < stats.length; i++) {
      ret.append(new BRElement());
      ret.appendText("${stats[i].name}: ${stats[i].value}");
    }

    return ret;
  }

  Future<String> buildName() async{
    if(name != null) return name;

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
    return name;
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
      for (int j = 0; j < stats[i].value.abs(); j++) {
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
    } else if(jobType == COMBAT) {
      ret = textEngine.phrase("crewmemberJobsCombat", story: textStory);
    } else if(jobType == RESEARCH) {
      ret = textEngine.phrase("crewmemberJobsResearch", story: textStory);
    } else if(jobType == MEDICINE) {
      ret = textEngine.phrase("crewmemberJobsMedicine", story: textStory);
    } else if(jobType == DIPLOMACY) {
      ret = textEngine.phrase("crewmemberJobsDiplomacy", story: textStory);
    } else if(jobType == SANITY) {
      ret = textEngine.phrase("crewmemberJobsSanity", story: textStory);
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
    if(crewList.length == 0) {
      DivElement aiCrew = new DivElement();
      aiCrew.appendText("this spaceship has no crewmembers, save from a standard navigation AI.");
      ret.append(aiCrew);
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

