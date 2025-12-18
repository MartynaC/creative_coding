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
  String[] ports = Serial.list();
  println(ports);

  for (String p : ports) {
    if (p.toLowerCase().contains("usb") || p.toLowerCase().contains("com")) {
      port = new Serial(this, p, 9600);
      println("Połączono z: " + p);
      port.bufferUntil('\n');
      return;
    }
  }

  println("Nie znaleziono portu USB");
  exit();
}
```


## Czytanie danych z Arduino

```java
void serialEvent(Serial port) {
  String data = port.readStringUntil('\n');
  if (data != null) {
    data = trim(data);
    sensorValue = int(data);
  }
}
```