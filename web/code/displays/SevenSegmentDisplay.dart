import 'Display.dart';
import 'dart:svg';



class SevenSegmentDisplay extends Display {
  static final int WIDTH_CONSTANT = 2;
  //static final

  static final Map<int, List<int>> SEGMENT_MAP = {
    -1: [], //nothing for this value
    0 : [0, 2, 3, 5, 6, 7, 8, 9],
    1 : [0, 4, 5, 6, 8, 9],
    2 : [0, 1, 2, 3, 4, 7, 8, 9],
    3 : [2, 3, 4, 5, 6, 8, 9],
    4 : [0, 2, 6, 8],
    5 : [0, 1, 3, 4, 5, 6, 7, 8, 9],
    6 : [0, 2, 3, 5, 6, 8, 9]
  };
  int value;
  int maxValue;

  SevenSegmentDisplay(int value, int maxValue){
    this.value = value;
    this.maxValue = maxValue;
  }

  @override
  int getValue(){
    return value;
  }

  @override
  int getMaxValue(){
    return maxValue;
  }

  @override
  SvgSvgElement graphicalDisplay() {


    SvgSvgElement ret = new SvgSvgElement();
    ret.setAttribute("height", "54");
    ret.setAttribute("width", "${30 * getNumOfDigits(maxValue)}");

    for(int i = 0; i < getNumOfDigits(maxValue); i++) {
      int digit = -1; //not a digit, so if the below conditions aren't met no segment will be lit
      if(getNumOfDigits(maxValue) - i > getNumOfDigits(maxValue) - getNumOfDigits(value)) {
        //print("${getNumOfDigits(maxValue)} - $i > ${getNumOfDigits(maxValue)} - ${getNumOfDigits(value)}");
        digit = int.parse(value.toString().substring(i, i + 1));
        //print(digit);
      }else if(getNumOfDigits(maxValue) - i == getNumOfDigits(maxValue) - getNumOfDigits(value) && getNumOfDigits(value) != 1){
        //print("${getNumOfDigits(maxValue)} - $i == ${getNumOfDigits(maxValue)} - ${getNumOfDigits(value)}");
        if(value == 0) {
          digit = 0;
        } else {
          digit = int.parse(value.toString().substring(0));
        }
        //print(digit);
      }

      int absX = 30 * i;
      for(int j = 0; j < 7; j++) {
        Segment segment;
        segment = Segment.makeSegmentForPortion(j, absX);
        bool isLit = false;
        if(SEGMENT_MAP[j].contains(digit))
          isLit = true;
        RectElement rect = segment.makeGraphical(isLit);
        ret.append(rect);
      }
    }
    return ret;
  }

  int getNumOfDigits(int number) {

    if(number.toString().length > 0) {
      return number.toString().length;
    }
    return 1;
  }
}

/*
    AA
   B  C
    DD
   E  F
    GG
    segments are 24 * 2, whole digit is 28 * 54.
 */
class Segment {
  bool isVertical;
  int startX;
  int startY;

  Segment(int startX, int startY, bool isVertical) {
    this.startX = startX;
    this.startY = startY;
    this.isVertical = isVertical;
  }

  RectElement makeGraphical(bool isLit) {
    RectElement ret = new RectElement();
    ret.setAttribute("x", "$startX");
    ret.setAttribute("y", "$startY");

    if(isVertical) {
      ret.setAttribute("width", "2");
      ret.setAttribute("height", "24");
    } else {
      ret.setAttribute("width", "24");
      ret.setAttribute("height", "2");
    }

    if(isLit) {
      ret.setAttribute("fill", "#00ff00");
    } else {
      ret.setAttribute("fill", "#111111");
    }

    return ret;
  }

  static Segment make0(int startX) {
    return new Segment(startX + 2, 0, false);
  }

  static Segment make1(int startX) {
    return new Segment(startX, 2, true);
  }

  static Segment make2(int startX) {
    return new Segment(startX + 26, 2, true);
  }

  static Segment make3(int startX) {
    return new Segment(startX + 2, 26, false);
  }

  static Segment make4(int startX) {
    return new Segment(startX, 28, true);
  }

  static Segment make5(int startX) {
    return new Segment(startX + 26, 28, true);
  }

  static Segment make6(int startX) {
    return new Segment(startX + 2, 52, false);
  }

  static Segment makeSegmentForPortion(int segmentId, int startX) {
    Segment ret;
    if(segmentId == 0)
      ret = make0(startX);
    if(segmentId == 1)
      ret = make1(startX);
    if(segmentId == 2)
      ret = make2(startX);
    if(segmentId == 3)
      ret = make3(startX);
    if(segmentId == 4)
      ret = make4(startX);
    if(segmentId == 5)
      ret = make5(startX);
    if(segmentId == 6)
      ret = make6(startX);
    return ret;
  }
}