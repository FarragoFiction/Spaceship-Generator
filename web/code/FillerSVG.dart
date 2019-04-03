import 'dart:core';
import 'dart:svg';
import 'dart:math';
import 'DashboardSegment.dart';

abstract class FillerSVG extends DashboardSegment{}
/* filler elements:
buttons
switches
*/

class Switches implements FillerSVG {
 List<bool> toggleStates;

 static Switches randomSwitches(Random random) {
   return new Switches(randomToggleStates(random));
 }

 Switches(List<bool> toggleStates) {
  this.toggleStates = toggleStates;
 }


 @override
 SvgSvgElement graphicalDisplay() {
  SvgSvgElement ret = new SvgSvgElement();
  ret.setAttribute("height", "100");
  ret.setAttribute("width", "150");

  List<List<int>> availableCoordinates = [
   [0,0],
   [50,0],
   [100,0],
   [0,50],
   [50,50],
   [100,50]
  ];
  for(int i = 0; i < availableCoordinates.length; i++) {
   //draw base of switch
   List<int> coordinates = availableCoordinates[i];
   CircleElement base = new CircleElement();
   base.setAttribute("cx", "${coordinates[0] + 25}");
   base.setAttribute("cy", "${coordinates[1] + 25}");
   base.setAttribute("r", "10");
   base.setAttribute("stroke", "#555555");
   base.setAttribute("stroke-width", "7");
   base.setAttribute("fill", "#000000");
   ret.append(base);

   //draw switch portion
   EllipseElement switchPortion = new EllipseElement();
   switchPortion.setAttribute("cx", "${coordinates[0] + 25}");
   switchPortion.setAttribute("rx", "3");
   switchPortion.setAttribute("ry", "12");
   switchPortion.setAttribute("fill", "#CCCCCC");
   if(toggleStates[i]) {
    switchPortion.setAttribute("cy", "${coordinates[1] + 25 - 12}");
   } else {
    switchPortion.setAttribute("cy", "${coordinates[1] + 25 + 12}");
   }
   ret.append(switchPortion);
  }
  return ret;
 }

 static List<bool> randomToggleStates(Random random) {
   List<bool> toggleStates = [];
   for(int i = 0; i < 6; i++) {
     toggleStates.add(random.nextBool());
   }
   return toggleStates;
 }
}

class Buttons implements FillerSVG {
 List<int> colorStates;
 static final List<String> COLORS = [
  "#b35555", //red
  "#55b355", //green
  "#5555b3", //blue
  "#b3b355", //yellow
 ];

 static Buttons randomButtons(Random random) {
  List<int> colorStates = randomColorStates(random);
  return new Buttons(colorStates);
 }

 Buttons(List<int> colorStates){
   this.colorStates = colorStates;
 }

 @override
 SvgSvgElement graphicalDisplay() {
  SvgSvgElement ret = new SvgSvgElement();
  ret.setAttribute("height", "100");
  ret.setAttribute("width", "150");

  List<List<int>> availableCoordinates = [
   [0,0],
   [50,0],
   [100,0],
   [0,50],
   [50,50],
   [100,50]
  ];

  for(int i = 0; i < availableCoordinates.length; i++) {
   //draw base of button
   List<int> coordinates = availableCoordinates[i];
   CircleElement base = new CircleElement();
   base.setAttribute("cx", "${coordinates[0] + 25}");
   base.setAttribute("cy", "${coordinates[1] + 25}");
   base.setAttribute("r", "17");
   base.setAttribute("stroke", "#555555");
   base.setAttribute("stroke-width", "5");

   base.setAttribute("fill", COLORS[colorStates[i]]);
   ret.append(base);


  }
  //print(colorStates);
  return ret;
 }

 static List<int> randomColorStates(Random random) {
   List<int> ret = [];
   for(int i = 0; i < 6; i++) {
     int color = random.nextInt(COLORS.length);
     ret.add(color);
   }
   return ret;
 }

}