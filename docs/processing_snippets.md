---
title: "Processing Snippety kodu"
nav_order: 2
---


## Odbieranie danych z SERIAL


```java
import processing.serial.*;

Serial arduino;                                    

void setup() {
  size(800, 400);
  
  // ============ POŁĄCZ Z ARDUINO ============
  println("=== DOSTĘPNE PORTY ===");
  printArray(Serial.list());
  println("======================");
  
  // WAŻNE: Zmień [0] na numer swojego portu!
  // Sprawdź w konsoli powyżej który port to Arduino
  arduino = new Serial(this, Serial.list()[11], 9600);
  arduino.bufferUntil('\n');  // Czytaj do nowej linii
}
```

## Troubleshooting wyboru portu 

```java
import processing.serial.*;
Serial port;

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
```


## Czytanie danych z Arduino

```java
void serialEvent(Serial port) {
  // ============ CZYTAJ DANE Z ARDUINO ============
  String data = port.readStringUntil('\n');
  
  if (data != null) {
    data = trim(data);  // Usuń białe znaki
    
    // Sprawdź czy to liczba
    try {
      int value = int(data);
      
      // Dodaj do listy
      wartosci.add(value);
      
      // Usuń najstarszą wartość jeśli za dużo
      if (wartosci.size() > maxPunktow) {
        wartosci.remove(0);
      }
      
      // Debug - wypisz w konsoli
      println("Odebrano: " + value);
      
    } catch (Exception e) {
      println("Błąd parsowania: " + data);
    }
  }
}
```