import 'Display.dart';
import 'dart:svg';
import 'dart:math';

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

    double stopX = 75 *(1 - cos(PI * value/maxValue));
    double stopY = 75* (1 - sin(PI * value/maxValue));


    if(bar) {
      PathElement barDisp = new PathElement();
      barDisp.setAttribute("d", "M 0 75"
          " A 75 75 0 0 1 $stopX $stopY");
      //SVG paths are bullshit. here is your cheat code future hudson:
      //startX, startY, rotation, flag1, flag2, stopX, stopY
      barDisp.setAttribute("fill", "transparent");
      barDisp.setAttribute("stroke", "green");
      ret.append(barDisp);
    }
    if(needle) {
      PathElement needleDisp = new PathElement();
      needleDisp.setAttribute("d", "M 75 75 L $stopX $stopY");
      needleDisp.setAttribute("stroke", "red");
      ret.append(needleDisp);
    }
    print("($stopX, $stopY)");
    return ret;
  }


}