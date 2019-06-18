import 'dart:core';
import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'code/Starship.dart';
import 'dart:svg';
import 'code/Room.dart';
import 'code/DashboardSegment.dart';
import 'code/Dashboard.dart';
import 'code/FillerSVG.dart';

InputElement nameField;
DivElement roomFieldContainer;
List<int> roomValues;
DivElement output;
InputElement submit;
DivElement linkToMyShip;
Starship starship;
int id;

List<SegmentContainer> segmentContainers;

DivElement dashboardFields;


main() async{
  //assign the fields
  nameField = document.querySelector('#nameField');
  roomFieldContainer = document.querySelector('#rooms');
  submit = document.querySelector('#submit');
  linkToMyShip = document.querySelector('#linkToMyShip');
  dashboardFields = document.querySelector("#segments");

  id = 0;
  if(Uri.base.queryParameters['b'] != null) {
    starship = await Starship.parseDataString(Uri.base.queryParameters['b'], id);
  }else if(Uri.base.queryParameters['id'] != null) {
    id = int.parse(Uri.base.queryParameters['id']);
    starship = await Starship.getRandomStarship(id);
  } else {
    Random rand = new Random();
    id = rand.nextInt(2147483647);
    starship = await Starship.getRandomStarship(id);
  }

  nameField.value = starship.getName();

  roomValues = [];
  roomList();
  submit.onClick.listen((e) => buildDatastrings());

  segmentContainers = [];
  Dashboard dashboard = new Dashboard(starship);
  dashboard.buildRandomDashboard();
  for(int i = 0; i < 19; i++) {
    DashboardSegment segment = dashboard.segments[i];
    SegmentContainer segmentContainer = SegmentContainer.fromSegment(segment);
    segmentContainers.add(segmentContainer);
    dashboardFields.append(segmentContainer.buildMyDiv());
  }

}

