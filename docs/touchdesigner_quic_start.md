---
title: "Touchdesigner – Cheat Sheet"
nav_order: 2
---

# 🎛️ TOUCHDESIGNER - QUICK START GUIDE
## Visual Programming dla artystów
---

## 📥 INSTALACJA

**Strona:** https://derivative.ca/
**Wersja:** TouchDesigner (darmowa, non-commercial)
**System:** Windows lub Mac

**Wymagania:**
- Dobra karta graficzna (GPU)
- 8GB RAM minimum
- ~500MB miejsca

---

## 🎯 CO TO JEST TOUCHDESIGNER?

**Node-based programming** - programowanie przez łączenie pudełek!

**Używane do:**
- Instalacje interaktywne
- VJ-ing (wizualizacje na koncertach)
- Mapping projekcyjny
- Real-time visual effects
- Generatywna grafika
- Audio-reactive art

**Kto używa:**
- Amon Tobin (koncerty)
- teamLab (instalacje)
- Marshmello (show)
- Setki artystów VJ

---

## 🧩 TYPY OPERATORÓW (OPs)

TouchDesigner dzieli operatory na **4 rodziny** (kolory):

### 🟦 TOP (Texture Operators) - 2D obrazy/video
```
Movie File In    - wczytaj video
Noise            - generuj szum
Circle           - narysuj koło
Blur             - rozmyj
Over             - połącz dwa obrazy
Composite        - blend
Level            - jasność/kontrast
Transform        - przesuń/obróć/skaluj
Feedback         - pętla zwrotna
```

### 🟩 CHOP (Channel Operators) - liczby, audio, motion
```
Audio Device In  - mikrofon/line in
LFO              - oscylator (sinus, saw, square)
Math             - operacje matematyczne
Noise            - Perlin noise
Timer            - czas
Lag              - wygładzanie
CHOP to           - konwersja do innych typów
```

### 🟪 SOP (Surface Operators) - geometria 3D
```
Box              - sześcian
Sphere           - kula
Grid             - siatka
Tube             - cylinder
Transform        - przesuń/obróć obiekt 3D
```

### 🟨 DAT (Data Operators) - tekst, tabele, skrypty
```
Text             - tekst
Table            - tabela danych
Serial           - komunikacja Serial
OSC In/Out       - komunikacja OSC
Script           - Python/JavaScript
```

---

## 🔗 PODSTAWOWE OPERACJE

### Tworzenie noda:
1. **Double-click** w pustym miejscu → wpisz nazwę
2. Lub **TAB** → wpisz nazwę
3. Lub **prawy przycisk** → Add Operator

### Łączenie nodów:
- Przeciągnij z **output** (prawa strona) do **input** (lewa strona)
- Jeden output → wiele inputów = OK!
- Wiele outputów → jeden input = tylko ostatnie połączenie działa

### Podgląd:
- **Kliknij** na nod = podgląd u dołu (viewer)
- **Active viewer** (podświetlony) = główny podgląd
- **Middle-click** = viewer pełnoekranowy

### Parametry:
- Kliknij nod → panel parametrów po prawej
- Możesz wpisać wartości
- Możesz podłączyć CHOP do parametru!

---

## 🎨 PIERWSZY PROJEKT: Noise Animation

**Cel:** Animowany szum

**Kroki:**

1. **Stwórz Noise TOP**
   - Tab → wpisz "noise" → Enter
   - Parametry (po prawej):
     - Period: 100
     - Amplitude: 1

2. **Parametry czasowe**
   - Kliknij na "Translate" → X
   - Zamiast liczby wpisz: `absTime.seconds * 0.1`
   - Szum będzie się poruszał!

3. **Dodaj kolor**
   - Tab → "level"
   - Połącz: Noise → Level
   - Parametry Level:
     - Brightness: 0.5
     - Gamma: 1.2

4. **Null (output)**
   - Tab → "null"
   - Połącz: Level → Null
   - Nazwij: "OUT"
   - To Twój finalny output!

**Gotowe!** Zobacz jak się rusza ✨

---

## 🎧 DRUGI PROJEKT: Audio Reactive

**Cel:** Wizualizacja reagująca na dźwięk

**Kroki:**

1. **Audio In**
   ```
   Tab → "audioddevicein"
   Parametry:
   - Device: wybierz mikrofon lub line in
   - Number of Channels: 1 (mono)
   ```

2. **Audio Spectrum (CHOP)**
   ```
   Tab → "audiofilter"
   Połącz: Audio Device In → Audio Filter
   Parametry:
   - Filter Type: Spectrum
   ```

3. **CHOP to TOP (konwersja)**
   ```
   Tab → "choptotop"
   Połącz: Audio Filter → CHOP to TOP
   To zamienia liczby z audio na obraz!
   ```

4. **Noise (wizualizacja)**
   ```
   Tab → "noise"
   Kliknij na parametr "Amplitude"
   Kliknij strzałkę "+" obok wartości
   Wybierz: CHOP → choptotop1
   
   Teraz amplitude zależy od głośności! 🎶
   ```

5. **Circle (kształt)**
   ```
   Tab → "circle"
   Połącz: Noise → Circle
   Parametry Circle:
   - Radius: połącz z CHOP to TOP (jak wyżej)
   ```

**Gotowe!** Mów do mikrofonu / włącz muzykę!

---

## 🔌 TRZECI PROJEKT: Arduino → TouchDesigner

**Cel:** Potencjometr steruje wizualizacją

