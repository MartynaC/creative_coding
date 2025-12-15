import processing.video.*;

Capture cam;
PImage prev;
boolean ready = false;
// --- Parametry ---
int step = 20;        // wielkość komórki siatki (większe = prościej/szybciej)
int threshold = 35;   // próg różnicy (niższy = bardziej czułe)

void setup() {
  size(1280, 720);
  cam = new Capture(this, width, height);
  cam.start();
  prev = createImage(width, height, RGB);
  background(0);
}

void draw() {
  if (!cam.available()) return;
  cam.read();
  
  // Zanikanie patternu ( bez obrazu z kamery - baw sie z fill ) 
  pushStyle();
  noStroke();
  fill(0, 10);          // im mniejsze 10 - tym wolniejsze znikanie
  rect(0, 0, width, height);
  popStyle();
 
  
  //  pokaż video w tle
  /**
  tint(255, 60);
  image(cam, 0, 0);
  noTint();
  **/
  cam.loadPixels();
  prev.loadPixels();

  // sprawdzamy ruch tylko w punktach siatki
  for (int y = 0; y < height; y += step) {
    for (int x = 0; x < width; x += step) {

      int i = y * width + x;
      float diff = abs(brightness(cam.pixels[i]) - brightness(prev.pixels[i]));

      if (diff > threshold) {
        noFill();
        stroke(255, 200);
        strokeWeight(2);
        circle(x, y, step * 0.9); // rysuj pattern w komórce
        // drawPattern(x, y, step * 0.9); (słoneczka ) 
      }
    }
  }

  // zapamiętaj bieżącą klatkę jako "prev"
  prev.copy(cam, 0, 0, cam.width, cam.height, 0, 0, width, height);
  prev.updatePixels();
}

// Najprostszy pattern: "słoneczko" (linie radialne)
/**
void drawPattern(float x, float y, float size) {
  pushStyle();
  stroke(255, 200);
  strokeWeight(2);

  int n = 10;
  float r = size * 0.5;
  for (int k = 0; k < n; k++) {
    float a = TWO_PI * k / n;
    line(x, y, x + cos(a) * r, y + sin(a) * r);
  }
  popStyle();
}
**/
