---
title: "Touchdesigner"
nav_order: 3
---

# 🎨 TOUCHDESIGNER VISUAL CHEAT SHEET
{: .no_toc }

<div class="local-layout">

<div class="local-toc" markdown="1">

## Spis treści
{: .no_toc .text-delta }

1. TOC
{:toc}

</div>

<div class="local-content" markdown="1">

## Wizualna ściąga dla beginnerów

---

## 🎯 CO TO JEST TOUCHDESIGNER?

**Visual Programming Environment**
- Zamiast pisać kod → łączysz "operatory" (nodes)
- Real-time → widzisz efekty od razu
- Pipeline data → dane płyną między operatorami

**Gdzie się używa?**
- Instalacje artystyczne
- VJ performance (live visuals)
- Mapping projekcyjny
- Interactive experiences
- Generative art

---

## 🌈 4 RODZINY OPERATORÓW

```
┌─────────────────────────────────────────────────────────┐
│                  TOUCHDESIGNER FAMILIES                  │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  🟦 TOP (Texture)        🟩 CHOP (Channel)             │
│     Obrazy, Video           Liczby, Audio              │
│     2D operacje             Wartości w czasie          │
│     Efekty wizualne         Control data               │
│                                                          │
│  🟪 SOP (Surface)        🟨 DAT (Data)                 │
│     Geometria 3D            Tekst, Tabele              │
│     Meshes, Points          Python scripts             │
│     Particles               JSON, CSV                   │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## 🟦 TOP - TEXTURE OPERATORS

### Najpopularniejsze TOP:

```
[Noise TOP]          Generuje szum Perlina
[Movie File In TOP]  Wczytuje video z pliku
[Text TOP]           Renderuje tekst
[Circle TOP]         Rysuje koło
[Rectangle TOP]      Rysuje prostokąt
[Level TOP]          Brightness/Contrast/Gamma
[Transform TOP]      Translate/Rotate/Scale
[Composite TOP]      Łączy 2 obrazy
[Blur TOP]           Rozmywa obraz
[Over TOP]           Nakłada jeden obraz na drugi
[Feedback TOP]       Feedback loop (efekty!)
[Null TOP]           Output (czysty pass-through)
```

### Przykładowy pipeline:

```
[Noise TOP]
    ↓
[Level TOP]
 (brightness)
    ↓
[Circle TOP]
    ↓
[Composite TOP] ← [Text TOP]
    ↓
[Blur TOP]
    ↓
[Null "OUT"]
```

### Animacja w TOP:

**absTime.seconds** - czas od startu (sekundy)
**absTime.frame** - numer klatki

Przykład:
```
[Noise TOP]
  Translate X: absTime.seconds * 0.1
  Translate Y: sin(absTime.seconds) * 0.5
  Period: 100 + absTime.seconds * 10
```

---

## 🟩 CHOP - CHANNEL OPERATORS

### Najpopularniejsze CHOP:

```
[Constant CHOP]      Stała wartość
[Math CHOP]          Operacje matematyczne
[Lag CHOP]           Wygładzanie
[Noise CHOP]         Losowy szum
[LFO CHOP]           Low Frequency Oscillator (fala)
[Timer CHOP]         Licznik czasu
[Audio Device In]    Dźwięk z mikrofonu
[Audio Spectrum]     Analiza częstotliwości
[CHOP to TOP]        Konwersja CHOP → TOP
[Null CHOP]          Output
```

### Przykład - Audio Reactive:

```
[Audio Device In CHOP]
    ↓
[Audio Spectrum CHOP]
    ↓
[Math CHOP]
 (Range: 0-1)
    ↓
[CHOP to TOP]
    ↓
[Multiply TOP] → [Noise TOP]
```

### Math CHOP operacje:

```
Add         a + b
Subtract    a - b
Multiply    a * b
Divide      a / b
Range       Przeskaluj zakres (np. 0-1023 → 0-1)
```

---

## 🟪 SOP - SURFACE OPERATORS

### Podstawowe SOP:

```
[Box SOP]            Sześcian
[Sphere SOP]         Kula
[Grid SOP]           Siatka
[Line SOP]           Linia
[Circle SOP]         Okrąg
[Text SOP]           Tekst 3D
[Transform SOP]      Translate/Rotate/Scale
[Noise SOP]          Deformacja szumem
[Copy SOP]           Kopiuje geometrię
[Null SOP]           Output
```

### Przykład - Rotating Box:

```
[Box SOP]
    ↓
[Transform SOP]
  Rotate Y: absTime.seconds * 60
    ↓
