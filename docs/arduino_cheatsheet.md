# 🔧 ARDUINO CHEAT SHEET

---

## 📋 PODSTAWY

### Struktura programu
```cpp
void setup() {
  // Uruchamia się RAZ na początku
  // Tu: pinMode, Serial.begin, itp.
}

void loop() {
  // Powtarza się W KÓŁKO (60x/sek)
  // Tu: główna logika programu
}
```

---

## 🔌 PINY

### Cyfrowe (Digital)
```cpp
pinMode(pin, OUTPUT);      // Ustaw pin jako wyjście
pinMode(pin, INPUT);       // Ustaw pin jako wejście
pinMode(pin, INPUT_PULLUP); // Wejście z rezystorem podciągającym

digitalWrite(pin, HIGH);   // Włącz (5V)
digitalWrite(pin, LOW);    // Wyłącz (0V)

int val = digitalRead(pin); // Odczytaj: HIGH lub LOW
```

### Analogowe (Analog)
```cpp
int value = analogRead(A0);  // Odczytaj 0-1023 (10-bit)
analogWrite(pin, 128);       // Zapisz PWM 0-255 (tylko piny z ~)
```

**Ważne piny:**
- A0-A5: Analog Input (potencjometry, sensory)
- 3, 5, 6, 9, 10, 11: PWM Output (~)
- 13: Built-in LED

---

## 📡 SERIAL COMMUNICATION

### Podstawy
```cpp
void setup() {
  Serial.begin(9600);  // Rozpocznij komunikację (9600 baud)
}

// WYSYŁANIE
Serial.print("Hello");      // Wyślij tekst (bez nowej linii)
Serial.println("World");    // Wyślij tekst (z nową linią)
Serial.print(123);          // Wyślij liczbę
Serial.println(x);          // Wyślij zmienną

// ODBIERANIE
if (Serial.available() > 0) {
  char c = Serial.read();   // Odczytaj jeden bajt
  String str = Serial.readStringUntil('\n'); // Do nowej linii
}
```

### Format danych (CSV)
```cpp
// Wysyłanie wielu wartości naraz
Serial.print(sensor1);
Serial.print(",");
Serial.print(sensor2);
Serial.print(",");
Serial.println(sensor3);
// Output: "512,768,200"
```

---

## 🔢 ZMIENNE

### Typy danych
```cpp
int x = 10;           // Liczba całkowita (-32768 do 32767)
unsigned int y = 50;  // Bez znaku (0 do 65535)
long z = 100000;      // Duża liczba
float temp = 36.6;    // Liczba zmiennoprzecinkowa
double pi = 3.14159;  // Większa precyzja

char letter = 'A';    // Pojedynczy znak
String text = "Hello"; // Tekst

bool state = true;    // true lub false
```

### const (stałe)
```cpp
const int LED_PIN = 13;  // Nie zmieni się w programie
const float PI = 3.14159;
```

---

## 🎛️ PRZEŁĄCZNIKI I PRZYCISKI

### Prosty przycisk
```cpp
const int BUTTON_PIN = 2;

void setup() {
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  Serial.begin(9600);
}

void loop() {
  int state = digitalRead(BUTTON_PIN);
  
  if (state == LOW) {  // Przycisk wciśnięty (INPUT_PULLUP!)
    Serial.println("Pressed!");
  }
  
  delay(10);
}
```

### Debouncing (eliminacja drgań)
```cpp
const int BUTTON_PIN = 2;
int lastState = HIGH;
int currentState;
unsigned long lastDebounceTime = 0;
unsigned long debounceDelay = 50;

void loop() {
  int reading = digitalRead(BUTTON_PIN);
  
  if (reading != lastState) {
    lastDebounceTime = millis();
  }
  
  if ((millis() - lastDebounceTime) > debounceDelay) {
    if (reading != currentState) {
      currentState = reading;
      
      if (currentState == LOW) {
        // Przycisk wciśnięty!
      }
    }
  }
  
  lastState = reading;
}
```

### Toggle (przełącznik)
```cpp
const int BUTTON_PIN = 2;
const int LED_PIN = 13;

bool ledState = false;
bool lastButtonState = HIGH;

void loop() {
  bool currentState = digitalRead(BUTTON_PIN);
  
  // Wykryj zmianę HIGH → LOW
  if (lastButtonState == HIGH && currentState == LOW) {
    ledState = !ledState;  // Przełącz stan
    digitalWrite(LED_PIN, ledState);
  }
  
  lastButtonState = currentState;
  delay(10);
}
```

---

## 📊 POTENCJOMETR

### Podstawy
```cpp
const int POT_PIN = A0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  int value = analogRead(POT_PIN);  // 0-1023
  Serial.println(value);
  delay(10);
}
```

