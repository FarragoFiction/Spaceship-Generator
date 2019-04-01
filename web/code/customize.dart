import 'dart:core';
import 'dart:html';
import 'dart:math';
import 'Starship.dart';
import 'Room.dart';

InputElement nameField;
DivElement roomFieldContainer;
List<int> roomValues;
DivElement output;
InputElement submit;
DivElement linkToMyShip;
Starship starship;
int id;

main() {
  //assign the fields
  nameField = document.querySelector('#nameField');
  roomFieldContainer = document.querySelector('#rooms');
  submit = document.querySelector('#submit');
  linkToMyShip = document.querySelector('#linkToMyShip');

  id = 0;
  //its after the ID so that it overrides some things it does
  if(Uri.base.queryParameters['b'] != null) {
    starship = Starship.parseDataString(Uri.base.queryParameters['b'], id);
  }else if(Uri.base.queryParameters['id'] != null) {
    id = int.parse(Uri.base.queryParameters['id']);
    starship = Starship.getRandomStarship(id);
  } else {
    Random rand = new Random();
    id = rand.nextInt(2147483647);
    starship = Starship.getRandomStarship(id);
  }

  nameField.value = starship.getName();

  roomValues = [];
  roomList();
  submit.onClick.listen((e) => buildDatastrings());
}

void roomList() {
  TableElement table = new TableElement();
  table.style.width = "100%";
  for(int i = 0; i < Room.ROOMS.length; i++) {
    TableRowElement row = new TableRowElement();
    TableCellElement numInput = new TableCellElement();
    numInput.style.textAlign = "right";

    InputElement roomField = new InputElement();
    roomField.style.textAlign = "right";

    roomField.type = "number";
    roomField.min = "0";
    roomField.max = "99";

    if(starship != null) {
      roomField.value = "${starship.getNumOfRoomType(i)}";
      print("${starship.getNumOfRoomType(i)}");
      
    } else {
      roomField.value = "0";
    }

    roomValues.add(int.parse(roomField.value));
    roomField.onInput.listen((e) => updateRoomValues(i, int.parse(roomField.value)));

    numInput.append(roomField);
    TableCellElement name = new TableCellElement();
    name.appendText(Room.ROOMS[i]);
    name.style.textAlign = "left";

    row.append(numInput);
    row.append(name);
    table.append(row);
  }
  if(table != null)
    roomFieldContainer.append(table);
}


void updateRoomValues(int roomId, int value) {
  roomValues[roomId] = value;
}

void buildDatastrings() {
  AnchorElement a = new AnchorElement();
  String datastring = Starship.getDatastring(roomValues, nameField.value);

  a.href = "index.html?b=${datastring}&id=$id";

  a.text = "View Spaceship";
  linkToMyShip.append(a);
  linkToMyShip.append(new BRElement());
}
