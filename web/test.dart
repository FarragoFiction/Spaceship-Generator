import 'dart:html';
import 'dart:core';
import 'displays/Display.dart';
import 'dart:svg';

NixieTube nixie;
AnalogueGague gague;
SevenSegmentDisplay leds;
SvgSvgElement nixieElement;
SvgSvgElement dialElement;
SvgSvgElement sevenSegmentElement;

DivElement output;
InputElement slider;
main() {
  nixie = new NixieTube(113, 200);
  nixieElement = nixie.graphicalDisplay();
  gague = new AnalogueGague(113, 200, true, true);
  dialElement = gague.graphicalDisplay();
  leds = new SevenSegmentDisplay(113, 200);
  sevenSegmentElement = leds.graphicalDisplay();

  DivElement output = querySelector('#output');
  InputElement slider = querySelector('#slider');

  slider.value = "113";
  slider.onInput.listen((e) => update(slider.value));
  output.append(nixieElement);
  output.appendHtml("</br>");
  output.append(dialElement);
  output.appendHtml("</br>");
  output.append(sevenSegmentElement);
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