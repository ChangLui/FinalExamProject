// modification of P_4_3_2_01.pde
// at https://github.com/generative-design/Code-Package-Processing-3.x/
//    blob/master/01_P/P_4_3_2_01/P_4_3_2_01.pde
// Licensed under the Apache License, Version 2.0
import java.util.Collections;

PImage img1;
PImage img2;
boolean showOriginal = false;
int cellSize = 8;
float scale = 1;
int imgWidth = 1280;
int imgHeight = 720;
int txtLength;
int currentLetter;
ArrayList i = new ArrayList();
color[][] display;
int gridWidth;
int gridHeight;
int counter;
int increment = 400;
int toPic = 0;
int status = 3; // 0 = shrinking; 1 = replacing; 2 = growing; 3 = final
color[][][] gridImages;
PImage[] finalImages;
String[] fileNames = {
  "Eren Jaeger (Human Form).jpg", 
  "Eren Jaeger (Titan Form).jpg"
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

  for (int x = 0; x < gridWidth * gridHeight; x++) {
    i.add(x);
  }
  Collections.shuffle(i);
  println(i.size());
}

void draw() {
  background(240);
  noStroke();
  if (status == 3) {
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
      if (z < i.size()) {
        int pxNum = i.get(z);
        int targetX = pxNum % gridWidth;
        int targetY = pxNum / gridWidth;
        display[targetY][targetX] = gridImages[toPic][targetY][targetX];
      } else {
        status = 3;
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
    status = 1;
    counter = 0;
    if (toPic < finalImages.length -1) {
      toPic++;
    } else {
      toPic = 0;
    }
  }
}  
void keyReleased() {
  if (key == 's' || key == 'S') saveFrame("_##.png");
}