**Arduino kod:**
```cpp
void setup() {
  Serial.begin(9600);
}

void loop() {
  int val = analogRead(A0);
  Serial.println(val);
  delay(50);
}
```

**TouchDesigner:**

1. **Serial DAT**
   ```
   Tab → "serial"
   Parametry:
   - Port: wybierz Arduino (np. COM3, /dev/tty.usb...)
   - Baud Rate: 9600
   - Row/Callback Format: "One Per Line"
   ```

2. **Convert DAT**
   ```
   Tab → "convert"
   Połącz: Serial → Convert
   To zamienia tekst na liczby
   ```

3. **DAT to CHOP**
   ```
   Tab → "dattochop"
   Połącz: Convert → DAT to CHOP
   ```

4. **Math CHOP (skalowanie)**
   ```
   Tab → "math"
   Połącz: DAT to CHOP → Math
   Parametry:
   - Combine CHOPs: Add
   - From Range: 0 to 1023
   - To Range: 0 to 1
   ```

5. **Użyj w wizualizacji**
   ```
   Tab → "noise"
   Parametr "Period" → połącz z Math CHOP
   
   Teraz kręcenie potencjometrem zmienia noise! 🎛️
   ```

---

## 📤 SYPHON/SPOUT - WYSYŁANIE VIDEO

**Syphon** = Mac | **Spout** = Windows

**Cel:** Wyślij obraz z TD do innych programów

**TouchDesigner:**
```
[Twoja wizualizacja] → [Syphon/Spout Out TOP]

Parametry Syphon/Spout Out:
- Server Name: "TD_Output"
```

**Processing (odbieranie):**
```java
import codeanticode.syphon.*;  // Mac
// import spout.*;              // Windows

SyphonClient client;
PGraphics canvas;

void setup() {
  size(1280, 720, P2D);
  client = new SyphonClient(this, "TD_Output");
}

void draw() {
  if (client.available()) {
    canvas = client.getGraphics(canvas);
    image(canvas, 0, 0);
  }
}
```

**Teraz masz:**
```
TouchDesigner (generuje) 
    → Syphon/Spout (wysyła) 
    → Processing (odbiera + przetwarza)
```

---

## 💡 PRZYDATNE WSKAZÓWKI

### Organizacja projektu:
- Używaj **Null TOP** jako "checkpointy"
- Nazywaj nody opisowo
- Grupuj związane nody w **Container**
- Komentarze: prawy przycisk → Annotate

### Performance:
- **Resolution** - zmniejsz jeśli laguje
- **Cook Type** - "Auto" vs "Always"
- **Viewer Active** - wyłącz niepotrzebne
- **Replicator** - klonuj zamiast kopiować

### Skróty klawiszowe:
- **Tab** - create operator
- **Space** - network view vs viewer
- **P** - parametry
- **U** - connections up
- **D** - connections down
- **Ctrl+D** - duplicate
- **Alt + przeciągnij** - panorama

### Export:
- **Movie File Out TOP** - zapisz video
- **JPEG Out TOP** - zapisz obrazy
- **Perform Mode** - pełny ekran (Alt+F)

---

## 🎯 PRZYKŁADOWE PROJEKTY

### 1. VJ Loop Generator
```
[Noise TOP] → [Kaleidoscope TOP] → [Level TOP] → [Feedback TOP] → [Null "OUT"]
                                           ↑
                                    [LFO CHOP] (kontroluje brightness)
```

### 2. Webcam Effects
```
[Video Device In TOP] → [Edge TOP] → [Composite TOP] ← [Original]
                                           ↓
                                       [Null "OUT"]
```

### 3. Audio Visualizer
```
[Audio Device In] → [Audio Spectrum] → [CHOP to TOP] → [Lookup TOP] → [Circle TOP]
                                                              ↑
                                                      [Ramp TOP] (color map)
```

### 4. Particle System
```
[Noise TOP] → [Displace SOP] → [Instance SOP] → [Geo TOP] → [Null "OUT"]
    ↑                               ↑
[Timer CHOP]                 [Sphere SOP]
```

---

## 📚 ZASOBY DO NAUKI

**Oficjalne:**
- https://derivative.ca/UserGuide/ - dokumentacja
- https://learn.derivative.ca/ - tutorials
- https://forum.derivative.ca/ - forum

**YouTube:**
- "The Interactive & Immersive HQ"
- "elburz"
- "PPPANIK"
- "Bileam Tschepe"

**Społeczność:**
- Discord: TouchDesigner
- Instagram: #touchdesigner
- Reddit: r/TouchDesigner

---

## 🐛 NAJCZĘSTSZE PROBLEMY

**"No Image"**
- Sprawdź czy nod jest "cooked" (zielony pasek)
- Sprawdź resolution (może być 0x0)

**Lag / Niska wydajność**
- Zmniejsz resolution
- Wyłącz niepotrzebne viewers
- Sprawdź GPU usage (Alt+D)

**"Can't connect nodes"**
- Sprawdź typy (TOP → TOP, CHOP → CHOP)
- Konwersja: CHOP to TOP, DAT to CHOP, etc.

**Serial nie działa**
- Sprawdź port (może być zajęty)
- Sprawdź baud rate
- Zamknij Serial Monitor w Arduino IDE!

---

## 🚀 NASTĘPNE KROKI

Po opanowaniu podstaw:
1. **Python scripting** - automatyzacja
2. **GLSL shaders** - custom effects
3. **3D** - geometria i render
4. **Instancing** - particle systems
5. **Projection mapping** - wieloprojekcyjne instalacje

**Baw się i eksperymentuj!** ✨