[Null "box_out"]
```

---

## 🟨 DAT - DATA OPERATORS

### Podstawowe DAT:

```
[Text DAT]           Tekst/kod
[Table DAT]          Tabela
[Serial DAT]         Komunikacja Serial (Arduino!)
[Convert DAT]        Konwersja typów
[Select DAT]         Wybiera dane
[DAT to CHOP]        Konwersja DAT → CHOP
[Script DAT]         Python kod
[Null DAT]           Output
```

### Arduino → TouchDesigner:

```
[Serial DAT]
  Port: /dev/cu.usbserial (Mac) lub COM3 (Windows)
  Baud Rate: 9600
    ↓
[Convert DAT]
  (tekst → liczba)
    ↓
[DAT to CHOP]
    ↓
[Math CHOP]
  Range: 0-1023 → 0-1
    ↓
Użyj w TOP!
```

---

## ⚡ PODSTAWOWE OPERACJE

### Tworzenie operatora:

1. Kliknij w pustym miejscu **TAB**
2. Wpisz nazwę (np. "noise")
3. **ENTER**

### Łączenie operatorów:

```
┌─────────┐
│ Noise   │ ← Wejście (input)
│         │
└────┬────┘
     │ Połącz przeciągając
     ↓
┌────┴────┐
│ Level   │
└─────────┘
```

### Podgląd:

- **Klik** na operator → viewer u dołu
- **Middle-click** (scroll) → full-screen viewer

### Parametry:

Kliknij operator → po prawej stronie parametry

**Expression mode:**
- **Constant** = stała wartość
- **Expression** = formuła (np. absTime.seconds)
- **Export** = połącz z CHOP

---

## 🔗 REFERENCJE (CONNECTIONS)

### Połącz CHOP z parametrem:

**Metoda 1: Drag & Drop**
```
Przeciągnij CHOP → na parametr (np. Brightness)
```

**Metoda 2: Export**
```
1. Klik prawy na CHOP → Export
2. Wybierz parametr (np. level1:brightness)
```

### Przykład:

```
[Noise CHOP]           [Noise TOP]
  Frequency: 1    →    Period: noise1[0]
  Amplitude: 1         
     ↓
  (steruje Period w Noise TOP)
```

---

## 📊 WZORY I WYRAŻENIA

### absTime:

```
absTime.seconds     Sekundy od startu
absTime.frame       Numer klatki
```

### me (self-reference):

```
me.time.seconds     Czas
me.width            Szerokość operatora
me.height           Wysokość operatora
```

### Operatory matematyczne:

```
+   Dodawanie
-   Odejmowanie
*   Mnożenie
/   Dzielenie
**  Potęga
```

### Funkcje:

```
sin(x)      Sinus
cos(x)      Cosinus
abs(x)      Wartość bezwzględna
int(x)      Liczba całkowita
```

### Przykłady:

```
absTime.seconds * 50                    Liniowy wzrost
sin(absTime.seconds) * 100              Fala sinusoidalna
abs(sin(absTime.seconds * 2)) * 255     Pulsacja
int(absTime.seconds) % 2                0,1,0,1... co sekundę
```

---

## 🎨 PRZYKŁADOWE PROJEKTY

### 1. PODSTAWOWA ANIMACJA

```
[Noise TOP]
  Translate X: absTime.seconds * 0.1
  Period: 100
    ↓
[Level TOP]
  Brightness: 1.2
    ↓
[Null "OUT"]
```

### 2. AUDIO-REACTIVE

```
[Audio Device In CHOP]
    ↓
[Audio Spectrum CHOP]
    ↓
[CHOP to TOP]
    ↓
[Multiply TOP] ← [Noise TOP]
                   (Period: 50)
    ↓
[Blur TOP]
  Filter Width: 10
    ↓
[Null "OUT"]
```

### 3. ARDUINO CONTROL

```
ARDUINO:
Serial.println(analogRead(A0));

TOUCHDESIGNER:
[Serial DAT]
  Port: COM3
  Baud: 9600
    ↓
[Convert DAT]
    ↓
[DAT to CHOP]
    ↓
[Math CHOP]
  From Range: 0-1023
  To Range: 0-1
    ↓
Export → [Noise TOP]:Period
```

### 4. FEEDBACK LOOP

```
[Noise TOP]
    ↓
[Transform TOP]
  Rotate: 0.1
    ↓
[Feedback TOP] ← ┐
    ↓            │
[Composite TOP]  │
  (Mix: 0.9)     │
    └────────────┘
    
Efekt: Nawarstwione, obracające się wzory!
```

### 5. GENERATIVE CIRCLES

```
[Circle TOP]
  Radius: abs(sin(absTime.seconds)) * 300
    ↓
[Transform TOP]
  Rotate: absTime.seconds * 30
    ↓
