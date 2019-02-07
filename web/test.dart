import 'dart:html';
import 'dart:core';
import 'Display.dart';
import 'dart:svg';

main() {
  NixieTube nixie = new NixieTube(1234567890, 1234567890);
  SvgSvgElement svgElement = nixie.graphicalDisplay();
  querySelector('#output').append(svgElement);
}