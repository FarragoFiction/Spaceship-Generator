import 'dart:html';
import 'dart:svg' as Svg;
import 'dart:math' as Math;
import 'displays/Display.dart';
import 'Starship.dart';
import 'FillerSVG.dart';

List<String> temporaryFlavorLabels = [
  "fuel",
  "strength",
  "tears",
  "energy",
  "dreams",
  "efficiency",
  "enthusiasm",
  "velocity",
  "disaster lvl",
  "pain",
  "coherence",
  "propability",
  "power",
  "rpm",
  "mass",
  "potential",
  "charge",
  "bullets",
  "errors",
];

class Dashboard {
  final int WIDTH = 1200;
  final int HEIGHT = 800;
  final List<String> COLORS = [
    "#FFFFFF",
    "#FFFFCC",
    "#FFCCFF",
    "#CCFFFF",
    "#CCFFCC",
    "#FFCCCC",
    "#CCCCFF",
  ];

  Starship starship;

  Dashboard(Starship starship) {
    this.starship = starship;
  }

  DivElement buildDashboard() {
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
    ret.append(drawDisplays());

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
  CanvasRenderingContext2D drawStars(CanvasRenderingContext2D ctx) {
    Math.Random random = new Math.Random(starship.getId());
    for(int i = 0; i <= 15 + random.nextInt(50); i++) {
      int x = random.nextInt(WIDTH);
      int y = random.nextInt(HEIGHT);
      int r = 1 + random.nextInt(3);

      ctx.fillStyle = COLORS[random.nextInt(COLORS.length)];
      ctx.beginPath();
      ctx.arc(x, y, r, 0, 2 * Math.PI);
      ctx.fill();
    }
  }

  CanvasRenderingContext2D drawFocus(CanvasRenderingContext2D ctx) {

  }

  CanvasRenderingContext2D drawWindow(CanvasRenderingContext2D ctx) {

  }

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
  DivElement drawDisplays() {
    int boxWidth = 160;
    int boxHeight = 100;
    DivElement ret = new DivElement();
    ret.style.position = "absolute";
    ret.style.zIndex = "1";

    List<List<int>> availableStartingPoints = [ //list of the coordinates i can start drawing displays in
        [0, 650],
        [171, 650],
        [343, 650],
        [514, 650],
        [686, 650],
        [858, 650],
        [1039, 650],

        [1039, 0],
        [1039, 100],
        [1039, 200],
        [1039, 300],
        [1039, 400],
        [1039, 500],

        [0, 0],
        [0, 100],
        [0, 200],
        [0, 300],
        [0, 400],
        [0, 500],
      ];



      Math.Random rand = new Math.Random(starship.getId());
      int numStartPoints = availableStartingPoints.length;

      //setup the main displays
      for(int i = 0; i < rand.nextInt(availableStartingPoints.length); i++) {
        DivElement wrapper = new DivElement();
        List<int> coordinates = availableStartingPoints.removeAt(rand.nextInt(availableStartingPoints.length));
        SevenSegmentDisplay display = makeDisplay(rand.nextInt(4), rand.nextInt(101), 100);

        //make the svg
        Svg.SvgSvgElement svg = display.graphicalDisplay();
        wrapper.style.position = "absolute";
        //print(svg.getAttribute("height"));
        int x = coordinates[0] + (boxWidth - int.parse(svg.getAttribute("width"))) ~/ 2;
        int y = coordinates[1] + (boxWidth - int.parse(svg.getAttribute("height"))) ~/ 2;
        wrapper.style.top = "${y}px";
        wrapper.style.left = "${x}px";
        wrapper.append(svg);

        //add a label
        /*DivElement label = new DivElement();
        label.style.position = "absolute";
        label.style.top = "${coordinates[1] + boxHeight + 15}px";
        label.style.left = "${coordinates[0]}px";

        //label.style.width = "$boxWidth";
        //label.style.textAlign = "center";
        label.style.backgroundColor = "black";
        label.text = "test";
        */
        String label = temporaryFlavorLabels[rand.nextInt(temporaryFlavorLabels.length)];
        wrapper.appendText(label);
        ret.append(wrapper);
      }//h

      //add filler elements
      while(availableStartingPoints.length > 0) {
        List<int> coordinates = availableStartingPoints.removeAt(rand.nextInt(availableStartingPoints.length));


        Switches filler = new Switches(rand);
        Svg.SvgSvgElement fillerSvg = filler.getFiller();

        int x = coordinates[0] + (boxWidth - int.parse(fillerSvg.getAttribute("width"))) ~/ 2;
        int y = coordinates[1] + (boxWidth - int.parse(fillerSvg.getAttribute("height"))) ~/ 2;

        fillerSvg.style.position = "absolute";
        fillerSvg.style.top = "${y}px";
        fillerSvg.style.left = "${x}px";

        ret.append(fillerSvg);
      }


      return ret;
  }

  //maybe merge this with the drawDisplays method above?
  CanvasRenderingContext2D drawFillerElements(CanvasRenderingContext2D ctx) {

  }


  Display makeDisplay(int id, num value, num maxValue) {
    if(id == 0)
      return new AnalogueGague(value, maxValue, true, false);
    if(id == 1)
      return new AnalogueGague(value, maxValue, false, true);
    if(id == 2)
      return new NixieTube(value, maxValue);
    if(id == 3)
      return new SevenSegmentDisplay(value, maxValue);
    return null;
  }
}

//this is gonna be hard.

/*LAYERS IN ORDER
-black canvas BG.
-stars.
-"focus". could be a planet, sun, etc. might need to drop this, i ain't an artist.
-window effect. light streaks?
-frame around window
-lights and displays and switches.
be sure there are enough displays to show any important stats first, then put decorations in the remaining slots.
 */