[Composite TOP] ← [Circle TOP]
                   Radius: 100
    ↓
[Level TOP]
  Contrast: 1.5
    ↓
[Null "OUT"]
```

---

## 🎛️ KLAWISZE I SHORTCUTS

```
TAB             Stwórz operator
SPACE           Play/Pause timeline
H               Home (fit all)
F               Frame selected
U               Network overview
P               Toggle parameter window
DELETE          Usuń operator
CTRL+D          Duplikuj
CTRL+C/V        Copy/Paste
ALT+LeftClick   Pan (przesuwanie)
Scroll          Zoom
```

---

## 🌊 SYPHON/SPOUT

### Wysyłanie (Output):

```
[Twoja wizualizacja]
    ↓
[Syphon Out TOP]  (Mac)
[Spout Out TOP]   (Windows)
  Server Name: "TD_Output"
```

### Odbieranie (Input):

```
[Syphon In TOP]   (Mac)
[Spout In TOP]    (Windows)
  Server: wybierz z listy
    ↓
[Twoje przetwarzanie]
```

---

## 🔥 EFEKTY I TRIKI

### 1. Kaleidoscope

```
[Noise TOP]
    ↓
[Kaleidoscope TOP]
  Sides: 6
```

### 2. Glitch Effect

```
[Movie File In TOP]
    ↓
[Displace TOP]
  Input: Noise TOP
  Amount: 50
    ↓
[Edge TOP]
```

### 3. Color Ramp

```
[Noise TOP]
    ↓
[Ramp TOP]
  (Custom colors)
```

### 4. Trails Effect

```
[Circle TOP]
    ↓
[Feedback TOP]
    ↓
[Composite TOP]
  Operation: Add
  Mix: 0.95
```

---

## 📐 RESOLUTION & PERFORMANCE

### Rozmiar obrazu:

```
[Noise TOP]
  Resolution: 1920x1080
  Pixel Format: 8-bit fixed (RGBA)
```

### Optymalizacja:

- Używaj niższej rozdzielczości (512x512) podczas testów
- **Alt+D** → Display performance
- Wyłącz niepotrzebne viewery
- Używaj **Null** jako output points

---

## 🐛 TROUBLESHOOTING

### Problem: Nie widzę obrazu
- ✅ Sprawdź czy operator jest "cooked" (zielony pasek)
- ✅ Kliknij operator → zobacz viewer
- ✅ Sprawdź Resolution (może być 0x0)

### Problem: Lag/wolno działa
- ✅ Zmniejsz Resolution
- ✅ Wyłącz viewery (klik prawy → Viewer Active)
- ✅ Alt+D → sprawdź GPU usage

### Problem: Serial nie działa
- ✅ Sprawdź port (Tools → Port)
- ✅ Zamknij Serial Monitor w Arduino
- ✅ Sprawdź Baud Rate (9600 w obu)

### Problem: Parametr nie zmienia się
- ✅ Sprawdź czy export działa (zielona strzałka)
- ✅ Sprawdź Range w Math CHOP
- ✅ Klik prawy na parametr → Clear Expression

---

## 🎯 WORKFLOW TIPS

### 1. Organizacja
```
Używaj Null jako output points:
[Complex Network] → [Null "out_final"]

Nazywaj operatory:
noise_main, audio_input, color_final
```

### 2. Containers
```
Grupuj związane operatory w Container:
Klik prawy → Create Container
```

### 3. Save często!
```
File → Save As
Wersjonuj: project_v1.toe, project_v2.toe
```

### 4. Comment
```
Kliknij prawy → Add Annotation
Opisz co robi dany fragment
```

---

## 📚 ZASOBY

**Oficjalna dokumentacja:**
- https://docs.derivative.ca/

**Tutorials:**
- Derivative YouTube Channel
- Matthew Ragan tutorials
- Interactive & Immersive HQ

**Community:**
- TouchDesigner Forum
- Reddit: r/TouchDesigner
- Discord: TouchDesigner Community

**Inspiracje:**
- https://www.derivative.ca/community-post
- Instagram: #touchdesigner

---

## 🚀 NASTĘPNE KROKI

1. **Podstawy** (jesteś tu!)
   - 4 rodzaje operatorów
   - Podstawowe połączenia
   - Proste animacje

2. **Intermediate**
   - GLSL Shaders
   - 3D Rendering
   - Instancing

3. **Advanced**
   - Python scripting
   - Custom components
   - Real-time performance

---

**PAMIĘTAJ:**
- Eksperymentuj! TD jest visual - widzisz efekty od razu
- Zapisuj wersje projektu
- Używaj Null jako checkpointów
- Community jest bardzo pomocne!

</div> <!-- .local-content -->

</div> <!-- .local-layout -->