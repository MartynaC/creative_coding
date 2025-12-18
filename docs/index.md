---
title: "Processing – Podstawy"
nav_order: 1
---

# 📝 PROCESSING - CHEAT SHEET
{: .no_toc }

<div class="local-layout">

<div class="local-toc" markdown="1">

## Spis treści
{: .no_toc .text-delta }

1. TOC
{:toc}

</div>

<div class="local-content" markdown="1">

---

## 🎯 STRUKTURA PROGRAMU

```java
void setup() {
  // Uruchamia się RAZ na początku
  // Tutaj: rozmiar okna, ładowanie plików, inicjalizacja
}

void draw() {
  // Uruchamia się W KÓŁKO (domyślnie 60 razy na sekundę)
  // Tutaj: rysowanie, animacje, aktualizacje
}
```

---

---

## 🪟 OKNO I TŁO

```java
size(800, 600);        // Rozmiar okna: szerokość, wysokość
background(255);       // Białe tło (0 = czarny, 255 = biały)
background(r, g, b);   // Kolorowe tło (RGB)
```

---

---

## 🎨 KOLORY

```java
// WYPEŁNIENIE (fill)
fill(255);             // bIAŁY (0-255)
fill(255, 0, 0);       // RGB: czerwony
fill(255, 0, 0, 128);  // RGBA: czerwony półprzezroczysty (alpha)
noFill();              // Bez wypełnienia

// OBRAMOWANIE (stroke)  
stroke(0);             // Czarne obramowanie
stroke(r, g, b);       // Kolorowe obramowanie
strokeWeight(5);       // Grubość linii
noStroke();            // Bez obramowania
```

---

---



## 📐 KSZTAŁTY

```java
// PUNKT
point(x, y);

// LINIA
line(x1, y1, x2, y2);

// PROSTOKĄT
rect(x, y, szerokość, wysokość);
rect(x, y, szer, wys, zaokrąglenie);

// KOŁO
circle(x, y, średnica);

// ELIPSA
ellipse(x, y, szerokość, wysokość);

// TRÓJKĄT
triangle(x1, y1, x2, y2, x3, y3);

// WIELOKĄT (dowolny kształt)
beginShape();
vertex(x1, y1);
vertex(x2, y2);
vertex(x3, y3);
endShape(CLOSE);  // CLOSE = zamknij kształt
```

---

---


## ✍️ TEKST

```java
textSize(32);                  // Rozmiar czcionki
textAlign(CENTER, CENTER);     // Wyrównanie: LEFT, CENTER, RIGHT
fill(255);                     // Kolor tekstu
text("Hello!", x, y);          // Wyświetl tekst
text(zmienna, x, y);          // Wyświetl wartość zmiennej
```

---

---

## 🔢 ZMIENNE SYSTEMOWE

```java
width              // Szerokość okna
height             // Wysokość okna
mouseX             // Pozycja myszy X
mouseY             // Pozycja myszy Y
mousePressed       // true jeśli mysz wciśnięta
key                // Ostatnio wciśnięty klawisz
frameCount         // Licznik klatek (rośnie co klatkę)
```

---

---

## 🎲 MATEMATYKA

```java
// LOSOWOŚĆ
random(10);              // Losowa liczba 0-10
random(5, 10);           // Losowa liczba 5-10

// MAPOWANIE (przeliczanie zakresów)
map(wartosc, minStare, maxStare, minNowe, maxNowe)
// Przykład: map(wartosc, 0, 1023, 0, width)
// Zamienia wartosc z zakresu 0-1023 na odpowiedną wartość w zakresie 0-width

// OGRANICZANIE (constrain)
constrain(wartość, min, max);
// Przykład: constrain(mouseX, 0, 100) - max 100

// PRZYDATNE FUNKCJE
abs(x)                // Wartość bezwzględna
pow(n, e)             // Potęga n^e
sqrt(n)               // Pierwiastek
sin(kąt), cos(kąt)    // Funkcje trygonometryczne
radians(stopnie)      // Zamień stopnie na radiany
```

---

---

## 🔁 PĘTLE

```java
// FOR - określona liczba powtórzeń
for (int i = 0; i < 10; i++) {
  println(i);  // Wypisz 0, 1, 2, ... 9
}

// WHILE - dopóki warunek prawdziwy
int i = 0;
while (i < 10) {
  println(i);
  i++;
}
```

---

---

## ❓ WARUNKI

