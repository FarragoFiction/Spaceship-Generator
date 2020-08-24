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

final int MAX_SEED = 2147483647;
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

void openCommsWindow() {
  commsWindow.children = new List<Element>();
  if(!commsWindowOpen) {
    DivElement ret = new DivElement();

    //todo tweak here
    ret.style.width = "800px";
    ret.style.height = "500px";
    ret.style.position = "absolute";
    ret.style.top = "50px";
    ret.style.left = "200px";
    ret.style.boxShadow = "10px 5px 5px black";
    ret.style.backgroundColor = "#0d3d6e";
    ret.style.color = "#69b3ff";
    ret.style.zIndex = "3";
    ret.appendText("Hello world");
    commsWindow.append(ret);
    commsWindowOpen = true;
  } else {
    commsWindow.children = new List<Element>();
    commsWindowOpen = false;
  }
}

//todo hook in system for opening communications window
void buildCommsButton() {
  DivElement comm = dashboard.drawCommsButton();
  commsButton.children =  new List<Element>();
  comm.onClick.listen((e) => openCommsWindow());
  commsButton.append(comm);
}

//todo hook in system for updating fuel display
void buildFuelGague() {
  DivElement gague = dashboard.drawFuelGague(50);
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
      updateNavigationDisplay(i);
      return;
    }
  }
}

void redrawCanvas(int starNum) {
  canvasSpot.children = new List<Element>();
  canvasSpot.append(dashboard.buildGameDashboard(spacemap, location, starNum)); //todo you probably don't need to redraw this every time, clean this up when it's time to work on improvements
}

void updateStarHighlighter(int starNum) {
}

void updateNavigationDisplay(int starNum) {
  Star oldStar = spacemap.stars[location];
  Star newStar = spacemap.stars[starNum];

  HeadingElement header = HeadingElement.h1();
  header.appendText(newStar.toString());

  DivElement distanceElement = new DivElement();
  double distance = 0;
  if(starNum != location) {
    //math! quadratic formula to find the distance between two points.
    double sum = 0;
    for(int i = 0; i < newStar.coordinates.length; i++) {
      double delta = newStar.coordinates[i] - oldStar.coordinates[i];
      sum += pow(delta, 2);
    }
    distance = sqrt(sum);
  }
  distanceElement.appendText("distance: ${distance.round()}");

  navbar.children = new List<Element>();
  navbar.append(header);
  navbar.append(distanceElement);
}