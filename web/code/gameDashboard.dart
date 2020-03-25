import 'dart:html';
import 'dart:svg' as Svg;
import 'dart:math' as Math;
import 'DashboardSegment.dart';
import 'Starship.dart';
import 'Dashboard.dart';
import 'DatastringUtilities.dart';

class GameDashboard extends Dashboard {
  GameDashboard(Starship starship) :super(starship);



  DivElement buildGameDashboard() {
    DivElement ret = new DivElement();
    DivElement canvasDiv = new DivElement();
    canvasDiv.style.position = "absolute";
    canvasDiv.style.zIndex = "0";
    CanvasElement canvas = new CanvasElement();
    canvas.width = Dashboard.WIDTH;
    canvas.height = Dashboard.HEIGHT;
    CanvasRenderingContext2D ctx = canvas.context2D;

    drawBackground(ctx);
    drawStars(ctx);//todo overwrite method to adjust for consistency
    drawFrame(ctx);

    //todo this is the part where you draw the displays.
    ret.append(drawGameDisplays());

    canvasDiv.append(canvas);
    ret.append(canvasDiv);
    return ret;
  }

  DivElement drawGameDisplays() {
    DivElement ret = new DivElement();
    ret.style.position = "absolute";
    ret.style.zIndex = "1";

    ret.append(drawCommsButton());
    ret.append(drawFuelGague());
    ret.append(drawHullGague());
    ret.append(drawCurrencyCounter());
    ret.append(drawCrewShipSwitch());

    return ret;
  }

  //todo refactor the name sfor all these
  
  DivElement drawCommsButton() {
    //todo: comms button needs to be interactive.
    DivElement ret = new DivElement();
    List<int> coordinates = Dashboard.SEGMENT_STARTING_POINTS[0];
    Buttons commButton = new Buttons([2, 0, 0, 2, 0, 0]); //todo make a custom part for this

    Svg.SvgSvgElement commSvg = commButton.graphicalDisplay();
    segments[coordinates[2]] = commButton;
    int x = coordinates[0] +
        (Dashboard.SEGMENT_WIDTH - int.parse(commSvg.getAttribute("width"))) ~/ 2;
    int y = coordinates[1] +
        (Dashboard.SEGMENT_WIDTH - int.parse(commSvg.getAttribute("height"))) ~/ 2;

    commSvg.style.position = "absolute";
    commSvg.style.top = "${y}px";
    commSvg.style.left = "${x}px";

    ret.append(commSvg);
    return ret;
  }

  DivElement drawFuelGague() {
    //todo fuel gague should keep track of a fuel stat.
    DivElement ret = new DivElement();
    List<int> coordinates = Dashboard.SEGMENT_STARTING_POINTS[1];
    AnalogueGague retSegment = AnalogueGague(50, 100, true, false, "fuel");

    Svg.SvgSvgElement retSvg = retSegment.graphicalDisplay();
    segments[coordinates[2]] = retSegment;
    int x = coordinates[0] +
        (Dashboard.SEGMENT_WIDTH - int.parse(retSvg.getAttribute("width"))) ~/ 2;
    int y = coordinates[1] +
        (Dashboard.SEGMENT_WIDTH - int.parse(retSvg.getAttribute("height"))) ~/ 2;

    ret.style.position = "absolute";
    ret.style.top = "${y}px";
    ret.style.left = "${x}px";

    ret.append(retSvg);
    ret.appendText(retSegment.label);
    return ret;
  }

  DivElement drawHullGague() {
    //todo hull gague should be hit points of some sort.
    DivElement ret = new DivElement();
    List<int> coordinates = Dashboard.SEGMENT_STARTING_POINTS[2];
    AnalogueGague retSegment = AnalogueGague(50, 100, false, true, "hull strength");

    Svg.SvgSvgElement retSvg = retSegment.graphicalDisplay();
    segments[coordinates[2]] = retSegment;
    int x = coordinates[0] +
        (Dashboard.SEGMENT_WIDTH - int.parse(retSvg.getAttribute("width"))) ~/ 2;
    int y = coordinates[1] +
        (Dashboard.SEGMENT_WIDTH - int.parse(retSvg.getAttribute("height"))) ~/ 2;

    ret.style.position = "absolute";
    ret.style.top = "${y}px";
    ret.style.left = "${x}px";

    ret.append(retSvg);
    ret.appendText(retSegment.label);
    return ret;
  }

  DivElement drawCurrencyCounter() {
    //todo currency counter. what does segundia use again?
    DivElement ret = new DivElement();
    List<int> coordinates = Dashboard.SEGMENT_STARTING_POINTS[4];
    NixieTube retSegment = new NixieTube(113, 999, "Currency");

    Svg.SvgSvgElement retSvg = retSegment.graphicalDisplay();
    segments[coordinates[2]] = retSegment;
    int x = coordinates[0] +
        (Dashboard.SEGMENT_WIDTH - int.parse(retSvg.getAttribute("width"))) ~/ 2;
    int y = coordinates[1] +
        (Dashboard.SEGMENT_WIDTH - int.parse(retSvg.getAttribute("height"))) ~/ 2;

    ret.style.position = "absolute";
    ret.style.top = "${y}px";
    ret.style.left = "${x}px";

    ret.append(retSvg);
    ret.appendText(retSegment.label);
    return ret;
  }

  DivElement drawCrewShipSwitch() {
    //todo ship/crew switch. should toggle the display between showing crew data and ship data.
    DivElement ret = new DivElement();
    List<int> coordinates = Dashboard.SEGMENT_STARTING_POINTS[18];
    Switches retSegment = Switches([false, true, false, false, true, false]); //todo make a custom part for this

    Svg.SvgSvgElement retSvg = retSegment.graphicalDisplay();
    segments[coordinates[2]] = retSegment;
    int x = coordinates[0] +
        (Dashboard.SEGMENT_WIDTH - int.parse(retSvg.getAttribute("width"))) ~/ 2;
    int y = coordinates[1] +
        (Dashboard.SEGMENT_WIDTH - int.parse(retSvg.getAttribute("height"))) ~/ 2;

    ret.style.position = "absolute";
    ret.style.top = "${y}px";
    ret.style.left = "${x}px";

    ret.append(retSvg);
    return ret;
  }

}