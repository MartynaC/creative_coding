int buttonPin = 2;              // deklarujemy zmienne - globale przed setupem
int ledPin = 13;                // pin13 - ten sam co w poprzednim kodzie

void setup() {
  pinMode(buttonPin, INPUT_PULLUP);   // Przycisk jako wejście
  pinMode(ledPin, OUTPUT);     // LED jako wyjście
}

void loop() {
  
  int buttonState = digitalRead(buttonPin);  // Odczytaj przycisk
  
  if (buttonState == LOW) {   // Jeśli wciśnięty
    digitalWrite(ledPin, HIGH); // Włącz LED
  } else {                      // Jeśli nie wciśnięty
    digitalWrite(ledPin, LOW);  // Wyłącz LED
  }
}