List<DashboardSegment> getDashboardSegments() {
  List<DashboardSegment> ret = new List<DashboardSegment>();
  for(int i = 0; i < segmentContainers.length; i++) {
    ret.add(segmentContainers[i].getSegment());
  }
  return ret;
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
    roomField.onChange.listen((e) => updateRoomValues(i, roomField.value));

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

void updateRoomValues(int roomId, String value) {
  int numValue = int.parse(value, onError: (source) => null);
  if(numValue != null && numValue >= 0) {
    roomValues[roomId] = int.parse(value);
  } else {
    window.alert("please enter a valid number. negative numbers and non-whole numbers are not allowed.");
  }
}

void buildDatastrings() {
  AnchorElement statLink = new AnchorElement();
  String statDatastring = Starship.getDatastring(roomValues, nameField.value);

  String dashboardDatastring = Dashboard.encodeCompleteDatastring(getDashboardSegments());

  statLink.href = "index.html?b=${statDatastring}&d=$dashboardDatastring&id=$id";

  statLink.text = "View Spaceship";



  AnchorElement dashboardLink= new AnchorElement();
  dashboardLink.href = "dashboard.html?b=${statDatastring}&d=$dashboardDatastring&id=$id";

  dashboardLink.text = "View Dashboard";


  linkToMyShip.append(statLink);
  linkToMyShip.appendText("   ");//some blank space to seperate the links
  linkToMyShip.append(dashboardLink);
  linkToMyShip.append(new BRElement());
}





class SegmentContainer {
  int type;
  List<int> values;
  String title;


  SegmentContainer(int type, List<int> values, String title) {
    this.type = type;
    this.values = values;
    this.title = title;
  }

  DashboardSegment getSegment() {
    if(type < 4) {
      return Dashboard.makeDisplay(type, values[0], 100, title);

    } else if(type == 4) { //this covers switches
      List<bool> boolValues = [];
      for(int i = 0; i < values.length; i++) {
        if(values[i] == 1 )
          boolValues.add(true);
        else boolValues.add(false);
      }
      return new Switches(boolValues);
    } else if(type == 5) {
      return new Buttons(values);
    }
  }

  static SegmentContainer fromSegment(DashboardSegment segment) {
    int type = 0;
    List<int> values = [0];
    String title = "";
    if(segment is Display) {
      type = segment.getTypeId();
      values = [segment.getValue()];
      title = segment.getLabel();
    } else if(segment is Switches) {
      type = 4;
      for(int i = 0; i < segment.toggleStates.length; i++) {
        if(segment.toggleStates[i])
          values.add(1);
        else values.add(0);
      }
    } else if(segment is Buttons) {
      type = 5;
      values = segment.colorStates;
    }
    SegmentContainer ret = new SegmentContainer(type, values, title);
    return ret;
  }

  DivElement buildMyDiv() {
    DivElement ret = new DivElement();

    SelectElement typeSelect = getTypeSelector();
    typeSelect.options[type].selected = true;
    typeSelect.onInput.listen((e) => changeType(typeSelect.selectedIndex, this)); //this is either really smart or really dumb way to solve my problem

    ret.append(typeSelect);

    SvgSvgElement graphicalDisplay = getSegment().graphicalDisplay();
    graphicalDisplay.onClick.listen((e) => cycleSvgFillerState(e, this));

    ret.append(graphicalDisplay);

    if(type < 4) {
      InputElement label = new InputElement();
      label.value = title;
      label.onChange.listen((e) => changeLabel(label.value, this));

      InputElement slider = new InputElement();
      slider.value = "${values[0]}";
      slider.type = "range";
      slider.min = "0";
      slider.max = "100";
      slider.onChange.listen((e) => changeValue(int.parse(slider.value), this));

      ret.append(label);
      ret.append(slider);
    }

    return ret;
  }



  static SelectElement getTypeSelector() {
    SelectElement ret = new SelectElement();

    OptionElement needleGague = new OptionElement();
    needleGague.value = "${NEEDLE_GAUGE_ID}";
    needleGague.appendText("needle gauge");

    OptionElement barGague = new OptionElement();
    barGague.appendText("bar gague");
    barGague.value = "$BAR_GAUGE_ID";

    OptionElement nixieTube = new OptionElement();
    nixieTube.appendText("nixie tubes");
    nixieTube.value = "$NIXIE_ID";

    OptionElement sevenSeg = new OptionElement();
    sevenSeg.appendText("seven segment display");
    sevenSeg.value = "$SEVEN_SEGMENT_ID";

    OptionElement switches = new OptionElement();
    switches.appendText("switches");
    switches.value = "4";

    OptionElement buttons = new OptionElement();
    buttons.appendText("buttons");
    buttons.value = "5";

    ret.append(needleGague);
    ret.append(barGague);
    ret.append(nixieTube);
    ret.append(sevenSeg);
    ret.append(switches);
    ret.append(buttons);
    return ret;
  }
}



void changeType(int newType, SegmentContainer caller) {
  print("changing type to $newType");
  if(newType < 4) {
    if(caller.type >= 4) { //reuse the old values if possible
      caller.values = [0];
      caller.title = "label";
    }

  } else { //this covers switches
    caller.values = [0,0,0,0,0,0];
  }
  caller.type = newType;

  updateDashboardFields();
}

void changeValue(int newValue, SegmentContainer caller) {
  caller.values[0] = newValue;
  updateDashboardFields();
}

void changeLabel(String newLabel, SegmentContainer caller) {
  caller.title = newLabel; //dont need to update here
}

void cycleSvgFillerState(MouseEvent e, SegmentContainer caller) {
  int targetIndex = 0;
  //check the y position
  //print("i think my coordinates are (${e.offset.x},${e.offset.y}");
  int height = caller.getSegment().graphicalDisplay().height.baseVal.value;
  int width = caller.getSegment().graphicalDisplay().width.baseVal.value;
  //print("i think my size is $width by $height");
  if(e.offset.y > height ~/ 2) {
      targetIndex += 3;
  }
  //check the x position
  targetIndex += e.offset.x ~/ (width ~/ 3);
  //print("my target index is $targetIndex");

  //sometimes it thinks theres an extra switch if you click too close to the edge
  if(targetIndex > 5)
    targetIndex = 5;

  //and now to cycle the boys
  int maxValue = 1;
  if(caller.type == 5) { //buttons cycle through 4 colors
    maxValue = 3;
  }
  if (caller.values[targetIndex] == maxValue) {
      caller.values[targetIndex] = 0;
  } else {
    caller.values[targetIndex]++;
  }
  updateDashboardFields();
}

updateDashboardFields() {
  dashboardFields.children = new List<Element>();
  for(int i = 0; i < segmentContainers.length; i++) {
    dashboardFields.append(segmentContainers[i].buildMyDiv());
  }
}

