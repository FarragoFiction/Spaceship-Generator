import 'dart:html';
import 'dart:core';
import 'Display.dart';
import 'dart:svg';

NixieTube nixie;
AnalogueGague gague;
SvgSvgElement nixieElement;
SvgSvgElement dialElement;

DivElement output;
InputElement slider;
main() {
  nixie = new NixieTube(113, 200);
  nixieElement = nixie.graphicalDisplay();
  DivElement output = querySelector('#output');
  InputElement slider = querySelector('#slider');

  slider.value = "113";
  slider.onInput.listen((e) => update(slider.value));
  output.append(nixieElement);
  output.appendHtml("</br>");

  gague = new AnalogueGague(113, 200, true, true);
  dialElement = gague.graphicalDisplay();
  output.append(gague.graphicalDisplay());

}

void update(String value) {
  nixie.value = int.parse(value);
  nixieElement = nixie.graphicalDisplay();

  gague.value = int.parse(value);
  dialElement = gague.graphicalDisplay();
  
  querySelector('#output').children.clear();
  querySelector('#output').append(nixieElement);
  querySelector('#output').appendHtml("</br>");
  querySelector('#output').append(dialElement);
}