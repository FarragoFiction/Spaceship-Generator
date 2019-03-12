import 'dart:core';
import 'dart:svg';
import 'dart:math';

abstract class FillerSVG {
 SvgSvgElement getFiller();

}
/* filler elements:
buttons
switches
*/

class Switches implements FillerSVG {
 Random random;
 Switches(Random random) {
  this.random = random;
 }

 @override
 SvgSvgElement getFiller() {
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
   if(random.nextBool()) {
    switchPortion.setAttribute("cy", "${coordinates[1] + 25 - 12}");
   } else {
    switchPortion.setAttribute("cy", "${coordinates[1] + 25 + 12}");
   }
   ret.append(switchPortion);
  }
  return ret;
 }
}

class Buttons implements FillerSVG {
 Random random;
 Buttons(Random random) {
  this.random = random;
 }

 @override
 SvgSvgElement getFiller() {
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

  List<String> colors = [
   "#b35555", //red
   "#55b355", //green
   "#5555b3", //blue
   "#b3b355", //yellow
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


   base.setAttribute("fill", colors[random.nextInt(colors.length)]);
   ret.append(base);

  }
  return ret;
 }
}