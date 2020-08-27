import 'dart:html';
import 'dart:core';
import 'dart:math';
import 'dart:svg';
import 'dart:async';

import 'code/Starship.dart';
import 'code/Starmap.dart';
import 'code/Room.dart';
import 'code/Dashboard.dart';
import 'code/Crew.dart';

import 'code/displays/Display.dart';
import 'code/gameDashboard.dart';

import 'package:TextEngine/TextEngine.dart';

TableCellElement shareLink;
TableCellElement newLink;
TableCellElement dashboardLink;
TableCellElement statsheetLink;

HeadingElement name;
HeadingElement id;
DivElement output;
DivElement canvasSpot;
DivElement crewSpot;
String string;

bool toggleShipCrew = true;
bool commsWindowOpen = false;

GameDashboard dashboard;
DivElement toggleButton;
DivElement commsButton;
DivElement fuelGague;
DivElement hullGague;
DivElement currencyCounter;
DivElement commsWindow;
DivElement navbar;

Starship starship;
Starmap spacemap;

int location;
int target;
int distance;
int fuel;

void main() async {
  int seed = 85;
  name = querySelector('#name');
  id = querySelector('#id');
  output = querySelector('#output');
  canvasSpot = querySelector('#canvasSpot');
  crewSpot = querySelector('#crewSpot');

  toggleButton = querySelector('#toggle');
  commsButton = querySelector("#commsButton");
  fuelGague = querySelector("#fuel");
  hullGague = querySelector("#hull");
  currencyCounter = querySelector("#currency");

  commsWindow = querySelector("#commsWindow");
  navbar = querySelector("#navbar");

  String datastringQueryFull = "";

  starship = await Starship.parseDataString("1-3-0-0-2-0-0-1-2-1-1-2-2--Bird%20%20Starship", seed);
  spacemap = await Starmap.makeRandomStarmap(starship.id);
  location = 0; //always start at the first star in the system.
  target = 0;
  distance = 0;
  fuel = starship.getNumOfRoomType(7) * 100;

  buildDisplay(starship);
  //roomList(starship);
  if (canvasSpot != null) {
    dashboard = new GameDashboard(starship);

    String datastring = Uri.base.queryParameters['d'];
    canvasSpot.append(dashboard.buildGameDashboard(spacemap, location, location));
    canvasSpot.onClick.listen((e) => checkWindow(e));
    //todo put onclick detector here dfor finding star locations

    buildShipDataToggle();
    buildCommsButton();
    buildCurrencyCounter();
    buildFuelGague();
    buildHullGague();
    //todo: allow datatstings but only if its newgame+
    //print("my dashboard data string is\n"
    //  "${Dashboard.encodeCompleteDatastring(dashboard.segments)}");
    makeCrew();
  }


}

void roomList(Starship starship) {
  DListElement rooms = new DListElement();
  for(int i = 0; i < starship.rooms.length; i++) {
    LIElement listElement = new LIElement();
    listElement.appendText(starship.rooms[i].toString());
    rooms.append(listElement);
  }
  if(output != null)
    output.append(rooms);


}

void buildDisplay(Starship starship) {
  name.text = "${starship.getName()}";
  TableElement table = new TableElement();
  table.style.width = "70%";
  for(int i=0; i < Room.ROOMS.length; i++) {
    SvgSvgElement element;

    if(starship.getNumOfRoomType(i) > 0) {
      NixieTube numbers;
      if(starship.getNumOfRoomType(i) > 99) {
        numbers = new NixieTube(starship.getNumOfRoomType(i), starship.getNumOfRoomType(i), "");
      } else {
        numbers = new NixieTube(starship.getNumOfRoomType(i), 99, "");
      }

      element = numbers.graphicalDisplay();
      TableCellElement bar = new TableCellElement();
      bar.append(element);
      bar.style.textAlign = "left";

      TableCellElement text = new TableCellElement();
      text.appendText("${Room.ROOMS[i]}:");
      text.style.textAlign = "right";

      TableRowElement thisRow = new TableRowElement();
      thisRow.append(text);
      thisRow.append(bar);
      table.append(thisRow);
    }
  }
  if(output != null)
    output.append(table);
  output.appendText(starship.getDescription());
}


void cycleCrewShipDisp() {
  if(!toggleShipCrew) {
    crewSpot.children = new List<Element>();
    buildDisplay(starship);
    toggleShipCrew = true;
  } else {
    toggleShipCrew = false;
    makeCrew();
    output.children = new List<Element>();
  }
  buildShipDataToggle();
}

void makeCrew() async {
  if(crewSpot != null && toggleShipCrew == false) {
    //oh god why was i regenerating the crew every time
    Crew crew = await starship.getCrew();
    crewSpot.append(await crew.getAllMemberDivs());
  }
}

