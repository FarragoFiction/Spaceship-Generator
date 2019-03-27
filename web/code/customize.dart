import 'dart:core';
import 'dart:html';
import 'Starship.dart';
import 'Room.dart';

InputElement nameField;
DivElement roomFieldContainer;
List<int> roomValues;
DivElement output;
InputElement submit;
DivElement linkToMyShip;

main() {
  //assign the fields
  nameField = document.querySelector('#nameField');
  roomFieldContainer = document.querySelector('#rooms');
  submit = document.querySelector('#submit');
  linkToMyShip = document.querySelector('#linkToMyShip');


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
    roomField.value = "0";
    roomField.min = "0";
    roomField.max = "99";

    roomValues.add(0);
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

  a.href = "index.html?b=$datastring";
  a.text = "View Spaceship";
  linkToMyShip.append(a);
  linkToMyShip.append(new BRElement());
}
