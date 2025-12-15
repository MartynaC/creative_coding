// =========================================
// MOTION DETECTION - proste wykrywanie ruchu
// =========================================

import processing.video.*;

Capture cam;
PImage prev;

int threshold = 50;

void setup() {
  size(640, 480);

  cam = new Capture(this, width, height);
  cam.start();

  prev = createImage(width, height, RGB);
}

void draw() {
  if (!cam.available()) return;

  // Odczytaj nową klatkę
  cam.read();

  cam.loadPixels();
  prev.loadPixels();
  loadPixels();

  // Porównaj piksel po pikselu
  for (int i = 0; i < cam.pixels.length; i++) {

    float diff = abs(
      brightness(cam.pixels[i]) -
      brightness(prev.pixels[i])
    );

    // Jeśli różnica duża → ruch (biały)
    if (diff > threshold) {
      pixels[i] = color(255);
    }
    // Jeśli mała → brak ruchu (czarny)
    else {
      pixels[i] = color(0);
    }
  }

  updatePixels();

  // Zapamiętaj bieżącą klatkę na następny raz
  prev.copy(cam, 0, 0, cam.width, cam.height,
            0, 0, width, height);
  prev.updatePixels();
}