```java
// IF / ELSE IF / ELSE
if (mouseX > width/2) {
  fill(255, 0, 0);     // Czerwony
} else if (mouseX > width/4) {
  fill(0, 255, 0);     // Zielony
} else {
  fill(0, 0, 255);     // Niebieski
}

// OPERATORY PORÓWNANIA
==   // Równe
!=   // Różne
>    // Większe
<    // Mniejsze
>=   // Większe lub równe
<=   // Mniejsze lub równe

// OPERATORY LOGICZNE
&&   // AND (i)
||   // OR (lub)
!    // NOT (zaprzeczenie)
```

---

## 🖱️ WYDARZENIA (EVENTS)

```java
void mousePressed() {
  // Uruchamia się gdy klikniesz myszą
}

void mouseReleased() {
  // Uruchamia się gdy puścisz przycisk myszy
}

void mouseDragged() {
  // Uruchamia się gdy przeciągasz przy wciśniętym przycisku
}

void keyPressed() {
  // Uruchamia się gdy naciśniesz klawisz
  if (key == ' ') {
    // Spacja
  }
  if (key == 'a' || key == 'A') {
    // Litera A (mała lub wielka)
  }
}
```

---

---

## 💾 ZAPISYWANIE

```java
save("obraz.png");           // Zapisz aktualną klatkę
saveFrame("klatka-####.png"); // Zapisz z numerem (0001, 0002...)
```

---

---

## 📊 LISTY (ArrayList)

```java
// Tworzenie listy
ArrayList<Integer> liczby = new ArrayList<Integer>();

// Dodawanie
liczby.add(10);
liczby.add(20);

// Odczytywanie
int pierwsza = liczby.get(0);  // Indeksy od 0!

// Rozmiar
int ile = liczby.size();

// Usuwanie
liczby.remove(0);  // Usuń element o indeksie 0

// Czyszczenie
liczby.clear();    // Usuń wszystko
```

---

---

## 🎨 TRANSFORMACJE

```java
push();                    // Zapisz stan
translate(x, y);           // Przesuń punkt odniesienia
rotate(radians(45));       // Obróć o 45 stopni
scale(2);                  // Powiększ 2x
pop();                     // Przywróć stan
```

---

---

## 💡 PRZYDATNE TRYBY

```java
// TRYB KOLORU
colorMode(RGB, 255);       // Domyślny: RGB 0-255
colorMode(HSB, 360, 100, 100);  // Odcień, Nasycenie, Jasność

// TRYB KSZTAŁTÓW
rectMode(CORNER);          // x,y = lewy górny róg (domyślne)
rectMode(CENTER);          // x,y = środek
ellipseMode(CENTER);       // domyślne dla kół
```

---


---

## 🐛 DEBUGOWANIE

```java
println("Wartość: " + zmienna);  // Wypisz w konsoli
print("Bez nowej linii");        // Wypisz bez enter
printArray(tablica);             // Wypisz całą tablicę
```

---


---

## ⚡ OPTYMALIZACJA

```java
frameRate(30);             // Ogranicz do 30 FPS (oszczędza CPU)
noLoop();                  // Zatrzymaj draw() - rysuj tylko raz
loop();                    // Wznów draw()
redraw();                  // Narysuj jedną klatkę (gdy noLoop)
```

---

---


## 🎯 INTERAKCJA - POZYCJA KÓŁKA 

```java
// Zmienne globalne
int x = 0;
int szybkosc = 2;

void setup() {
  size(800, 600);
  background(255);
}

void draw() {
  // Wyczyszczenie tła
  background(255, 255, 255, 10);  // Efekt śladu
  
  // Rysowanie
  fill(255, 0, 0);
  noStroke();
  circle(x, height/2, 50);
  
  // Aktualizacja
  x = x + szybkosc;
  
  // Odbicie od krawędzi
  if (x > width || x < 0) {
    szybkosc = szybkosc * -1;
  }
}

void mousePressed() {
  // Kliknięcie zmienia kierunek
  szybkosc = szybkosc * -1;
}

void keyPressed() {
  // Spacja przyspiesza
  if (key == ' ') {
    szybkosc = szybkosc * 2;
  }
}
```


---

## 💪 NAJCZĘSTSZE BŁĘDY

1. **Zapomnienie średnika `;`** - każda linia musi kończyć się średnikiem!
2. **Nawiasy** - otwarte `{` muszą mieć zamknięte `}`
3. **Wielkość liter** - `circle` ≠ `Circle` (Processing rozróżnia!)
4. **Kolejność** - `fill()` PRZED `circle()`, nie po!
5. **Indeksy** - listy zaczynają się od 0, nie od 1!

---

---

```python

```

---


</div> <!-- .local-content --> </div> <!-- .local-layout -->