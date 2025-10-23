void setup() {
  Serial.begin(9600);
}

void loop() {
  int light = analogRead(A0);  // Fotorezystor do A0
  Serial.println(light);
  delay(50);
}
