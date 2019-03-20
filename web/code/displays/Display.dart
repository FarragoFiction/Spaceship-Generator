import 'dart:core';
import 'dart:svg';
import '../DashboardSegment.dart';

export 'AnalogueGague.dart';
export 'NixieTube.dart';
export 'SevenSegmentDisplay.dart';

final int NEEDLE_GAUGE_ID = 0;
final int BAR_GAUGE_ID = 1;
final int NIXIE_ID = 2;
final int SEVEN_SEGMENT_ID = 3;

abstract class Display extends DashboardSegment {
  int getMaxValue();//maximum value the display can show
  int getValue(); //current value displayed by Display
  int getTypeId(); //so i know what my id is
  String getLabel();

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