void buildShipDataToggle() {
  DivElement toggle = dashboard.drawCrewShipSwitch(toggleShipCrew);
  toggle.children.elementAt(2).onClick.listen((e)=> cycleCrewShipDisp());
  toggleButton.children =  new List<Element>();
  toggleButton.append(toggle);
}

DivElement getBlankCommsWindow() {
  DivElement ret = new DivElement();

  //todo tweak window style here
  ret.style.width = "800px";
  ret.style.height = "500px";
  ret.style.position = "absolute";
  ret.style.top = "50px";
  ret.style.left = "200px";
  ret.style.boxShadow = "10px 5px 5px black";
  ret.style.backgroundColor = "#0d3d6e";
  ret.style.color = "#69b3ff";
  ret.style.zIndex = "3";
  return ret;
}

void openCommsWindow() {
  commsWindow.children = new List<Element>();
  if(!commsWindowOpen) {
    DivElement ret = getBlankCommsWindow();

    //displayed information: menu of available ships in the system
    Star star = spacemap.stars[location];
    if(star.starships.length == 0) {
      ret.appendText("No vessels are in range.");
    } else {
      for(int i = 0; i < star.starships.length; i++) {
        Starship targetStarship = star.starships[i];
        ButtonElement menuItem = new ButtonElement(); //todo make this pretty

        //displays the name of the starship
        HeadingElement targetNameElement = new HeadingElement.h3();
        targetNameElement.appendText(targetStarship.getName());

        //displays interesting features about the starship.
        DivElement traitListElement = new DivElement();
        List<String> traitList = targetStarship.getTraitText();
        if(traitList.length == 0) {
          traitListElement.appendText("No notable features.");
        } else {
          traitListElement.appendText("${traitList[0]}");
          for (int i = 1; i < traitList.length; i++) {
            traitListElement.appendText(", ${traitList[i]}");
          }
        }

        //set up table
        TableElement table = new TableElement();
        table.style.tableLayout = "fixed";
        TableRowElement r1 = new TableRowElement();
        TableCellElement c1A = new TableCellElement();
        TableCellElement c1B = new TableCellElement();

        c1A.style.width = "30%";
        c1B.style.width = "70%";

        //set up column A
        c1A.append(targetNameElement);

        //set up column B
        c1B.append(traitListElement);

        //combine all
        r1.append(c1A);
        r1.append(c1B);
        table.append(r1);

        menuItem.append(table);
        menuItem.onClick.listen((e) => startCommsWithShip(targetStarship));
        ret.append(menuItem);
      }
    }
    commsWindow.append(ret);
    commsWindowOpen = true;
  } else {
    commsWindow.children = new List<Element>();
    commsWindowOpen = false;
  }
}

void startCommsWithShip(Starship target) async{
  DivElement ret = getBlankCommsWindow();

  //if there's a crew, you'll talk to a member of it.
  CanvasElement visualFeed = new CanvasElement();
  if(target.crew.crewList.length > 0) {
    visualFeed = await target.crew.crewList[0].buildCanvas(); //todo make this a random selection of crewmembers maybe?
  }

  //setup for filter. THANK GOD I'VE ALREADY DONE THIS.
  DefsElement defs = new DefsElement();
  FilterElement blueFilter = new FilterElement();
  blueFilter.id = "blue";

  //FEGaussianBlurElement blurElement = new FEGaussianBlurElement();
  //blurElement.setAttribute("stdDeviation", "3");

  //blueFilter.append(blurElement);
  //defs.append(blueFilter);

  FEColorMatrixElement matrixElement = new FEColorMatrixElement();
  matrixElement.setAttribute("values",
      "0 0 0 1.9 -2.2 "
      "0 1 0 0 0.3 "
      "0 0 1 0 0.5 "
      "0 0 0 0.7 0 ");
  blueFilter.append(matrixElement);
  defs.append(blueFilter);

  //put everything together
  visualFeed.append(defs);
  visualFeed.style.filter = "url(#blue)";
  ret.append(visualFeed);


  /******
   * THE TEXT PART
   */
  SpanElement commsTextContent = new SpanElement();
  if(target.crew.crewList.length > 0) {
    commsTextContent.appendText(await generateDefaultDialogue(target.crew.crewList[0], target));
  } else {
    //sometimes there's no crew.
    commsTextContent.appendText(await generateDefaultDialogue(null, target));
  }


  ret.append(commsTextContent);
  commsWindow.children = new List<Element>();
  commsWindow.append(ret);
}

