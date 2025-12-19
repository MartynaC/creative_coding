// ==================================================
// PROCESSING - MOTION DETECTION 
// Najprostsza wersja: porównujemy klatkę z poprzednią
// ==================================================

import processing.video.*;

Capture cam;
PImage prev;               // poprzednia klatka

int threshold = 50;        // próg czułości (niższy = bardziej czułe)
float motionLevel = 0;     // 0..1 (ile ruchu w obrazie)

void setup() {
  size(1280, 720);

  // (opcjonalnie) lista kamer w konsoli
  println("=== DOSTĘPNE KAMERY ===");
  printArray(Capture.list());

  cam = new Capture(this, width, height);
  cam.start();

  prev = createImage(width, height, RGB);
  prev.loadPixels();
  for (int i = 0; i < prev.pixels.length; i++) prev.pixels[i] = color(0);
  prev.updatePixels();
}

void draw() {
  if (!cam.available()) return;

  // 1) Czytamy nową klatkę z kamery
  cam.read();

  // 2) Jeśli to pierwsza klatka (albo po resecie),
  //    to nie mamy jeszcze sensownego "prev" do porównania.
  //    Wtedy tylko zapamiętujemy i kończymy.
  if (frameCount == 1) {
    prev.copy(cam, 0, 0, cam.width, cam.height, 0, 0, width, height);
    prev.updatePixels();
    image(cam, 0, 0);
    drawUI();
    return;
  }

  // 3) Detekcja ruchu: porównujemy jasność piksel po pikselu
  cam.loadPixels();
  prev.loadPixels();

  // Zaczynamy od pokazania obrazu z kamery
pushMatrix();
translate(width, 0);
scale(-1, 1);

image(cam, 0, 0);

loadPixels();

int motionPixels = 0;

for (int y = 0; y < cam.height; y++) {
  for (int x = 0; x < cam.width; x++) {

    int iCam = y * cam.width + x;

    float diff = abs(brightness(cam.pixels[iCam]) - brightness(prev.pixels[iCam]));

    if (diff > threshold) {
      motionPixels++;
      
      // TUTAJ ODWRACAMY WZÓR
      // FLIP X na ekranie: (0->width-1, 1->width-2, ...)
      int xFlip = (width - 1) - x;
      int iScreen = y * width + xFlip;

      pixels[iScreen] = color(255, 0, 0, 150);
    }
  }
}


updatePixels();

popMatrix(); 

  // 4) Motion level jako procent pikseli "w ruchu"
  motionLevel = (float) motionPixels / (float) cam.pixels.length;

  // 5) Zapamiętaj bieżącą klatkę jako "prev" na następną iterację
  prev.copy(cam, 0, 0, cam.width, cam.height, 0, 0, width, height);
  prev.updatePixels();

  // 6) UI
  drawUI();
}

// ==================================================
// UI
// ==================================================
void drawUI() {
  pushStyle();
  fill(255);
  textSize(16);
  textAlign(LEFT, TOP);

  text("Motion: " + nf(motionLevel * 100, 0, 2) + "%", 10, 10);
  text("Threshold: " + threshold + " (← →)", 10, 30);
  text("SPACE = reset prev frame", 10, 50);

  // pasek ruchu na dole
  noStroke();
  fill(255, 0, 0, 120);
  rect(0, height - 20, width * motionLevel, 20);
  popStyle();
}

// ==================================================
// Sterowanie
// ==================================================
void keyPressed() {
  if (keyCode == LEFT)  threshold = constrain(threshold - 5, 5, 200);
  if (keyCode == RIGHT) threshold = constrain(threshold + 5, 5, 200);

  // Reset: "prev" = aktualna klatka (usuwa fałszywy ruch po zmianie sceny)
  if (key == ' ') {
    prev.copy(cam, 0, 0, cam.width, cam.height, 0, 0, width, height);
    prev.updatePixels();
  }
}
