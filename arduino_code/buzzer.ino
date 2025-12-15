int buzzerPin = 8;

void setup() {
  pinMode(buzzerPin, OUTPUT);
}

void loop() {
  tone(buzzerPin, 1000); // 1000 Hz
  delay(500);

  noTone(buzzerPin);
  delay(500);
}