### Mapowanie wartości
```cpp
int potValue = analogRead(A0);       // 0-1023
int mapped = map(potValue, 0, 1023, 0, 255);  // 0-255
int ledBrightness = map(potValue, 0, 1023, 0, 255);
analogWrite(9, ledBrightness);
```

### Wygładzanie (smoothing)
```cpp
const int numReadings = 10;
int readings[numReadings];
int readIndex = 0;
int total = 0;
int average = 0;

void setup() {
  for (int i = 0; i < numReadings; i++) {
    readings[i] = 0;
  }
}

void loop() {
  total = total - readings[readIndex];
  readings[readIndex] = analogRead(A0);
  total = total + readings[readIndex];
  readIndex = (readIndex + 1) % numReadings;
  
  average = total / numReadings;
  Serial.println(average);
  delay(10);
}
```

---

## 💡 LED

### Podstawowe sterowanie
```cpp
const int LED_PIN = 13;

void setup() {
  pinMode(LED_PIN, OUTPUT);
}

void loop() {
  digitalWrite(LED_PIN, HIGH);  // Włącz
  delay(1000);
  digitalWrite(LED_PIN, LOW);   // Wyłącz
  delay(1000);
}
```

### PWM (Brightness)
```cpp
const int LED_PIN = 9;  // Musi być pin z ~

void setup() {
  pinMode(LED_PIN, OUTPUT);
}

void loop() {
  // Fade in
  for (int brightness = 0; brightness <= 255; brightness++) {
    analogWrite(LED_PIN, brightness);
    delay(5);
  }
  
  // Fade out
  for (int brightness = 255; brightness >= 0; brightness--) {
    analogWrite(LED_PIN, brightness);
    delay(5);
  }
}
```

---

## ⏱️ CZAS

### delay()
```cpp
delay(1000);      // Pauza na 1000ms (1 sekunda)
delayMicroseconds(500); // Pauza na 500 mikrosekund
```

### millis() (Non-blocking timing)
```cpp
unsigned long previousMillis = 0;
const long interval = 1000;

void loop() {
  unsigned long currentMillis = millis();
  
  if (currentMillis - previousMillis >= interval) {
    previousMillis = currentMillis;
    // Zrób coś co 1 sekundę
  }
}
```

### Blink bez delay()
```cpp
const int LED_PIN = 13;
unsigned long previousMillis = 0;
const long interval = 500;
int ledState = LOW;

void loop() {
  unsigned long currentMillis = millis();
  
  if (currentMillis - previousMillis >= interval) {
    previousMillis = currentMillis;
    ledState = !ledState;
    digitalWrite(LED_PIN, ledState);
  }
}
```

---

## 🔁 PĘTLE I WARUNKI

### if / else
```cpp
if (x > 100) {
  // Jeśli x większe niż 100
} else if (x > 50) {
  // Jeśli x między 50 a 100
} else {
  // Jeśli x mniejsze lub równe 50
}
```

### Operatory
```cpp
==  // Równe
!=  // Różne
>   // Większe
<   // Mniejsze
>=  // Większe lub równe
<=  // Mniejsze lub równe
&&  // AND (i)
||  // OR (lub)
!   // NOT (nie)
```

### for loop
```cpp
for (int i = 0; i < 10; i++) {
  // Powtórzy się 10 razy (i = 0,1,2...9)
  Serial.println(i);
}
```

### while loop
```cpp
int i = 0;
while (i < 10) {
  Serial.println(i);
  i++;
}
```

---

## 🎤 MIKROFON (MAX9814)

### Detekcja głośności
```cpp
const int MIC_PIN = A0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  unsigned int peakToPeak = 0;
  unsigned int signalMax = 0;
  unsigned int signalMin = 1024;
  
  unsigned long startMillis = millis();
  
  // Próbkuj przez 50ms
  while (millis() - startMillis < 50) {
    int sample = analogRead(MIC_PIN);
    if (sample > signalMax) signalMax = sample;
    if (sample < signalMin) signalMin = sample;
  }
  
  peakToPeak = signalMax - signalMin;
  Serial.println(peakToPeak);
  delay(10);
}
```

### Beat detection (prosty)
```cpp
int lastVolume = 0;
unsigned long lastBeat = 0;
int threshold = 150;

void loop() {
  // ... pomiar volume jak wyżej ...
  
  int volumeChange = volume - lastVolume;
  unsigned long now = millis();
  
  if (volumeChange > threshold && now - lastBeat > 300) {
    Serial.println("BEAT!");
    lastBeat = now;
  }
  
  lastVolume = volume;
}
```

---

## 🔧 FUNKCJE

### Definiowanie funkcji
```cpp
void myFunction() {
  // Kod funkcji
}

int addNumbers(int a, int b) {
  return a + b;
}

float calculateAverage(int x, int y) {
  return (x + y) / 2.0;
}
```

