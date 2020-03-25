import 'dart:html';
import 'dart:core';
import 'dart:async';
import 'code/displays/Display.dart';
import 'dart:svg';
import 'code/crewStats.dart';
import 'code/Crew.dart';

NixieTube nixie;
AnalogueGague gague;
SevenSegmentDisplay leds;
SvgSvgElement nixieElement;
SvgSvgElement dialElement;
SvgSvgElement sevenSegmentElement;

DivElement output;
InputElement slider;
main() {

  nixie = new NixieTube(113, 200, "");
  nixieElement = nixie.graphicalDisplay();
  gague = new AnalogueGague(113, 200, true, true, "");
  dialElement = gague.graphicalDisplay();
  leds = new SevenSegmentDisplay(113, 200, "");
  sevenSegmentElement = leds.graphicalDisplay();

  output = querySelector('#output');
  slider = querySelector('#slider');

  slider.value = "113";
  slider.onInput.listen((e) => update(slider.value));
  output.append(nixieElement);
  output.append(sevenSegmentElement);
  output.appendHtml("</br>");
  output.append(dialElement);
  output.appendHtml("</br>");

  CrewStat.testStatRolls();
  testCrewNames();


}

Future<void> testCrewNames() async {
  Crew crew = await Crew.testAllCrewNames();
  output.append(await crew.getAllMemberDivs());
}

void update(String value) {
  nixie.value = int.parse(value);
  nixieElement = nixie.graphicalDisplay();

  gague.value = int.parse(value);
  dialElement = gague.graphicalDisplay();

  leds.value = int.parse(value);
  sevenSegmentElement = leds.graphicalDisplay();
  
  querySelector('#output').children.clear();
  querySelector('#output').append(nixieElement);
  querySelector('#output').appendHtml("</br>");
  querySelector('#output').append(dialElement);
  querySelector('#output').appendHtml("</br>");
  querySelector('#output').append(sevenSegmentElement);
}