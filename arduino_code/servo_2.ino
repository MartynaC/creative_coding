#include <Servo.h>

Servo myServo;

void setup() {
  myServo.attach(6);
}

void loop() {
  myServo.write(0);    // 0 stopni
  delay(1000);

  myServo.write(90);   // środek
  delay(1000);

  myServo.write(180);  // max
  delay(1000);
}
