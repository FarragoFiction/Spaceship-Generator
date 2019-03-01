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
  -rolling numbers/mechanical counter (would this be noticeable enough to show?)
  -dot matrix display

  3 is okay for test purposes though

  modifications:
  -ability to specify size of graphicalDisplay(), or at least make them all consistent
  -specify color
  -make them all look nice
 */
