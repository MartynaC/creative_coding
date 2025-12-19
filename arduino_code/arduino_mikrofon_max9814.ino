// ==================================================
// ARDUINO + MAX9814 - DETEKCJA DŹWIĘKU
// Mikrofon elektretowy z Auto Gain Control (AGC)
// ==================================================

// MAX9814 ma 3 piny:
// VDD → 5V (lub 3.3V)
// GND → GND
// OUT → A0 (wyjście analogowe)

const int MIC_PIN = A0;
const int LED_PIN = 13;  // Wbudowana LED

// Zmienne do analizy dźwięku
int sampleWindow = 50;   // Okno próbkowania w ms (50ms = 20 Hz)
unsigned int sample;

// Threshold - próg wykrywania dźwięku
int threshold = 100;     // Dostosuj do swojego mikrofonu (50-200)

void setup() {
  Serial.begin(9600);
  pinMode(LED_PIN, OUTPUT);
  
  Serial.println("=== MAX9814 Sound Detector ===");
  Serial.println("Wysyłam: głośność,peak,threshold");
}

void loop() {
  // ============ POMIAR GŁOŚNOŚCI ============
  unsigned long startMillis = millis();
  unsigned int peakToPeak = 0;   // Rozpiętość peak-to-peak
  
  unsigned int signalMax = 0;
  unsigned int signalMin = 1024;
  
  // Zbieraj dane przez 50ms
  while (millis() - startMillis < sampleWindow) {
    sample = analogRead(MIC_PIN);
    
    // Znajdź max i min
    if (sample > signalMax) {
      signalMax = sample;
    }
    if (sample < signalMin) {
      signalMin = sample;
    }
  }
  
  // Oblicz peak-to-peak amplitude
  peakToPeak = signalMax - signalMin;
  
  // ============ WYKRYJ GŁOŚNE DŹWIĘKI ============
  if (peakToPeak > threshold) {
    digitalWrite(LED_PIN, HIGH);  // Zapal LED
  } else {
    digitalWrite(LED_PIN, LOW);   // Zgaś LED
  }
  
  // ============ WYŚLIJ DANE ============
  // Format CSV: głośność,peak,threshold
  Serial.print(peakToPeak);
  Serial.print(",");
  Serial.print(signalMax);
  Serial.print(",");
  Serial.println(threshold);
  
  delay(10);
}

// ==================================================
// JAK TO DZIAŁA?
// ==================================================
/*

MAX9814:
- Mikrofon elektretowy z wbudowanym wzmacniaczem
- Auto Gain Control (AGC) - automatyczna regulacja wzmocnienia
- Wyjście analogowe 0-5V (środek ~2.5V = cisza)

POMIAR:
1. Przez 50ms zbieramy próbki
2. Znajdujemy MAX i MIN wartość
3. Peak-to-Peak = MAX - MIN = "głośność"
4. Porównujemy z progiem (threshold)

WARTOŚCI:
- Cisza: ~0-50
- Normalna mowa: 50-150
- Głośna muzyka: 150-300
- Krzyk/klaskanie: 300-500

KALIBRACJA:
Otwórz Serial Monitor i zobacz wartości:
- W ciszy - zapisz wartość
- Przy dźwięku - zapisz wartość
- Threshold = gdzieś pośrodku

*/

// ==================================================
// ROZBUDOWA - DODATKOWE FUNKCJE
// ==================================================

/*

// ============ WERSJA Z MAPOWANIEM 0-100 ============
void loop() {
  // ... pomiar jak wyżej ...
  
  // Zmapuj 0-500 na 0-100
  int volume = map(peakToPeak, 0, 500, 0, 100);
  volume = constrain(volume, 0, 100);  // Ogranicz
  
  Serial.println(volume);
  delay(10);
}


// ============ WERSJA Z WYGŁADZANIEM ============
const int numReadings = 10;
int readings[numReadings];
int readIndex = 0;
int total = 0;
int average = 0;

void setup() {
  Serial.begin(9600);
  // Inicjalizuj tablicę
  for (int i = 0; i < numReadings; i++) {
    readings[i] = 0;
  }
}

void loop() {
  // ... pomiar jak wyżej ...
  
  // Odejmij starą wartość
  total = total - readings[readIndex];
  // Dodaj nową
  readings[readIndex] = peakToPeak;
  total = total + readings[readIndex];
  
  // Przesuń indeks
  readIndex = readIndex + 1;
  if (readIndex >= numReadings) {
    readIndex = 0;
  }
  
  // Oblicz średnią
  average = total / numReadings;
  
  Serial.println(average);
  delay(10);
}


// ============ BEAT DETECTION (prosty) ============
int lastVolume = 0;
unsigned long lastBeat = 0;
int beatThreshold = 150;  // Próg wykrycia beatu
int beatCooldown = 300;   // Min 300ms między beatami

void loop() {
  // ... pomiar jak wyżej ...
  
  // Wykryj nagły wzrost głośności
  int volumeChange = peakToPeak - lastVolume;
  unsigned long now = millis();
  
  if (volumeChange > beatThreshold && 
      now - lastBeat > beatCooldown) {
    
    // BEAT WYKRYTY!
    Serial.println("BEAT!");
    lastBeat = now;
    
    // Możesz wysłać specjalny sygnał do Processing
    // Serial.println("B");  // "B" = beat
  }
  
  lastVolume = peakToPeak;
  delay(10);
}


// ============ FREQUENCY DETECTION (wymaga FFT) ============
// To wymaga biblioteki FFT - bardziej zaawansowane!
// Można użyć biblioteki: arduinoFFT
// Pozwala wykrywać dominującą częstotliwość (nuta, ton)

*/
