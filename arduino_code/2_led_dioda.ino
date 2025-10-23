void setup() {
  pinMode(13, OUTPUT);  // Pin 13 jako wyjście
}

void loop() {
  digitalWrite(13, HIGH);  // Włącz LED
  delay(1000);             // Czekaj 1 sekundę
  digitalWrite(13, LOW);   // Wyłącz LED
  delay(1000);             // Czekaj 1 sekundę
}
