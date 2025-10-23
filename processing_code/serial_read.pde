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
