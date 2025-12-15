#include <Servo.h>

Servo pen;

void setup() {
  pen.attach(6);   // pin sygnałowy serwa - pisak/ długopis
}

void loop() {

  pen.write(random(30, 150));   // ruch w lewo
  delay(300);

  pen.write(120);  // ruch w prawo
  delay(300);
}
