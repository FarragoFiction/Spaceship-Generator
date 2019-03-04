import 'Display.dart';
import 'dart:svg';
import 'dart:math';

//todo visually: make needle thicker, make bar thicker, add tick marks
class AnalogueGague implements Display {
  int value;
  int maxValue;
  bool needle;
  bool bar;

  AnalogueGague(int value, int maxValue, bool needle, bool bar) {
    this.value = value;
    this.maxValue = maxValue;
    this.needle = needle;
    this.bar = bar;
  }

  @override
  int getMaxValue(){
    return maxValue;
  }

  @override
  int getValue(){
    return value;
  }


  @override
  SvgSvgElement graphicalDisplay(){
    SvgSvgElement ret = new SvgSvgElement();
    ret.setAttribute("width", "150");
    ret.setAttribute("height", "75");

    //add empty circle
    PathElement panel = new PathElement();
    panel.setAttribute("d", "M 0 75"
        " A 75 75 0 0 1 150 75");
    panel.setAttribute("fill", "#555555");
    ret.append(panel);

    //add tick marks
    for(int i = 0; i <= 10; i++) {
      double tickXStart = 75 * (1 - cos(PI * i / 10));
      double tickXStop = 75 * (1 - .9 * cos(PI * i / 10));

      double tickYStart = 75 * (1 - sin(PI * i / 10));
      double tickYStop = 75 * (1 - .9 * sin(PI * i / 10));

      PathElement tickMark = new PathElement();
      tickMark.setAttribute("d", "M $tickXStart $tickYStart L $tickXStop $tickYStop");
      tickMark.setAttribute("stroke", "white");
      ret.append(tickMark);
    }


    double stopX = 75 * (1 - .9 * cos(PI * value/maxValue));
    double stopY = 75 * (1 - .9 * sin(PI * value/maxValue));

    //add the display portion
    if(bar) {
      PathElement barDisp = new PathElement();
      barDisp.setAttribute("d", "M ${75 - 75 * 0.9} 75"
          " A ${75 * 0.9} ${75 * 0.9} 0 0 1 $stopX $stopY");
      //SVG paths are bullshit. here is your cheat code future me:
      //startX, startY, rotation, flag1, flag2, stopX, stopY
      barDisp.setAttribute("fill", "transparent");
      barDisp.setAttribute("stroke", "green");
      barDisp.setAttribute("stroke-width", "5");
      ret.append(barDisp);
    }
    if(needle) {
      PathElement needleDisp = new PathElement();
      needleDisp.setAttribute("d", "M 75 75 L $stopX $stopY");
      needleDisp.setAttribute("stroke", "red");
      needleDisp.setAttribute("stroke-width", "2");
      ret.append(needleDisp);
    }
    print("($stopX, $stopY)");
    return ret;
  }


}