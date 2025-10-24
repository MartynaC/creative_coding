// Importujemy bibliotekę do komunikacji przez port szeregowy (USB)
import processing.serial.*;

// Tworzymy zmienną do komunikacji z Arduino
Serial port;

// Zmienna przechowująca dane z serial portu arduino - np -potencjometr czy poziom światła z fotorezystora
int analogRead = 0;

void setup() {
  // Tworzymy okno o wymiarach 800x600 pikseli
  size(800, 600);
  
  // Wyświetlamy listę wszystkich dostępnych portów szeregowych w konsoli
  // (pomaga znaleźć odpowiedni numer portu Arduino)
  println(Serial.list());
  
  // Łączymy się z Arduino:
  // - Serial.list()[4] - wybieramy port o indeksie 4 (UWAGA: Twój może być inny!)
  // - 9600 - prędkość komunikacji (musi być taka sama jak w Arduino)
  port = new Serial(this, Serial.list()[4], 9600);
  
  // Czekamy na dane do momentu napotkania znaku nowej linii '\n'
  port.bufferUntil('\n');
  
  // Ustawiamy czarne tło na starcie
  background(0);
}

void draw() {
  // Konwertujemy wartość ze światła (0-1023) na rozmiar koła (50-400 pikseli)
  // map() przelicza wartość z jednego zakresu na drugi
  float size = map(analogRead, 0, 1023, 50, 400);
  
  // Ustawiamy kolor wypełnienia koła:
  // (100, 200, 255) - jasnoniebieski kolor
  // 150 - przezroczystość (alpha), dzięki czemu koło jest półprzezroczyste
  fill(100, 200, 255, 150);
  
  // Wyłączamy obramowanie koła
  noStroke();
  
  // Rysujemy koło pośrodku ekranu:
  // width/2 - środek szerokości okna
  // height/2 - środek wysokości okna
  // size, size - szerokość i wysokość koła (takie same = idealny okrąg)
  ellipse(width/2, height/2, size, size);
  
  // Efekt zanikania: nakładamy półprzezroczysty czarny prostokąt
  // (0, 20) - czarny kolor z małą przezroczystością
  // Dzięki temu poprzednie koła powoli znikają
  fill(0, 20);
  rect(0, 0, width, height);
}

// Ta funkcja uruchamia się automatycznie gdy Arduino wysyła dane
void serialEvent(Serial port) {
  // Czytamy tekst do momentu napotkania '\n' (nowa linia)
  String data = port.readStringUntil('\n');
  
  // Sprawdzamy czy otrzymaliśmy jakieś dane
  if (data != null) {
    // Usuwamy białe znaki (spacje, entery) z początku i końca
    data = trim(data);
    
    // Konwertujemy tekst na liczbę całkowitą i zapisujemy jako nasza zmienna trzymająca dane
    analogRead = int(data);
  }
}



import processing.serial.*;

Serial port;
int analogRead = 0;

void setup() {
  size(800, 600);
  println("Dostępne porty:");
  println(Serial.list());

  // Spróbuj automatycznie znaleźć sensowny port (USB, nie Bluetooth)
  String[] ports = Serial.list();
  int chosen = -1;
  for (int i = 0; i < ports.length; i++) {
    String p = ports[i].toLowerCase();
    boolean looksLikeUsb =
      p.contains("usbmodem") || p.contains("usbserial") ||  // macOS
      p.matches(".*com\\d+.*") ||                           // Windows
      p.contains("ttyacm") || p.contains("ttyusb");         // Linux

    boolean looksLikeBluetooth =
      p.contains("bluetooth");

    if (looksLikeUsb && !looksLikeBluetooth) {
      chosen = i;
      break;
    }
  }

  // Fallback: jeśli nie znaleziono, bierz pierwszy na liście i daj komunikat
  if (chosen == -1 && ports.length > 0) {
    println("Nie znaleziono typowego portu USB. Biorę pierwszy z listy (może być zły): " + ports[0]);
    chosen = 0;
  }

  if (chosen == -1) {
    println("Brak portów! Sprawdź kabel/sterowniki i spróbuj ponownie.");
    exit();
    return;
  }

  println("Łączę z portem: " + ports[chosen]);
  port = new Serial(this, ports[chosen], 9600);

  // Czyść ewentualny „śmietnik” z bufora i czekaj na linie zakończone '\n'
  port.clear();
  port.bufferUntil('\n');

  background(0);
}

void draw() {
  float s = map(analogRead, 0, 1023, 50, 400);
  fill(100, 200, 255, 150);
  noStroke();
  ellipse(width/2, height/2, s, s);

  fill(0, 20);
  rect(0, 0, width, height);
}

// Odbiór linii zakończonej '\n' (Arduino println dodaje \r\n — to OK)
void serialEvent(Serial p) {
  String data = p.readStringUntil('\n');
  if (data != null) {
    data = trim(data);  // usuwa też \r
    try {
      analogRead = int(data);
    } catch (Exception e) {
      // pomiń uszkodzoną linię
    }
  }
}
