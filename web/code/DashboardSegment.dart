import 'dart:svg';

export 'displays/Display.dart';
export 'FillerSVG.dart';

abstract class DashboardSegment {
  SvgSvgElement graphicalDisplay();
}