import 'dart:core';
import 'dart:svg';

export 'AnalogueGague.dart';
export 'NixieTube.dart';
export 'SevenSegmentDisplay.dart';

abstract class Display {
  int getMaxValue();//maximum value the display can show
  int getValue(); //current value displayed by Display
  SvgSvgElement graphicalDisplay();

}





/*todo list for display types:
  -alien display(s)(?)
  -progress bar
  -rolling numbers
  -7-segment display
  -dot segment display
 */

