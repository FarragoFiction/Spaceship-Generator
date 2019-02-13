import 'dart:html';
import 'dart:core';
import 'Display.dart';
import 'dart:svg';

NixieTube nixie;
Semicircle dial;
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

  dial = new Semicircle(113, 200, true, true);
  dialElement = dial.graphicalDisplay();
  output.append(dial.graphicalDisplay());

}

void update(String value) {
  nixie.value = int.parse(value);
  nixieElement = nixie.graphicalDisplay();

  dial.value = int.parse(value);
  dialElement = dial.graphicalDisplay();
  
  querySelector('#output').children.clear();
  querySelector('#output').append(nixieElement);
  querySelector('#output').appendHtml("</br>");
  querySelector('#output').append(dialElement);
}