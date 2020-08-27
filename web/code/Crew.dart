import 'dart:core';
import 'dart:async';
import 'dart:html';
import 'crewStats.dart';
import 'CrewFactions.dart';
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
  String job;
  int jobType;

  static final int MAX_CANVAS_HEIGHT = 300;
  static final int MAX_CANVAS_WIDTH = 150; //adjusting for game display uwu

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
    jobType = -2;
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
    print("running buildCanvas of ${await getName()}");
    if(dollCanvas  != null) {
      return dollCanvas;
    }

    CanvasElement copy = await doll.getNewCanvas();
    double scaleX = 1;
    double scaleY = 1;
    if(copy.width > MAX_CANVAS_WIDTH) {
      print("adjusting by width of ${await getName()}");
      scaleX = MAX_CANVAS_WIDTH/copy.width;
    }

    if(copy.height > MAX_CANVAS_HEIGHT) {
      print("adjusting by height of ${await getName()}");
      scaleY = MAX_CANVAS_HEIGHT / copy.height;
    }
    double scale;
    if(scaleY > scaleX) {
      scale = scaleX;
    } else {
      scale = scaleY;
    }
    copy.style.transform = "scale($scale)";
    copy.style.marginLeft = "-${(1-scale)*copy.width/2}px";
    copy.style.marginRight = "-${(1-scale)*copy.width/2}px";
    copy.style.marginTop = "-${(1-scale)*copy.height/2}px";
    copy.style.marginBottom = "-${(1-scale)*copy.height/2}px";

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

    text.appendHtml("<h3>${await getName()}</h3>");

    ret.append(text);

    //ret.appendText(stats.toString());
    ret.appendText(await getJob()); //todo DONT REGEN EVERY TIME

    for(int i = 0; i < stats.length; i++) {
      ret.append(new BRElement());
      ret.appendText("${stats[i].name}: ${stats[i].value}");
    }

    return ret;
  }

  Future<String> getName() async{
    if(name != null) return name;

    if(doll.renderingType == CrewFactions.SMOL_KID_ID || doll.renderingType == CrewFactions.FEK_ID ) {
      TextEngine textEngine = new TextEngine(id);
      TextStory textStory = new TextStory();
      await textEngine.loadList("names");
      name = textEngine.phrase("kidname_all", story: textStory);
    } else if(doll.renderingType == CrewFactions.SMOL_TROLL_ID){ //smol trols use troll names
      TextEngine textEngine = new TextEngine(id);
      TextStory textStory = new TextStory();
      await textEngine.loadList("names");
      name = textEngine.phrase("trollname_all", story: textStory);
    } /* //im not using fruit anymore but wanna leave this open
      else if(doll.renderingType == 35) { //fruits have it at dollName
      name = await doll.dollName;
    }*/ else if(doll.renderingType == CrewFactions.DOC_ID) {
      TextEngine textEngine = new TextEngine(id);
      TextStory textStory = new TextStory();
      await textEngine.loadList("names");
      name = textEngine.phrase("docname_temp", story: textStory);
    } else if(doll.renderingType == CrewFactions.HOMESTUCK_LAMIA_TREE_BAB_ID || doll.renderingType == CrewFactions.HOMESTUCK_LAMIA_ID) { //treebabs and satyr kittens get troll grub names
      TextEngine textEngine = new TextEngine(id);
      TextStory textStory = new TextStory();
      await textEngine.loadList("names");
      name = textEngine.phrase("wigglername_all", story: textStory);
    } else if(doll.renderingType == CrewFactions.COOKIE_ID) { //cookie placeholder names taken from list of food
      TextEngine textEngine = new TextEngine(id);
      TextStory textStory = new TextStory();
      await textEngine.loadList("names");
      name = textEngine.phrase("cookiename_temp", story: textStory);
    } else if(doll.renderingType == CrewFactions.MAGICAL_GIRL_TWO_ID) { //magical girl 2 should be same as magicalgirl 1
      TextEngine textEngine = new TextEngine(id);
      TextStory textStory = new TextStory();
      await textEngine.loadList("names");
      name = textEngine.phrase("dollname_magicaldoll", story: textStory);
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

  Future<int> getJobType() async {
    if(jobType >= -1 && jobType <= 5) return jobType;
    await getJob();
    return jobType;
  }

  Future<String> getJob() async {
    if(job != null) return job;
    List<int> possibleJobs = [OTHER_JOB, OTHER_JOB, OTHER_JOB];
    for (int i = 0; i < stats.length; i++) {
      for (int j = 0; j < stats[i].value.abs(); j++) {
        possibleJobs.add(i);
      }
    }
    print("possibleJobs: ${possibleJobs.length}");
    Random rand = new Random(id);
    jobType = possibleJobs[rand.nextInt(possibleJobs.length)];

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
    job = ret;
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

    //am i predominantly one faction, or a mixed bag?
    bool isMonoFaction = rand.nextBool();

    List<int> mainFaction;
    if(isMonoFaction) {
      mainFaction = CrewFactions.ALL_FACTIONS[rand.nextInt(CrewFactions.ALL_FACTIONS.length)];
    }

    //build the crew
    List<Crewmember> crewList = [];
    for(int i = 0; i < numCrew; i++) {
      int memberId = rand.nextInt(2147483647);
      Crewmember member;

      if(isMonoFaction && rand.nextDouble() <= 0.9) {
        member = await Crewmember.randomCrewmember(memberId, mainFaction[rand.nextInt(mainFaction.length)]);
      } else {
        int memberSpeciesId = CrewFactions.ALL_IDS[rand.nextInt(CrewFactions.ALL_IDS.length)];
        member = await Crewmember.randomCrewmember(memberId, memberSpeciesId);
      }
      crewList.add(member);
    }
    return new Crew(crewList);
  }


  static Future<Crew> testAllCrewNames() async{
    print("testing a crew with every species");
    Random rand = new Random(85);
    int numCrew = Doll.allDollTypes.length;

    //build the crew
    List<Crewmember> crewList = [];
    for(int i = 0; i < numCrew; i++) {
      int memberId = rand.nextInt(2147483647);
      Crewmember member;
      int memberSpeciesId = Doll.allDollTypes[i];
      member = await Crewmember.randomCrewmember(memberId, memberSpeciesId);
      crewList.add(member);
    }
    return new Crew(crewList);
  }
}

