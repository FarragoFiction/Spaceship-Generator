import 'dart:html';
import 'dart:core';
import 'Display.dart';
import 'dart:svg';

NixieTube nixie;
SvgSvgElement svgElement;

DivElement output;
InputElement slider;
main() {
  nixie = new NixieTube(113, 200);
  svgElement = nixie.graphicalDisplay();
  DivElement output = querySelector('#output');
  InputElement slider = querySelector('#slider');

  slider.value = "113";
  slider.onInput.listen((e) => update(slider.value));
  output.append(svgElement);
}

void update(String value) {
  nixie.value = int.parse(value);
  svgElement = nixie.graphicalDisplay();
  
  querySelector('#output').children.clear();
  querySelector('#output').append(svgElement);
}