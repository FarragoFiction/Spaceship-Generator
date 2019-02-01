import 'dart:html';
import 'dart:core';
import 'dart:math';
import 'Starship.dart';
import 'Room.dart';
import 'dart:svg';

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
  buildBars(starship);
  //roomList(starship);
  querySelector('#output').appendText(starship.getDescription());

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

void buildBars(Starship starship) {
  TableElement table = new TableElement();
  table.style.width = "100%";
  for(int i=0; i < Room.rooms.length; i++) {
    SvgSvgElement element = new SvgSvgElement();
    element.style.height = "50";
    element.style.width = "300";
    if(starship.getNumOfRoomType(i) > 0) {
      RectElement progress = new RectElement();
      progress.style.setProperty("fill", "#00ff00");
      progress.style.top = "0";
      progress.style.height = "50";
      progress.style.left = "0";
      progress.style.width =
        (300 * starship.getNumOfRoomType(i) / starship.getNumOfMaxRoom()).toString();

      element.append(progress);
      TableCellElement bar = new TableCellElement();
      bar.append(element);
      bar.style.textAlign = "left";

      TableCellElement text = new TableCellElement();
      text.appendText("${Room.rooms[i]}: ${starship.getNumOfRoomType(i)}");
      text.style.textAlign = "right";

      TableRowElement thisRow = new TableRowElement();
      thisRow.append(text);
      thisRow.append(bar);
      table.append(thisRow);
    }
  }
  querySelector('#output').append(table);
}