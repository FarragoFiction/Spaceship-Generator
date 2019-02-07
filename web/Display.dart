import 'dart:html';
import 'dart:core';
import 'dart:math';
import 'Starship.dart';
import 'Room.dart';
import 'dart:svg';

abstract class Display {
  int getMaxValue();//maximum value the display can show
  int getValue(); //current value displayed by Display
  SvgSvgElement graphicalDisplay();

}

class NixieTube implements Display {
  int value;
  int maxValue;
  final int WIDTH_CONSTANT = 40;
  final int HEIGHT_CONSTANT = 51;

  NixieTube(int value, int maxValue) {
    this.value = value;
    this.maxValue = maxValue;
  }

  @override
  int getMaxValue() {
    return maxValue;
  }

  @override
  int getValue() {
    return value;
  }

  @override
  SvgSvgElement graphicalDisplay() {

    SvgSvgElement ret = new SvgSvgElement();

    //setup for glowing
    DefsElement defs = new DefsElement();
    FilterElement filter = new FilterElement();
    filter.id = "glow";

    FEGaussianBlurElement blurElement = new FEGaussianBlurElement();
    blurElement.setAttribute("stdDeviation", "0.75");

    filter.append(blurElement);
    defs.append(filter);
    ret.append(defs);


    //determine width by how many digits
    int width = getNumOfDigits(maxValue) * WIDTH_CONSTANT;

    ret.setAttribute("width", width.toString());
    ret.setAttribute("height", HEIGHT_CONSTANT.toString());

    //draw unlit display cells
    for(int i = 0; i <= 9; i++) {

      for(int j = 0; j < getNumOfDigits(maxValue) - 1; j++) {
        TextElement tex = new TextElement();
        tex.setAttribute("textLength", "$WIDTH_CONSTANT");
        tex.setAttribute("fill", "#555555");
        tex.setAttribute("font-size", "45");
        tex.setAttribute("font-family", "'Nixie One', monospace");
        tex.setAttribute("x", "${j * WIDTH_CONSTANT}");
        tex.setAttribute("y", "${HEIGHT_CONSTANT - 10}");
        tex.style.textAlign = "center";

        tex.text += "$i";

        ret.append(tex);
      }

    }





    //draw lit display cells
    for(int i = getNumOfDigits(value) - 1; i  >= 0; i--) {
      TextElement tex = new TextElement();
      tex.setAttribute("textLength", "${WIDTH_CONSTANT}");
      tex.setAttribute("fill", "#FF9900");
      tex.setAttribute("font-size", "45");
      tex.setAttribute("font-family", "'Nixie One', monospace");
      tex.style.textAlign = "center";
      tex.setAttribute("filter", "url(#glow)");

      tex.setAttribute("x", "${WIDTH_CONSTANT * i}");

      tex.setAttribute("y", "${HEIGHT_CONSTANT - 10}");
      if(i + 1 == getNumOfDigits(value)) {
        tex.text = "${value.toString().substring(i)}";
      } else {
        tex.text = "${value.toString().substring(i, i+1)}";
      }

      //make it glow


      ret.append(tex);
    }







    return ret;

  }

  int getNumOfDigits(int number) {
    if(number / 10 > 0) {
      int ret = (number / 10).toInt();
      return 1 + getNumOfDigits(ret);
    }
    return 1;
  }
}

