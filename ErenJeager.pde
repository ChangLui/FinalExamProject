// modification of P_4_3_2_01.pde
// at https://github.com/generative-design/Code-Package-Processing-3.x/
//    blob/master/01_P/P_4_3_2_01/P_4_3_2_01.pde
// Licensed under the Apache License, Version 2.0

int cellSize = 8;
float scale = 1;
int imgWidth = 1280;
int imgHeight = 720;
color[][] display;
int gridWidth;
int gridHeight;
int[] order;
int counter;
int increment = 400;
int toPic = 0;
int status = 1; // 0 = changing; 1 = final
color[][][] gridImages;
PImage[] finalImages;
String[] fileNames = {
  "data/Eren Jaeger (Human Form).jpg", 
  "data/Eren Jaeger (Titan Form).jpg"
};

void settings() {
  size((int)(imgWidth * scale), (int)(imgHeight * scale));
}

void setup() {
  finalImages = new PImage[fileNames.length];
  for (int x = 0; x < fileNames.length; x++) {
    finalImages[x] = loadImage(fileNames[x]);
  }
  gridWidth = imgWidth/cellSize;
  gridHeight = imgHeight/cellSize;
  gridImages = new color[finalImages.length][gridHeight][gridWidth];
  display = new color[gridHeight][gridWidth];
  for (int i = 0; i < finalImages.length; i++) {
    for (int y = 0; y < gridHeight; y++) {
      for (int x = 0; x < gridWidth; x++) {
        gridImages[i][y][x] = finalImages[i].pixels[y*cellSize*imgWidth+x*cellSize+cellSize/2];
        if (i == toPic) {
          display[y][x] = gridImages[i][y][x];
        }
      }
    }
  }
  order = new int[gridWidth * gridHeight];
  for (int x = 0; x < order.length; x++) {
    order[x] = x;
  }
  for (int x = order.length - 1; i > 0; i--) {
    int i = (int)random(x + 1);
    int temp = order[x];
    order[x] = order[i];
    order[i] = temp;
  }
  println(i.size());
}

void draw() {
  background(240);
  noStroke();
  if (status == 1) {
    image(finalImages[toPic], 0, 0, imgWidth * scale, imgHeight * scale);
  } else {
    for (int y = 0; y < display.length; y++) {
      for (int x = 0; x < display[0].length; x++) {
        float xLoc = x * cellSize * scale;
        float yLoc = y * cellSize * scale;
        float size = cellSize * scale;
        rectMode(CORNER);
        fill(display[y][x]);
        rect(xLoc, yLoc, size, size);
      }
    }
    for (int z = 0; z < counter; z++) {
      if (z < order.length) {
        int pxNum = order[z];
        int targetX = pxNum % gridWidth;
        int targetY = pxNum / gridWidth;
        display[targetY][targetX] = gridImages[toPic][targetY][targetX];
      } else {
        status = 1;
      }
    }
    counter += increment;
  }
}

color brighten(color c) {
  float r, g, b;
  color output;
  r = red(c);
  g = green(c);
  b = blue(c);
  r = constrain(r + 150, 0, 255);
  g = constrain(g + 150, 0, 255);
  b = constrain(b + 150, 0, 255);
  output = color(r, g, b);
  return output;
}

void keyPressed() {
  if (key == ' ') {
    status = 0;
    counter = 0;
    if (toPic < finalImages.length -1) {
      toPic++;
    } else {
      toPic = 0;
    }
  }
}  
