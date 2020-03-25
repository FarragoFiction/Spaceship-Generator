import 'dart:html';
import 'dart:core';
import 'dart:math';
import 'dart:svg';
import 'dart:async';

import 'code/Starship.dart';
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

InputElement shipButton;
InputElement crewButton;
bool showShip = true;
bool showCrew = true;

Starship starship;

void main() async {
  int seed = 85;
  name = querySelector('#name');
  id = querySelector('#id');
  output = querySelector('#output');
  canvasSpot = querySelector('#canvasSpot');
  crewSpot = querySelector('#crewSpot');

  shipButton = querySelector('#shipButton');
  crewButton = querySelector('#crewButton');

  shipButton.onClick.listen((e) => cycleShipDisp());
  crewButton.onClick.listen((e) => cycleCrewDisp());


  String datastringQueryFull = "";


  //Starship starship = Starship.getRandomStarship(seed);
  starship = await Starship.parseDataString("1-3-0-0-2-0-0-1-2-1-1-2-2--Bird%20%20Starship", seed);

  //Starship starship;
  //todo make default starship


  buildDisplay(starship);
  //roomList(starship);
  if (output != null) {
    output.appendText(starship.getDescription());
  }
  if (canvasSpot != null) {
    GameDashboard dashboard = new GameDashboard(starship);

    String datastring = Uri.base.queryParameters['d'];
    canvasSpot.append(dashboard.buildGameDashboard());

    //todo: allow datatstings to account for empty spots
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
}

void cycleShipDisp() {
  if(showShip) {
    showShip = false;
    output.children = new List<Element>();
  } else {
    showShip = true;
    buildDisplay(starship);
  }
}

void cycleCrewDisp() {
  if(showCrew) {
    showCrew = false;
      crewSpot.children = new List<Element>();
  } else {
    showCrew = true;
    makeCrew();
  }
}

void makeCrew() async {
  if(crewSpot != null) {
    //oh god why was i regenerating the crew every time
    Crew crew = await starship.getCrew();
    crewSpot.append(await crew.getAllMemberDivs());
}
}