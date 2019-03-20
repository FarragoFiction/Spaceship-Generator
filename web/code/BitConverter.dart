import 'dart:math';
import 'dart:core';

//MAKE ALL METHODS STATIC HERE PLEASE. it isnt too necessary but it is nice.
class BitConverter {
  static Map<int, String> HEXADECIMAL_DIGITS = {
    0 : "0",
    1 : "1",
    2 : "2",
    3 : "3",
    4 : "4",
    5 : "5",
    6 : "6",
    7 : "7",
    8 : "8",
    9 : "9",
    10: "A",
    11: "B",
    12: "C",
    13: "D",
    14: "E",
    15: "F",
  };


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
}