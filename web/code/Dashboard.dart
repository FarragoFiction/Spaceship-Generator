import 'dart:html';
import 'dart:svg' as Svg;
import 'dart:math' as Math;
import 'DashboardSegment.dart';
import 'Starship.dart';
import 'DatastringUtilities.dart';

class Dashboard {
  static final int WIDTH = 1200;
  static final int HEIGHT = 800;

  static final int SEGMENT_WIDTH = 160;
  static final int SEGMENT_HEIGHT = 100;
  static final List<String> STAR_COLORS = [
    "#FFFFFF",
    "#FFFFCC",
    "#FFCCFF",
    "#CCFFFF",
    "#CCFFCC",
    "#FFCCCC",
    "#CCCCFF",
  ];

  static final List<List<int>> SEGMENT_STARTING_POINTS = [ //todo jesus, make a map
    //list of the coordinates i can start drawing displays in
    //and their index in THIS list because im dummy stupid
    [0, 0, 0],
    [0, 100, 1],
    [0, 200, 2],
    [0, 300, 3],
    [0, 400, 4],
    [0, 500, 5],
    [0, 650, 6],
    [171, 650, 7],
    [343, 650, 8],
    [514, 650, 9],
    [686, 650, 10],
    [858, 650, 11],
    [1039, 650, 12],
    [1039, 500, 13],
    [1039, 400, 14],
    [1039, 300, 15],
    [1039, 200, 16],
    [1039, 100, 17],
    [1039, 0, 18],
  ];

  List<DashboardSegment> segments = new List(19);

  Starship starship;

  Dashboard(Starship starship) {
    this.starship = starship;
  }

  DivElement buildRandomDashboard() {
    DivElement ret = new DivElement();
    //ret.style.position = "relative";

    DivElement canvasDiv = new DivElement();
    canvasDiv.style.position = "absolute";
    canvasDiv.style.zIndex = "0";
    CanvasElement canvas = new CanvasElement();
    canvas.width = WIDTH;
    canvas.height = HEIGHT;
    CanvasRenderingContext2D ctx = canvas.context2D;

    drawBackground(ctx);
    drawStars(ctx);
    drawFrame(ctx);
    ret.append(drawRandomDisplays());

    canvasDiv.append(canvas);
    ret.append(canvasDiv);
    return ret;
  }

  DivElement buildCustomDashboard(String datastring) {
    DivElement ret = new DivElement();
    //ret.style.position = "relative";

    DivElement canvasDiv = new DivElement();
    canvasDiv.style.position = "absolute";
    canvasDiv.style.zIndex = "0";
    CanvasElement canvas = new CanvasElement();
    canvas.width = WIDTH;
    canvas.height = HEIGHT;
    CanvasRenderingContext2D ctx = canvas.context2D;

    drawBackground(ctx);
    drawStars(ctx);
    drawFrame(ctx);
    ret.append(drawCustomDisplays(datastring));

    canvasDiv.append(canvas);
    ret.append(canvasDiv);
    return ret;
  }

  CanvasRenderingContext2D drawBackground(CanvasRenderingContext2D ctx) {
    ctx.setFillColorRgb(0, 0, 0);
    ctx.fillRect(0, 0, WIDTH, HEIGHT);
    return ctx;
  }

  //draw a random number of stars in random areas. randomly choose their color from a bunch of pastels.
  void drawStars(CanvasRenderingContext2D ctx) {
    Math.Random random = new Math.Random(starship.getId());
    for (int i = 0; i <= 15 + random.nextInt(50); i++) {
      int x = random.nextInt(WIDTH);
      int y = random.nextInt(HEIGHT);
      int r = 1 + random.nextInt(3);

      ctx.fillStyle = STAR_COLORS[random.nextInt(STAR_COLORS.length)];
      ctx.beginPath();
      ctx.arc(x, y, r, 0, 2 * Math.pi);
      ctx.fill();
    }
  }

  CanvasRenderingContext2D drawFocus(CanvasRenderingContext2D ctx) {}

  CanvasRenderingContext2D drawWindow(CanvasRenderingContext2D ctx) {}

  CanvasRenderingContext2D drawFrame(CanvasRenderingContext2D ctx) {
    String casingColor = "#a6a6a6";
    String seamColor = "#808080";

    ctx.fillStyle = seamColor;

    ctx.fillRect(0, HEIGHT - 140, WIDTH, 100);
    ctx.fillRect(0, 0, 180, HEIGHT);
    ctx.fillRect(WIDTH - 180, 0, 160, HEIGHT);

    ctx.fillStyle = casingColor;

    //ctx.fillRect(0, 0, WIDTH, 100);
    ctx.fillRect(0, HEIGHT - 120, WIDTH, 120);
    ctx.fillRect(0, 0, 160, HEIGHT);
    ctx.fillRect(WIDTH - 160, 0, 160, HEIGHT);
    return ctx;
  }

