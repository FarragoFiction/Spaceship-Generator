import 'dart:html';
import 'dart:core';
import 'dart:math';
import 'Starship.dart';
import 'Room.dart';
import 'Dashboard.dart';
import 'dart:svg';
import 'displays/Display.dart';

final int MAX_SEED = 2147483647;
void main() {
  int seed;

  if(Uri.base.queryParameters['id'] == null) {
    Random rand = new Random();
    seed = rand.nextInt(MAX_SEED);
    querySelector('#sharelink').appendHtml('<a href="${Uri.base.toString()}?id=$seed">link to this ship</a>');
    querySelector('#newlink').appendHtml('<a href="${Uri.base.toString()}">make new ship</a>');

  } else {
    seed = int.parse(Uri.base.queryParameters['id']);
    querySelector('#sharelink').appendHtml('<a href="${Uri.base.toString()}">link to this ship</a>');
    querySelector('#newlink').appendHtml('<a href="${Uri.base.toString().substring(0, Uri.base.toString().indexOf("?"))}">make new ship</a>');
  }



  Starship starship = new Starship(seed);
  querySelector('#name').text = "${starship.getName()}";
  querySelector('#id').text = "ID: ${starship.getId()}";
  buildDisplay(starship);
  //roomList(starship);
  querySelector('#output').appendText(starship.getDescription());
  querySelector('#canvasSpot').append(new Dashboard(starship).buildDashboard());
}

void roomList(Starship starship) {
  DListElement rooms = new DListElement();
  for(int i = 0; i < starship.rooms.length; i++) {
    LIElement listElement = new LIElement();
    listElement.appendText(starship.rooms[i].toString());
    rooms.append(listElement);
  }
  querySelector('#output').append(rooms);
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
  querySelector('#output').append(table);
}