### Wywołanie
```cpp
void loop() {
  myFunction();
  
  int sum = addNumbers(5, 10);  // sum = 15
  float avg = calculateAverage(10, 20);  // avg = 15.0
}
```

---

## 📐 MATEMATYKA

### Podstawowe operacje
```cpp
int a = 10 + 5;   // 15
int b = 10 - 5;   // 5
int c = 10 * 5;   // 50
int d = 10 / 5;   // 2
int e = 10 % 3;   // 1 (reszta z dzielenia)

a++;  // a = a + 1
a--;  // a = a - 1
a += 5;  // a = a + 5
```

### Funkcje matematyczne
```cpp
int x = abs(-5);           // 5 (wartość bezwzględna)
int y = constrain(x, 0, 100); // Ogranicz 0-100
int z = map(512, 0, 1023, 0, 255); // Przeskaluj

float a = sqrt(16);        // 4.0 (pierwiastek)
float b = pow(2, 3);       // 8.0 (2^3)
float c = sin(PI/2);       // 1.0
float d = cos(0);          // 1.0
```

### Random
```cpp
randomSeed(analogRead(0));  // Inicjalizacja (w setup)
int r = random(10);         // 0-9
int r = random(5, 10);      // 5-9
```

---

## 🛠️ DOBRE PRAKTYKI

### 1. Używaj const dla pinów
```cpp
const int LED_PIN = 13;  // Łatwa zmiana, czytelniejszy kod
```

### 2. Nazwy zmiennych opisowe
```cpp
// ŹLE:
int x = analogRead(A0);

// DOBRZE:
int sensorValue = analogRead(A0);
```

### 3. Komentarze
```cpp
// Odczytaj wartość z potencjometru
int value = analogRead(A0);

/* 
   To jest komentarz
   wieloliniowy
*/
```

### 4. Nie blokuj delay()
```cpp
// ŹLE (blokuje program):
digitalWrite(LED, HIGH);
delay(5000);

// DOBRZE (non-blocking):
if (millis() - lastTime > 5000) {
  digitalWrite(LED, HIGH);
  lastTime = millis();
}
```

---

## 🐛 TROUBLESHOOTING

### Problem: Kod się nie wgrywa
- ✅ Sprawdź port (Tools → Port)
- ✅ Sprawdź board (Tools → Board → Arduino Uno)
- ✅ Zamknij Serial Monitor
- ✅ Sprawdź kabel USB

### Problem: Serial Monitor pusty
- ✅ Sprawdź Baud Rate (9600 w obu miejscach)
- ✅ `Serial.begin(9600)` w setup()
- ✅ `Serial.println()` w loop()

### Problem: Pin nie działa
- ✅ `pinMode()` w setup()
- ✅ Sprawdź numer pinu
- ✅ PWM tylko na pinach z ~

### Problem: Dziwne wartości
- ✅ Dodaj `delay(10)` w loop()
- ✅ Sprawdź połączenia (GND!)
- ✅ Użyj `constrain()` lub `map()`

---

## 💡 PRZYDATNE SZABLONY

### Arduino → Processing (CSV)
```cpp
void loop() {
  int sensor1 = analogRead(A0);
  int sensor2 = analogRead(A1);
  
  Serial.print(sensor1);
  Serial.print(",");
  Serial.println(sensor2);
  
  delay(10);
}
```

### Multi-sensor dashboard
```cpp
const int POT1 = A0;
const int POT2 = A1;
const int BUTTON = 2;

void setup() {
  Serial.begin(9600);
  pinMode(BUTTON, INPUT_PULLUP);
}

void loop() {
  int p1 = analogRead(POT1);
  int p2 = analogRead(POT2);
  int btn = digitalRead(BUTTON);
  
  Serial.print(p1);
  Serial.print(",");
  Serial.print(p2);
  Serial.print(",");
  Serial.println(btn);
  
  delay(10);
}
```

### Heartbeat (sprawdź czy działa)
```cpp
void setup() {
  Serial.begin(9600);
  pinMode(13, OUTPUT);
}

void loop() {
  digitalWrite(13, HIGH);
  Serial.println("ALIVE");
  delay(1000);
  digitalWrite(13, LOW);
  delay(1000);
}
```

---

## 📚 ZASOBY

**Dokumentacja:**
- https://docs.arduino.cc/
- https://www.arduino.cc/reference/

**Tutorials:**
- Arduino Built-in Examples (File → Examples)
- Adafruit Learning System
- SparkFun Tutorials

**Community:**
- Arduino Forum
- Reddit: r/arduino
- Stack Overflow

---

**PAMIĘTAJ:**
- Testuj często!
- Używaj Serial Monitor do debugowania
- Nie bój się eksperymentować!
- Google is your friend 🔍

**Powodzenia!** 🚀