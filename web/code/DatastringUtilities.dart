import 'dart:math';
import 'dart:core';

//MAKE ALL METHODS STATIC HERE PLEASE. it isnt too necessary but it is nice.
class DatastringUtilities {
  static List<String> HEXADECIMAL_DIGITS = ["0", "1", "2", "3", "4", "5", "6",
    "7", "8", "9", "A", "B", "C", "D", "E", "F",];


  static String toUnsignedHexadecimal(List<bool> bits) {
    String ret = "";
    int bitsInSection;
    String debugBinary = "";
    if(bits.length > 4) {
      ret = toUnsignedHexadecimal(bits.sublist(0, bits.length - 4));
    }
    if(bits.length >= 4) {
      bitsInSection = 4;
    } else {
      bitsInSection = bits.length;
    }

    int value = 0;
    for(int i = 0; i < bitsInSection; i++) {
      if(bits[i + bits.length - bitsInSection]) {
        value += pow(2, bitsInSection - 1 - i);
        debugBinary += "1";
      } else
        debugBinary += "0";
    }
    //print("$debugBinary");

    ret = "$ret${HEXADECIMAL_DIGITS[value]}";
    return ret;
  }

  static List<bool> fromUnsignedHexadecimal(String hex) {
    List<bool> ret = new List<bool>();
    for(int i = 0; i < hex.length; i++) {
      String hexDigit = getCharAt(hex, i);
      int digitValue = HEXADECIMAL_DIGITS.indexOf(hexDigit);
      for(int j = 0; j < 4; j++) {
        if(digitValue ~/ pow(2, 3-j) > 0) {
          digitValue = digitValue % pow(2, 3-j);
          ret.add(true);
        } else {
          ret.add(false);
        }
      }
    }
    return(ret);
  }

  static String getCharAt(String string, int index) {
    if(index == string.length - 1) {
      return string.substring(string.length - 1);
    } else {
      return string.substring(index, index + 1);
    }
  }
}