Future<String> generateDefaultDialogue(Crewmember speaker, Starship target) async{
  TextEngine textEngine = new TextEngine();
  TextStory textStory = new TextStory();
  await textEngine.loadList("CommsPanelDialogue");

  //add crew name, job, ship name
  //crew name
  Word crewName;
  Word jobName;
  if(speaker != null) {
    crewName = new Word(await speaker.getName());
    jobName = new Word(await speaker.getJob());
  } else {
    crewName = new Word("ID #${target.getId()}");
    jobName = new Word("Operations AI");
  }
  Word shipName = new Word(await target.getName());

  textEngine.sourceWordLists["crewName"].add(crewName);
  textEngine.sourceWordLists["job"].add(jobName);
  textEngine.sourceWordLists["shipName"].add(shipName);

  //todo incorporate flavor text selection based on job/ship capabilities/etc
  return textEngine.phrase("defaultSentence", story: textStory);
}

void buildCommsButton() {
  DivElement comm = dashboard.drawCommsButton();
  commsButton.children =  new List<Element>();
  comm.onClick.listen((e) => openCommsWindow());
  commsButton.append(comm);
}

void buildFuelGague() {
  DivElement gague = dashboard.drawFuelGague(fuel, starship.getNumOfRoomType(7) * 100);
  fuelGague.children =  new List<Element>();
  fuelGague.append(gague);
}

//todo hook in system for updating hull display
void buildHullGague() {
  DivElement gague = dashboard.drawHullGague(50);
  hullGague.children =  new List<Element>();
  hullGague.append(gague);
}

//todo hook in system for updating hull display
void buildCurrencyCounter() {
  DivElement counter = dashboard.drawCurrencyCounter(113);
  currencyCounter.children =  new List<Element>();
  currencyCounter.append(counter);
}

void checkWindow(MouseEvent e) {
  int mouseX = e.offset.x;
  int mouseY = e.offset.y;
  print("I think you're clicking at ($mouseX, $mouseY).");

  for(int i = 0; i < spacemap.stars.length; i++) {
    //todo this will be offcenter
    int starX = dashboard.starDrawCoords[i].x;
    int starY = dashboard.starDrawCoords[i].y;
    //print("star $i at ($starX, $starY)");
    //adding a bit of leeway. might fuck up if stars gen close together but i can just.... avoid that
    if(((mouseX - starX) <= 15 && (mouseX - starX >= -5)) && ((mouseY - starY) <= 15 && (mouseY - starY) >= -5)) {
      print("Success!");
      if(target == i && distance < fuel) { //todo give an indication to the player when fuel is too low
        fuel -= distance;
        location = i;
      }
      target = i;
      distance = updateNavigationDisplay();
      redrawCanvas();
      buildFuelGague();
      return;
    }
  }
}

void redrawCanvas() {
  canvasSpot.children = new List<Element>();
  canvasSpot.append(dashboard.buildGameDashboard(spacemap, location, target)); //todo you probably don't need to redraw this every time, clean this up when it's time to work on improvements
}

int updateNavigationDisplay() {
  Star oldStar = spacemap.stars[location];
  Star newStar = spacemap.stars[target];

  //displays name of the star
  HeadingElement starNameElement = HeadingElement.h3();
  starNameElement.appendText(newStar.toString());

  //displays distance to this star
  DivElement distanceElement = new DivElement();
  double distance = 0;
  if(target != location) {
    //math! quadratic formula to find the distance between two points.
    double sum = 0;
    for(int i = 0; i < newStar.coordinates.length; i++) {
      double delta = newStar.coordinates[i] - oldStar.coordinates[i];
      sum += pow(delta, 2);
    }
    distance = sqrt(sum);
  }
  distanceElement.appendText("Distance: ${distance.round()}");

  //displays how many other starships are present
  DivElement starshipsAtStarElement = new DivElement();
  starshipsAtStarElement.appendText("Registered Vessels: ${newStar.starships.length}");

  //determine any notable landmarks here
  DivElement landmarkDisp = new DivElement();
  landmarkDisp.appendText(newStar.listNotableLandmarks());


  navbar.children = new List<Element>();

  //set up table
  TableElement table = new TableElement();
  TableRowElement r1 = new TableRowElement();
  TableCellElement c1A = new TableCellElement();
  TableCellElement c1B = new TableCellElement();

  //set up column A
  c1A.append(starNameElement);
  c1A.append(distanceElement);
  c1A.append(starshipsAtStarElement);

  //set up column B
  c1B.append(landmarkDisp);

  //combine all
  r1.append(c1A);
  r1.append(c1B);
  table.append(r1);

  table.style.tableLayout = "fixed";
  c1A.style.width = "50%";
  c1B.style.width = "50%";

  navbar.append(table);

  /*
  navbar.append(header);
  navbar.append(distanceElement);*/

  return distance.round();
}