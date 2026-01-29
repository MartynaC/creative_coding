// ====== Piny ======
const int LDR_PIN   = A0;
const int POT_PIN   = A1;
const int BTN_PIN   = 2;
const int BUZZER_PIN = 8;

// ====== Kalibracja LDR ======
int sensorValue;
int sensorLow  = 1023;
int sensorHigh = 0;

// ====== Button state ======
int mode = 0;
bool lastBtn = HIGH; // INPUT_PULLUP -> spoczynkowo HIGH

// ====== Skale (MIDI offsety) ======
// 0: pentatonic (brzmi "ładnie" prawie zawsze)
// 1: minor
// 2: chromatic (bardziej "noise/art")
const byte scale0[] = {0, 2, 4, 7, 9, 12};                 // pentatonic
const byte scale1[] = {0, 2, 3, 5, 7, 8, 10, 12};          // natural minor
const byte scale2[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}; // chromatic

int pickFromScale(int value01, int baseMidi) {
  // value01: 0..1023 -> wybór stopnia skali
  if (mode == 0) {
    int idx = map(value01, 0, 1023, 0, (int) (sizeof(scale0) - 1));
    return baseMidi + scale0[idx];
  } else if (mode == 1) {
    int idx = map(value01, 0, 1023, 0, (int) (sizeof(scale1) - 1));
    return baseMidi + scale1[idx];
  } else {
    int idx = map(value01, 0, 1023, 0, (int) (sizeof(scale2) - 1));
    return baseMidi + scale2[idx];
  }
}

float midiToFreq(int midi) {
  // A4 = 440Hz, MIDI 69
  return 440.0 * pow(2.0, (midi - 69) / 12.0);
}

void setup() {
  pinMode(13, OUTPUT);
  pinMode(BTN_PIN, INPUT_PULLUP);

  digitalWrite(13, HIGH);

  // Kalibracja LDR przez 5s
  unsigned long start = millis();
  while (millis() - start < 5000) {
    sensorValue = analogRead(LDR_PIN);
    if (sensorValue > sensorHigh) sensorHigh = sensorValue;
    if (sensorValue < sensorLow)  sensorLow = sensorValue;
  }

  digitalWrite(13, LOW);
}

void loop() {
  // ====== Button: zmiana trybu ======
  bool btn = digitalRead(BTN_PIN);
  if (lastBtn == HIGH && btn == LOW) { // klik
    mode = (mode + 1) % 3;

    // mały "klik" dźwiękowy jako feedback
    tone(BUZZER_PIN, 1200, 60);
    delay(80);
  }
  lastBtn = btn;

  // ====== Odczyty ======
  int ldr = analogRead(LDR_PIN);
  int pot = analogRead(POT_PIN);

  // tempo z potencjometru (ms)
  int tempo = map(pot, 0, 1023, 20, 250);

  // zabezpieczenie mapowania, żeby nie dzielić przez 0 i nie mieć odwrotnych zakresów
  int lo = sensorLow;
  int hi = sensorHigh;
  if (hi - lo < 10) { hi = lo + 10; }

  // normalizacja LDR do 0..1023
  int norm = map(ldr, lo, hi, 0, 1023);
  norm = constrain(norm, 0, 1023);

  // baza (rejestr) — możesz zmienić na 48/60/72
  int baseMidi = 60; // C4

  // wybierz nutę ze skali zależnie od LDR
  int midi = pickFromScale(norm, baseMidi);
  int freq = (int) midiToFreq(midi);

  // graj krótko i często 
  tone(BUZZER_PIN, freq, 20);
  delay(tempo);
}