  //assume they fit in 160 x 100 size area
  //should be room for 19 displays
  DivElement drawRandomDisplays() {

    DivElement ret = new DivElement();
    ret.style.position = "absolute";
    ret.style.zIndex = "1";

    List<List<int>> availableStartingPoints = SEGMENT_STARTING_POINTS;

    Math.Random rand = new Math.Random(starship.getId());
    int displayCutoff = rand.nextInt(availableStartingPoints.length);

    //setup labels
    List<String> labels = new List<String>();
    labels.addAll(starship.dashboardLabels);

    //setup the main displays
    for (int i = 0; i < displayCutoff; i++) {
      DivElement wrapper = new DivElement();
      int index = rand.nextInt(availableStartingPoints.length);

      List<int> coordinates = availableStartingPoints.removeAt(index);

      //add a label
      int labelIndex = rand.nextInt(labels.length);
      String label = labels[labelIndex];
      labels.removeAt(labelIndex);

      Display display =
          makeDisplay(rand.nextInt(4), rand.nextInt(101), 100, label);

      segments[coordinates[2]] = display;

      //make the svg
      Svg.SvgSvgElement svg = display.graphicalDisplay();
      wrapper.style.position = "absolute";
      //print(svg.getAttribute("height"));
      int x = coordinates[0] +
          (SEGMENT_WIDTH - int.parse(svg.getAttribute("width"))) ~/ 2;
      int y = coordinates[1] +
          (SEGMENT_WIDTH - int.parse(svg.getAttribute("height"))) ~/ 2;
      wrapper.style.top = "${y}px";
      wrapper.style.left = "${x}px";
      wrapper.append(svg);

      //String label = temporaryFlavorLabels[rand.nextInt(temporaryFlavorLabels.length)];

      wrapper.appendText(label);
      ret.append(wrapper);
    }

    //add filler elements
    while (availableStartingPoints.length > 0) {
      int spotInOrder = rand.nextInt(availableStartingPoints.length);
      List<int> coordinates = availableStartingPoints.removeAt(spotInOrder);

      //determine what kind of filler
      int type = rand.nextInt(2);
      if (type == 0) {
        Buttons filler =  Buttons.randomButtons(rand);

        Svg.SvgSvgElement fillerSvg = filler.graphicalDisplay();
        segments[coordinates[2]] = filler;

        //print(encodeDatastringOfSegment(filler));

        int x = coordinates[0] +
            (SEGMENT_WIDTH - int.parse(fillerSvg.getAttribute("width"))) ~/ 2;
        int y = coordinates[1] +
            (SEGMENT_WIDTH - int.parse(fillerSvg.getAttribute("height"))) ~/ 2;

        fillerSvg.style.position = "absolute";
        fillerSvg.style.top = "${y}px";
        fillerSvg.style.left = "${x}px";

        ret.append(fillerSvg);
      } else if (type == 1) {
        Switches filler = Switches.randomSwitches(rand);

        Svg.SvgSvgElement fillerSvg = filler.graphicalDisplay();
        segments[coordinates[2]] = filler;

        //print(encodeDatastringOfSegment(filler));
        int x = coordinates[0] +
            (SEGMENT_WIDTH - int.parse(fillerSvg.getAttribute("width"))) ~/ 2;
        int y = coordinates[1] +
            (SEGMENT_WIDTH - int.parse(fillerSvg.getAttribute("height"))) ~/ 2;

        fillerSvg.style.position = "absolute";
        fillerSvg.style.top = "${y}px";
        fillerSvg.style.left = "${x}px";

        ret.append(fillerSvg);
      }
    }

    return ret;
  }


  DivElement drawCustomDisplays(String datastring) {
    DivElement ret = new DivElement();
    ret.style.position = "absolute";
    ret.style.zIndex = "1";

    List<String> splitDatastrings = splitDatastring(datastring);
    print(splitDatastrings);
    //setup the main displays
    for (int i = 0; i < 19; i++) {
      DivElement wrapper = new DivElement();

      List<int> coordinates = SEGMENT_STARTING_POINTS[i];

      //TODO SPLIT THE DATASTRING
      DashboardSegment display = decodeDatastringOfSegment(splitDatastrings[i]);

      segments[coordinates[2]] = display;

      //make the svg
      Svg.SvgSvgElement svg = display.graphicalDisplay();
      wrapper.style.position = "absolute";
      //print(svg.getAttribute("height"));
      int x = coordinates[0] +
          (SEGMENT_WIDTH - int.parse(svg.getAttribute("width"))) ~/ 2;
      int y = coordinates[1] +
          (SEGMENT_WIDTH - int.parse(svg.getAttribute("height"))) ~/ 2;
      wrapper.style.top = "${y}px";
      wrapper.style.left = "${x}px";
      wrapper.append(svg);

      //String label = temporaryFlavorLabels[rand.nextInt(temporaryFlavorLabels.length)];
      if(display is Display) {
        String label = display.getLabel();
        wrapper.appendText(label);
      }
      ret.append(wrapper);
    }

    return ret;
  }

