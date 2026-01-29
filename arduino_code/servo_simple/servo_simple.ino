#include <Servo.h>

Servo pen;

void setup() {
  pen.attach(6);   // pin sygnałowy serwa - pisak/ długopis
}

void loop() {

  pen.write(90);  // ustaw kąt 
  delay(1000);

}
