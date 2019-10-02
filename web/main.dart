import 'dart:html';
import 'dart:core';
import 'dart:math';
import 'dart:svg';
import 'dart:async';

import 'code/Starship.dart';
import 'code/Room.dart';
import 'code/Dashboard.dart';
import 'code/Crew.dart';
import 'code/Planets.dart';

import 'code/displays/Display.dart';

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

void main() async{
  int seed;
  //hello farrago
  shareLink = querySelector('#sharelink');
  newLink = querySelector('#newlink');
  dashboardLink = querySelector('#dashboardlink');
  statsheetLink = querySelector('#statsheetlink');
  name = querySelector('#name');
  id = querySelector('#id');
  output = querySelector('#output');
  canvasSpot = querySelector('#canvasSpot');
  crewSpot = querySelector('#crewSpot');

  String datastringQueryFull = "";


  //Starship starship = Starship.getRandomStarship(seed);
  //Starship starship = Starship.parseBetaDataString("20-1-0-3-2-1-4-0-3-0-1-5-0--Chicago%20Overcoat", seed);

  Starship starship;


  //id is the seed
  if (Uri.base.queryParameters['id'] == null) {
    Random rand = new Random();
    seed = rand.nextInt(MAX_SEED);
  } else {
    seed = int.parse(Uri.base.queryParameters['id']);
  }

  //b for blueprint
  //todo undo this when done testing please
  if (Uri.base.queryParameters['b'] == null) {
    starship = await Starship.getRandomStarship(seed);
  } else {
    starship = await Starship.parseDataString(Uri.base.queryParameters['b'], seed);
    datastringQueryFull += "&b=${Uri.encodeFull(Uri.base.queryParameters['b'])}";
  }

  //window.console.table(starship);

  print("my Beta data string is\n"
      "${Starship.getDatastring(starship.getNumRooms(), starship.getName())}");


  if (name != null)
    name.text = await "${starship.getName()}";
  if (id != null)
    id.text = "ID: ${starship.getId()}";

  buildDisplay(starship);
  //roomList(starship);
  if (output != null) {
    output.appendText(starship.getDescription());
  }
  if (canvasSpot != null) {
    Dashboard dashboard = new Dashboard(starship);

    //d for dashboard
    if (Uri.base.queryParameters['d'] == null) {
      canvasSpot.append(dashboard.buildRandomDashboard());
    } else {
      String datastring = Uri.base.queryParameters['d'];
      canvasSpot.append(dashboard.buildCustomDashboard(datastring));
    }

    print("my dashboard data string is\n"
        "${Dashboard.encodeCompleteDatastring(dashboard.segments)}");
  }

  //make sure the datastringqueryfull has the D
  if(Uri.base.queryParameters['d'] != null)
    datastringQueryFull += "&d=${Uri.encodeFull(Uri.base.queryParameters['d'])}";

  //prepare Links
  if (shareLink != null && newLink != null) {
    if (Uri.base.queryParameters['id'] == null) {
      Random rand = new Random();
      seed = rand.nextInt(MAX_SEED);
      if(datastringQueryFull == "") {
        shareLink.appendHtml(
            '<a href="${Uri.base.toString()}?id=$seed">link to this ship</a>');
        newLink.appendHtml('<a href="${Uri.base.toString()}">make new ship</a>');
      } else {
        shareLink.appendHtml(
            '<a href="${Uri.base.toString()}&id=$seed">link to this ship</a>');
        newLink.appendHtml('<a href="${Uri.base.toString().substring(
            0, Uri.base.toString().indexOf("?"))}">make new ship</a>');
      }

    } else {
      seed = int.parse(Uri.base.queryParameters['id']);
      shareLink.appendHtml(
          '<a href="${Uri.base.toString()}">link to this ship</a>');
      newLink.appendHtml('<a href="${Uri.base.toString().substring(
          0, Uri.base.toString().indexOf("?"))}">make new ship</a>');
    }
  }

  print(datastringQueryFull);
  if (dashboardLink != null) {
    dashboardLink.appendHtml(
        '<a href="dashboard.html?id=${seed}$datastringQueryFull">view ship dashboard</a>'
    );
  }
  if (statsheetLink != null) {
    statsheetLink.appendHtml(
        '<a href="index.html?id=${seed}$datastringQueryFull">view ship stats</a>'
    );
  }

  if(crewSpot != null) {
    Crew crew = await Crew.makeRandomCrewForStarship(starship);
    crewSpot.append(await crew.getAllMemberDivs());
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

/*
  right so for URLs.
  -if there is a datastring already in the URL include it when linking to
  the ship from the seed link & the dashboard link
 */
