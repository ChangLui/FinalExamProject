// modification of P_4_3_2_01.pde
// at https://github.com/generative-design/Code-Package-Processing-3.x/
//    blob/master/01_P/P_4_3_2_01/P_4_3_2_01.pde
// Licensed under the Apache License, Version 2.0

/* @pjs preload="human.jpg,titan.jpg"; */

int cellSize = 8;
float scale = 1;      // NOTE: if you change this, you must also change the parameters to the SIZE function below
int imgWidth = 1280;  // NOTE: if you change this, you must also change the parameters to the SIZE function below
int imgHeight = 720;  // NOTE: if you change this, you must also change the parameters to the SIZE function below
color[][] display;
int gridWidth;
int gridHeight;
int[] order;
int counter;
int increment = 200;
int toPic = 0;
int status = 1; // 0 = changing; 1 = final
color[][] gridImage0;
color[][] gridImage1;
PImage[] finalImages;
String[] fileNames = {
  "human.jpg", 
  "titan.jpg"
};

void setup() {
  size(1280, 720);  // NOTE: this must be "size(imgWidth * scale, imgHeight * scale);"
  finalImages = new PImage[fileNames.length];
  for (int x = 0; x < fileNames.length; x++) {
    finalImages[x] = loadImage(fileNames[x]);
  }
  gridWidth = imgWidth/cellSize;
  gridHeight = imgHeight/cellSize;
  gridImage0 = new color[gridHeight][gridWidth];
  gridImage1 = new color[gridHeight][gridWidth];
  display = new color[gridHeight][gridWidth];
  for (int i = 0; i < finalImages.length; i++) {
    for (int y = 0; y < gridHeight; y++) {
      for (int x = 0; x < gridWidth; x++) {
        if (i == 0) {
          gridImage0[y][x] = finalImages[i].pixels[y*cellSize*imgWidth+x*cellSize+cellSize/2+imgWidth*cellSize/2];
          display[y][x] = gridImage0[y][x];
        } else {
          gridImage1[y][x] = finalImages[i].pixels[y*cellSize*imgWidth+x*cellSize+cellSize/2+imgWidth*cellSize/2];           
        }
      }
    }
  }
  order = new int[gridWidth * gridHeight];
  for (int x = 0; x < order.length; x++) {
    order[x] = x;
  }
  for (int x = order.length - 1; x > 0; x--) {
    int i = (int)random(x + 1);
    int temp = order[x];
    order[x] = order[i];
    order[i] = temp;
  }
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
        if (toPic == 0) {
          display[targetY][targetX] = gridImage0[targetY][targetX];
        } else {
          display[targetY][targetX] = gridImage1[targetY][targetX];        
        }
      } else {
        status = 1;
      }
    }
    counter += increment;
  }
}

void keyPressed() {
  changeImage();
}  

void mouseClicked() {
  changeImage();
}  

void changeImage() {
    status = 0;
    counter = 0;
    if (toPic < finalImages.length -1) {
      toPic++;
    } else {
      toPic = 0;
    }
    println(toPic);
}
