import 'dart:html';
import 'dart:core';
import 'dart:math';
import 'Starship.dart';
import 'Room.dart';
import 'Dashboard.dart';
import 'dart:svg';
import 'displays/Display.dart';

final int MAX_SEED = 2147483647;
TableCellElement shareLink;
TableCellElement newLink;
TableCellElement dashboardLink;
TableCellElement statsheetLink;

HeadingElement name;
HeadingElement id;
DivElement output;
DivElement canvasSpot;


void main() {
  int seed;
  shareLink = querySelector('#sharelink');
  newLink = querySelector('#newlink');
  dashboardLink = querySelector('#dashboardlink');
  statsheetLink = querySelector('#statsheetlink');
  name = querySelector('#name');
  id = querySelector('#id');
  output = querySelector('#output');
  canvasSpot = querySelector('#canvasSpot');

  if(shareLink != null && newLink != null) {
    if (Uri.base.queryParameters['id'] == null) {
      Random rand = new Random();
      seed = rand.nextInt(MAX_SEED);
      shareLink.appendHtml(
          '<a href="${Uri.base.toString()}?id=$seed">link to this ship</a>');
      newLink.appendHtml('<a href="${Uri.base.toString()}">make new ship</a>');

    } else {
      seed = int.parse(Uri.base.queryParameters['id']);
      shareLink.appendHtml(
          '<a href="${Uri.base.toString()}">link to this ship</a>');
      newLink.appendHtml('<a href="${Uri.base.toString().substring(
          0, Uri.base.toString().indexOf("?"))}">make new ship</a>');
    }
  }

  if(dashboardLink != null) {
    dashboardLink.appendHtml(
      '<a href="dashboard.html?id=$seed">view ship dashboard</a>'
    );
  }
  if(statsheetLink != null) {
    statsheetLink.appendHtml(
        '<a href="index.html?id=$seed">view ship stats</a>'
    );
  }


  //Starship starship = Starship.getRandomStarship(seed);
  //Starship starship = Starship.parseBetaDataString("20-1-0-3-2-1-4-0-3-0-1-5-0--Chicago%20Overcoat", seed);

  Starship starship;

  //b for blueprint
  if(Uri.base.queryParameters['b'] == null) {
    starship = Starship.getRandomStarship(seed);
  } else {
    starship = Starship.parseBetaDataString(Uri.base.queryParameters['b'], seed);
  }


  print("my Beta data string is\n${starship.getBetaDatastring()}");


  if(name != null)
    name.text = "${starship.getName()}";
  if(id != null)
    id.text = "ID: ${starship.getId()}";

  buildDisplay(starship);
  //roomList(starship);
  if(output != null)
    output.appendText(starship.getDescription());
  if(canvasSpot != null)
    canvasSpot.append(new Dashboard(starship).buildDashboard());
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
  for(int i=0; i < Room.rooms.length; i++) {
    SvgSvgElement element;

    if(starship.getNumOfRoomType(i) > 0) {
      NixieTube numbers = new NixieTube(starship.getNumOfRoomType(i), 99);

      element = numbers.graphicalDisplay();
      TableCellElement bar = new TableCellElement();
      bar.append(element);
      bar.style.textAlign = "left";

      TableCellElement text = new TableCellElement();
      text.appendText("${Room.rooms[i]}:");
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