  //TODO make this use the constatns
  static Display makeDisplay(int id, num value, num maxValue, String label) {
    if (id == 0) return new AnalogueGague(value, maxValue, true, false, label);
    if (id == 1) return new AnalogueGague(value, maxValue, false, true, label);
    if (id == 2) return new NixieTube(value, maxValue, label);
    if (id == 3) return new SevenSegmentDisplay(value, maxValue, label);
    return null;
  }

  /*paraphrased notes from JR about datastrings:
-take shortcuts where you can, but beware of the ways they can limit you
-you can store booleans as a single bit and then pack multiple bits together into a byte (8 bits)
 */
  /*
  So for these datastrings I think im good, but the dashboard ones maybe not.
  Most of the space is gonna be occupied by strings, but I can simplify everything else.
 */
  /*
  if the first character is one of the following it's a display.
    0: analogue gague with needle
    1: analogue gague with bar
    2: nixie tube
    3: seven segment display

  the next two characters are it's value.
  BE SURE TO ENCODE SINGLE DIGIT VALUES WITH A 0 IN FRONT OF THEM.
  after that, it's the display label. just a plain string.

   */
  static String encodeDatastringOfSegment(DashboardSegment segment) {
    String ret;

    if (segment is Display) {
      //what am I? [0]
      ret = "${segment.getTypeId()}";
      //what is my value? [1-2]
      if (segment.getValue() < 10) {
        ret += "00${segment.getValue()}";
      } else if (segment.getValue() < 100) {
        ret += "0${segment.getValue()}";
      } else {
        ret += "${segment.getValue()}";
      }
      //what is my name? [3-n]
      ret += segment.getLabel();
    } else if (segment is FillerSVG) {
      ret = "4";
      List<bool> bits = [];
      if (segment is Switches) {
        //i can tell the difference between these based on how long they are. Switches should be 2 digits, buttons should be 3
        bits.addAll(segment.toggleStates);
        //print(segment.toggleStates);
        //print( DatastringUtilities.toUnsignedHexadecimal(bits));
        ret += DatastringUtilities.toUnsignedHexadecimal(bits);
      } else if (segment is Buttons) {
        for (int i = 0; i < segment.colorStates.length; i++) {
          if (segment.colorStates[i] == 0 || segment.colorStates[i] == 1) {
            bits.add(false);
          } else {
            bits.add(true);
          }
          if (segment.colorStates[i] == 0 || segment.colorStates[i] == 2) {
            bits.add(false);
          } else {
            bits.add(true);
          }
        }
        ret += DatastringUtilities.toUnsignedHexadecimal(bits);
      }
    }

    //todo find a better way to signify the end of this portion
    ret += "'";
    //this is the single quotation mark ('). todo if i keep this as the separation character make sure people dont actually use it or else very bad things hapen.
    //maybe i can use a reserved character? I dont wanna try that just yet since it could very likely fuck shit

    //not sure if i should encode for URL just yet, gonna leave it without for now
    return ret;
  }

  //fuck, i guess return a list with the display and it's label in it?
  static DashboardSegment decodeDatastringOfSegment(String datastring) {
    DashboardSegment segment;

    int displayId = int.parse(datastring.substring(0, 1));
    if (displayId < 4) {
      //todo change this if you add more display types
      String label = datastring.substring(4, datastring.length - 1);
      int displayValue = int.parse(datastring.substring(1, 4));
      segment = makeDisplay(displayId, displayValue, 100, label);
    } else {

      String hexData = datastring.substring(1, datastring.length - 1);
      List<bool> bits = DatastringUtilities.fromUnsignedHexadecimal(hexData);

      //its switches if 8 bits and buttons if 12 bits
      if(bits.length == 12) {
        List<int> colorStates = new List<int>();
        for(int i = 0; i < 6; i++) {
          List<bool> colorBits = [bits[2 * i], bits[2 * i + 1]];
          int myColor = int.parse(DatastringUtilities.toUnsignedHexadecimal(colorBits));
          colorStates.add(myColor);
        }

        segment = new Buttons(colorStates);

      } else {
        segment = new Switches(bits);
      }
    }

    return segment;
  }

  static String encodeCompleteDatastring(List<DashboardSegment> segments) {
    String ret = "";
    //print(segments.toString());
    for(int i = 0; i < segments.length; i++) {
      ret = "$ret${encodeDatastringOfSegment(segments[i])}";
    }

    //print(ret);
    return Uri.encodeComponent(ret);
  }

  static List<String> splitDatastring(String datastring) {
    String decodedString = Uri.decodeComponent(datastring);
    String single= "";
    List<String> ret = new List<String>();
    for(int i = 0; i < decodedString.length; i++) {
      single = "${single}${DatastringUtilities.getCharAt(decodedString, i)}";
      if(decodedString.codeUnitAt(i) == ("'").codeUnitAt(0)) {
        ret.add(single);
        single = ""; //reset single
      }
    }
    return ret;
  }

}

/*LAYERS IN ORDER
-black canvas BG.
-stars.
-"focus". could be a planet, sun, etc. might need to drop this, i ain't an artist.
-window effect. light streaks?
-frame around window
-lights and displays and switches.
be sure there are enough displays to show any important stats first, then put decorations in the remaining slots.
 */
