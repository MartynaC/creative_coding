/**
 * Interaktywna Gwiazda z czujnikiem światła
 * 
 * Gwiazda zmienia swoją wielkość w zależności od ilości światła
 * wykrytego przez czujnik podłączony do Arduino.
 */

// Importujemy bibliotekę do komunikacji z Arduino
import processing.serial.*;

// Zmienna do komunikacji przez port szeregowy
Serial port;

// Zmienna przechowująca aktualny poziom światła z czujnika (0-1023)
int lightLevel = 0;

void setup() {
  // Tworzymy okno o wymiarach 640x360 pikseli
  size(640, 360);
  
  // Wyświetlamy listę dostępnych portów w konsoli
  // (pomoże znaleźć właściwy numer portu Arduino)
  println(Serial.list());
  
  // Łączymy się z Arduino:
  // UWAGA: Zmień [4] na odpowiedni numer portu z listy powyżej!
  port = new Serial(this, Serial.list()[4], 9600);
  
  // Czekamy na dane do momentu otrzymania znaku nowej linii
  port.bufferUntil('\n');
}

void draw() {
  // Ustawiamy szare tło
  background(102);
  
  // Konwertujemy wartość światła (0-1023) na promień zewnętrzny gwiazdy (20-150 pikseli)
  // Im więcej światła, tym większa gwiazda
  float outerRadius = map(lightLevel, 0, 1023, 20, 150);
  
  // Promień wewnętrzny to połowa promienia zewnętrznego
  // Dzięki temu proporcje gwiazdy pozostają ładne
  float innerRadius = outerRadius * 0.5;
  
  // Zapisujemy aktualny układ współrzędnych
  pushMatrix();
  
  // Przesuwamy początek układu na środek ekranu
  translate(width*0.5, height*0.5);
  
  // Obracamy układ współrzędnych - gwiazda będzie się kręcić
  // frameCount to numer klatki, dzielimy przez 200 dla powolnego obrotu
  rotate(frameCount / 200.0);
  
  // Rysujemy gwiazdę w środku układu współrzędnych:
  // (0, 0) - środek (bo użyliśmy translate)
  // innerRadius - promień wewnętrzny (krótsze ramiona)
  // outerRadius - promień zewnętrzny (dłuższe ramiona) - ZALEŻY OD ŚWIATŁA
  // 5 - liczba ramion (klasyczna pięcioramienna gwiazda)
  star(0, 0, innerRadius, outerRadius, 5);
  
  // Wracamy do poprzedniego układu współrzędnych
  popMatrix();
  
  // === INFORMACJA NA EKRANIE ===
  // Wyświetlamy aktualny poziom światła w lewym górnym rogu
  fill(255); // Biały tekst
  textSize(16);
  text("Poziom światła: " + lightLevel, 10, 20);
  text("Rozmiar gwiazdy: " + int(outerRadius), 10, 40);
}

// FUNKCJA WYWOŁYWANA AUTOMATYCZNIE gdy Arduino wysyła dane
void serialEvent(Serial port) {
  // Czytamy dane do momentu napotkania znaku nowej linii '\n'
  String data = port.readStringUntil('\n');
  
  // Sprawdzamy czy otrzymaliśmy jakieś dane
  if (data != null) {
    // Usuwamy białe znaki z początku i końca (spacje, enter)
    data = trim(data);
    
    // Konwertujemy tekst na liczbę całkowitą
    // To jest wartość z czujnika światła Arduino (analogRead)
    lightLevel = int(data);
    
    // Opcjonalnie: wyświetl w konsoli dla debugowania
    // println("Otrzymano: " + lightLevel);
  }
}

// FUNKCJA RYSUJĄCA GWIAZDĘ
// x, y - współrzędne środka gwiazdy
// radius1 - promień wewnętrzny (krótsze wierzchołki)
// radius2 - promień zewnętrzny (dłuższe wierzchołki)
// npoints - liczba ramion gwiazdy
void star(float x, float y, float radius1, float radius2, int npoints) {
  
  // Obliczamy kąt między kolejnymi ramionami
  // TWO_PI to 360 stopni (pełny okrąg)
  float angle = TWO_PI / npoints;
  
  // Połowa kąta - dla wewnętrznych wierzchołków
  float halfAngle = angle/2.0;
  
  // Zaczynamy rysować kształt
  beginShape();
  
  // Pętla: przechodzimy po okręgu rysując ramiona gwiazdy
  for (float a = 0; a < TWO_PI; a += angle) {
    
    // ZEWNĘTRZNY WIERZCHOŁEK (długi)
    // cos(a) i sin(a) dają pozycję na okręgu
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    
    // WEWNĘTRZNY WIERZCHOŁEK (krótki)
    // Przesunięty o pół kąta, z mniejszym promieniem
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  
  // Kończymy i zamykamy kształt
  endShape(CLOSE);
}
