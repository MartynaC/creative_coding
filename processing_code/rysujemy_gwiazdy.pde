/**
 * Star (Gwiazda)
 * 
 * Funkcja star() stworzona dla tego przykładu potrafi rysować
 * szeroki zakres różnych form gwiazdek. Spróbuj wstawiać różne liczby
 * do wywołań funkcji star() w draw(), żeby odkryć różne możliwości.
 */

void setup() {
  // Tworzymy okno o wymiarach 640x360 pikseli
  size(640, 360);
}

void draw() {
  // Ustawiamy szare tło (102 w skali 0-255)
  background(102);
  
  // === PIERWSZA GWIAZDA (lewa) ===
  // pushMatrix() - zapisujemy aktualny układ współrzędnych
  // (żeby transformacje nie wpływały na następne obiekty)
  pushMatrix();
  
  // Przesuwamy początek układu współrzędnych na pozycję:
  // width*0.2 - 20% szerokości okna (lewo)
  // height*0.5 - 50% wysokości okna (środek w pionie)
  translate(width*0.2, height*0.5);
  
  // Obracamy układ współrzędnych:
  // frameCount - numer aktualnej klatki (rośnie w czasie)
  // /200.0 - dzielimy przez 200, więc obrót jest powolny
  rotate(frameCount / 200.0);
  
  // Rysujemy gwiazdę w nowym układzie współrzędnych:
  // (0, 0) - środek (bo przesunęliśmy się translate)
  // 5 - promień wewnętrzny (krótsze ramiona)
  // 70 - promień zewnętrzny (dłuższe ramiona)
  // 3 - liczba ramion gwiazdy
  star(0, 0, 5, 70, 3); 
  
  // popMatrix() - wracamy do poprzedniego układu współrzędnych
  // (anulujemy translate i rotate)
  popMatrix();
  
  // === DRUGA GWIAZDA (środkowa) ===
  pushMatrix();
  
  // Przesuwamy na środek okna (50% szerokości i wysokości)
  translate(width*0.5, height*0.5);
  
  // Obracamy wolniej (dzielimy przez 400)
  rotate(frameCount / 400.0);
  
  // Rysujemy większą gwiazdę z małą różnicą między promieniami:
  // 80 - promień wewnętrzny
  // 100 - promień zewnętrzny
  // 40 - dużo ramion (prawie okrąg)
  star(0, 0, 80, 100, 40); 
  
  popMatrix();
  
  // === TRZECIA GWIAZDA (prawa) ===
  pushMatrix();
  
  // Przesuwamy na prawą stronę (80% szerokości)
  translate(width*0.8, height*0.5);
  
  // Obracamy w przeciwnym kierunku (minus) i szybciej (/100)
  rotate(frameCount / -100.0);
  
  // Rysujemy średnią gwiazdę z 5 ramionami (klasyczna gwiazda)
  star(0, 0, 30, 70, 5); 
  
  popMatrix();
}

// FUNKCJA RYSUJĄCA GWIAZDĘ
// x, y - współrzędne środka gwiazdy
// radius1 - promień wewnętrzny (krótsze wierzchołki)
// radius2 - promień zewnętrzny (dłuższe wierzchołki)
// npoints - liczba ramion gwiazdy
void star(float x, float y, float radius1, float radius2, int npoints) {
  
  // Obliczamy kąt między kolejnymi ramionami:
  // TWO_PI to 360 stopni (2π radianów)
  // Dzielimy przez liczbę ramion
  float angle = TWO_PI / npoints;
  
  // Obliczamy połowę tego kąta (dla wewnętrznych wierzchołków)
  float halfAngle = angle/2.0;
  
  // Zaczynamy rysować kształt (seria połączonych punktów)
  beginShape();
  
  // Pętla: przechodzimy wokół okręgu, rysując ramiona
  // a - aktualny kąt, zaczynamy od 0 i idziemy do 360 stopni (TWO_PI)
  // a += angle - w każdej iteracji przeskakujemy o jeden kąt ramienia
  for (float a = 0; a < TWO_PI; a += angle) {
    
    // === ZEWNĘTRZNY WIERZCHOŁEK (dłuższy) ===
    // Obliczamy pozycję X używając cosinusa kąta * promień zewnętrzny
    float sx = x + cos(a) * radius2;
    // Obliczamy pozycję Y używając sinusa kąta * promień zewnętrzny
    float sy = y + sin(a) * radius2;
    // Dodajemy ten punkt do kształtu
    vertex(sx, sy);
    
    // === WEWNĘTRZNY WIERZCHOŁEK (krótszy) ===
    // Podobnie, ale:
    // - używamy kąta przesuniętego o połowę (a+halfAngle)
    // - używamy krótszego promienia (radius1)
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    // Dodajemy ten punkt do kształtu
    vertex(sx, sy);
    
    // Pętla powtarza się, rysując naprzemiennie długie i krótkie ramiona
  }
  
  // Kończymy rysowanie i zamykamy kształt (łączymy ostatni punkt z pierwszym)
  endShape(CLOSE);
}
