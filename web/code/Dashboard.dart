import 'dart:html';
import 'dart:svg' as Svg;
import 'dart:math' as Math;
import 'displays/Display.dart';
import 'Starship.dart';

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
    ctx.fillStyle = casingColor;

    //ctx.fillRect(0, 0, WIDTH, 100);
    ctx.fillRect(0, HEIGHT - 100, WIDTH, 100);
    ctx.fillRect(0, 0, 160, HEIGHT);
    ctx.fillRect(WIDTH - 160, 0, 160, HEIGHT);
    return ctx;
  }

  //assume they fit in 160 x 100 size area
  //should be room for 19 displays
  DivElement drawDisplays() {
    DivElement ret = new DivElement();
    ret.style.position = "absolute";
    ret.style.zIndex = "1";

    List<List<int>> availableStartingPoints = [ //list of the coordinates i can start drawing displays in
        [0, 700],
        [171, 700],
        [343, 700],
        [514, 700],
        [686, 700],
        [858, 700],
        [1029, 700],

        [1029, 100],
        [1029, 200],
        [1029, 300],
        [1029, 400],
        [1029, 500],
        [1029, 600],

        [0, 100],
        [0, 200],
        [0, 300],
        [0, 400],
        [0, 500],
        [0, 600],
      ];



      Math.Random rand = new Math.Random(starship.getId());
      for(int i = 0; i < rand.nextInt(availableStartingPoints.length); i++) {
        List<int> coordinates = availableStartingPoints.removeAt(rand.nextInt(availableStartingPoints.length));
        SevenSegmentDisplay display = new SevenSegmentDisplay(rand.nextInt(100), 100);

        Svg.SvgSvgElement svg = display.graphicalDisplay();
        svg.style.position = "absolute";
        svg.style.top = coordinates[1].toString();
        svg.style.left = coordinates[0].toString();
        ret.append(svg);
      }
      return ret;
  }

  //maybe merge this with the drawDisplays method above?
  CanvasRenderingContext2D drawFillerElements(CanvasRenderingContext2D ctx) {

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