import processing.serial.*;

Serial port;
int lightLevel = 0;

void setup() {
  size(800, 600);
  // Change the index [0] to match your Arduino port
  println(Serial.list());
  port = new Serial(this, Serial.list()[4], 9600);
  port.bufferUntil('\n');
  background(0);
}

void draw() {
  // Map light level to circle size
  float size = map(lightLevel, 0, 1023, 50, 400);
  
  // Draw pulsing circle
  fill(100, 200, 255, 150);
  noStroke();
  ellipse(width/2, height/2, size, size);
  
  // Fade effect
  fill(0, 20);
  rect(0, 0, width, height);
}

void serialEvent(Serial port) {
  String data = port.readStringUntil('\n');
  if (data != null) {
    data = trim(data);
    lightLevel = int(data);
  }
}
