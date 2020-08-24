import 'dart:html';
import 'dart:svg' as Svg;
import 'dart:math' as Math;
import 'DashboardSegment.dart';
import 'Starship.dart';
import 'Dashboard.dart';
import 'DatastringUtilities.dart';
import 'Starmap.dart';

class GameDashboard extends Dashboard {
  List<Point<num>> starDrawCoords;
  GameDashboard(Starship starship) :super(starship) {
    starDrawCoords = [];
  }



  DivElement buildGameDashboard(Starmap starmap, int oldLocation, int newLocation) {
    DivElement ret = new DivElement();
    DivElement canvasDiv = new DivElement();
    canvasDiv.style.position = "absolute";
    canvasDiv.style.zIndex = "0";
    CanvasElement canvas = new CanvasElement();
    canvas.width = Dashboard.WIDTH;
    canvas.height = Dashboard.HEIGHT;
    CanvasRenderingContext2D ctx = canvas.context2D;

    drawBackground(ctx);
    drawStarsFromMap(ctx, starmap);//todo overwrite method to adjust for consistency
    drawHighlightAndTrace(ctx, oldLocation, newLocation, starmap);
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

    //ret.append(drawCommsButton());
    //ret.append(drawFuelGague());
    //ret.append(drawHullGague());
    //ret.append(drawCurrencyCounter());
    //ret.append(drawCrewShipSwitch());

    return ret;
  }
  
  DivElement drawCommsButton() {
    //todo: comms button needs to be interactive.
    DivElement ret = new DivElement();
    List<int> coordinates = Dashboard.SEGMENT_STARTING_POINTS[0];
    Buttons commButton = new OneButton(1);

    Svg.SvgSvgElement commSvg = commButton.graphicalDisplay();
    segments[coordinates[2]] = commButton;
    int x = coordinates[0] +
        (Dashboard.SEGMENT_WIDTH - int.parse(commSvg.getAttribute("width"))) ~/ 2;
    int y = coordinates[1] +
        (Dashboard.SEGMENT_WIDTH - int.parse(commSvg.getAttribute("height"))) ~/ 2;

    ret.style.position = "absolute";
    ret.style.top = "${y}px";
    ret.style.left = "${x}px";

    //label: Communicator
    SpanElement commLabel = new SpanElement();
    commLabel.appendText("Communicator");
    commLabel.style.fontSize = "12px";
    commLabel.style.position = "absolute";
    commLabel.style.top = "45px";
    commLabel.style.left = "50px";


    ret.append(commSvg);
    ret.append(commLabel);
    return ret;
  }

  DivElement drawFuelGague(int value) {
    //todo fuel gague should keep track of a fuel stat.
    DivElement ret = new DivElement();
    List<int> coordinates = Dashboard.SEGMENT_STARTING_POINTS[1];
    AnalogueGague retSegment = AnalogueGague(value, 100, true, false, "fuel");

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
    ret.appendHtml("<br>");
    ret.appendText(retSegment.label);
    return ret;
  }

  DivElement drawHullGague(int value) {
    //todo hull gague should be hit points of some sort.
    DivElement ret = new DivElement();
    List<int> coordinates = Dashboard.SEGMENT_STARTING_POINTS[2];
    AnalogueGague retSegment = AnalogueGague(value, 100, false, true, "hull strength");

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
    ret.appendHtml("<br>");
    ret.appendText(retSegment.label);
    return ret;
  }

  DivElement drawCurrencyCounter(int value) {
    //todo currency counter. what does segundia use again?
    DivElement ret = new DivElement();
    List<int> coordinates = Dashboard.SEGMENT_STARTING_POINTS[4];
    NixieTube retSegment = new NixieTube(value, 999, "Currency");

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
    ret.appendHtml("<br>");
    ret.appendText(retSegment.label);
    return ret;
  }

  DivElement drawCrewShipSwitch(bool toggleState) {
    //todo ship/crew switch. should toggle the display between showing crew data and ship data.
    DivElement ret = new DivElement();
    List<int> coordinates = Dashboard.SEGMENT_STARTING_POINTS[18];
    Switches retSegment = OneSwitch(toggleState); //todo make a custom part for this

    Svg.SvgSvgElement retSvg = retSegment.graphicalDisplay();
    segments[coordinates[2]] = retSegment;
    int x = coordinates[0] +
        (Dashboard.SEGMENT_WIDTH - int.parse(retSvg.getAttribute("width"))) ~/ 2;
    int y = coordinates[1] +
        (Dashboard.SEGMENT_WIDTH - int.parse(retSvg.getAttribute("height"))) ~/ 2;

    ret.style.position = "absolute";
    ret.style.top = "${y}px";
    ret.style.left = "${x}px";

    //label 1: ship data
    SpanElement shipLabel = new SpanElement();
    shipLabel.appendText("SHIP");
    shipLabel.style.position = "absolute";
    shipLabel.style.top = "40px";
    shipLabel.style.left = "5px";

    //label 2: ship data
    SpanElement crewLabel = new SpanElement();
    crewLabel.appendText("CREW");
    crewLabel.style.position = "absolute";
    crewLabel.style.top = "40px";
    crewLabel.style.left = "100px";

    //svg position
    retSvg.style.position = "absolute";
    retSvg.style.top = "0px";
    retSvg.style.left = "0px";

    ret.append(shipLabel);
    ret.append(crewLabel);
    ret.append(retSvg);
    //return retSvg;
    return ret;
  }



  void drawStarsFromMap(CanvasRenderingContext2D ctx, Starmap spacemap) {
    Math.Random random = new Math.Random(starship.getId());

    for (int i = 0; i < spacemap.stars.length; i++) {
      Star star = spacemap.stars[i];
      int x = ((star.coordinates[0]/spacemap.mapDimension) * Dashboard.WIDTH).toInt();
      int y = ((star.coordinates[1]/spacemap.mapDimension) * Dashboard.HEIGHT).toInt();
      int r = 1 + ((star.coordinates[2]/spacemap.mapDimension) * 5).toInt();//1 + random.nextInt(3);
      starDrawCoords.add(new Point(x, y));
      //todo make star colors for each
      ctx.fillStyle = Dashboard.STAR_COLORS[random.nextInt(Dashboard.STAR_COLORS.length)];
      ctx.beginPath();
      ctx.arc(x, y, r, 0, 2 * Math.pi);
      ctx.fill();
    }
  }

  //draws an icon to highlight your current location, and draws a line to the next one if you're travelling there.
  void drawHighlightAndTrace(CanvasRenderingContext2D ctx, int oldLocation, int newLocation, Starmap spacemap) {
    Star oldStar = spacemap.stars[oldLocation];
    Star newStar = spacemap.stars[newLocation];

    int startX = ((oldStar.coordinates[0]/spacemap.mapDimension) * Dashboard.WIDTH).toInt();
    int startY = ((oldStar.coordinates[1]/spacemap.mapDimension) * Dashboard.WIDTH).toInt();

    ctx.fillStyle = "#FF0000";
    ctx.ellipse(startX, startY, 3, 3, 0, 0, 0, true);
    ctx.fill();
  }
}