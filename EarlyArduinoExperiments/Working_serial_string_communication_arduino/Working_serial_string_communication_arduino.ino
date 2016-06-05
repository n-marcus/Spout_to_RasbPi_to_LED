#include <Adafruit_NeoPixel.h>



#define PIN 6


int pixel = 0;            // pixel number that you're changing
int r = 0;              // red value
int g = 34;          // green value
int b = 12;           // blue value
int red = 0;
int green = 0;
int blue = 0;

char val; // Data received from the serial port
int ledPin = 13; // Set the pin to digital I/O 13


boolean debug = false;

String incomingString;


Adafruit_NeoPixel strip = Adafruit_NeoPixel(60, PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  Serial.begin(250000); // Start serial communication at 9600 bps
  strip.begin();
  strip.show(); // Initialize all pixels to 'off'
  pinMode(ledPin, OUTPUT); // Set pin as OUTPUT

  testPixels(255, 0, 0);
  delay(200);

  testPixels(0, 255, 0);
  delay(200);

  testPixels(0, 0, 255);
  delay(200);


  incomingString = "";
}



void loop() {
  if (Serial.available() > 0) {

    // Bytes come in here and are now a character
    char incomingByte = (char)Serial.read();

    incomingString += incomingByte; //concatenating the bytes

    if (debug) { //printing every byte
      Serial.print("BYTE: ");
      Serial.println(incomingByte);
      Serial.print("STRING TILL NOW: ");
      Serial.println(incomingString);
    }

    // Checks for null termination of the string.
    if (incomingByte == '-') { //The '-' is the mark for the end of a message, MAKE SURE YOU ALWAYS END ANY MESSAGE WITH A '-'


      //incomingString[incomingString.length()-1] = '\0'; // This deletes the termination character after a complete string has been sent

      if (debug) {
        Serial.print("COMPLETE MESSAGE RECIEVED: "); //printing the completed message when debug is on
        Serial.println(incomingString);
      }

      if (incomingString == "y-") { //when you get a "y-" make everything blink
        colorWipe(r, g, b);
        if (debug) {
          Serial.println("COLORWIPE!!");
          testLED(1);
        }
      }

      if (incomingString == "n-") { // and "n-" will clear everything
        if (debug) {
          Serial.println("CLEARPIXELS");
          testLED(0);
        }
        clearPixels();
      }


      if (incomingString == "db1-") {
        debug = true;
        Serial.println("DEBUG IS TRUE");
      }
      if (incomingString == "db0-") {
        debug = false;
        Serial.println("DEBUG IS FALSE WILL NOT PRINT ANYTHING FROM NOW ON");
      }

      //filtering the RED messages
      if (incomingString.startsWith("R")) {
        setR();
      }

      //filtering the GREEN messages
      if (incomingString.startsWith("G")) {
        setG();
      }

      //filtering the BLUE messages
      if (incomingString.startsWith("B")) {
        setB();
      }



      if (incomingString.startsWith("P")) {

        pixel = incomingString.substring(1, 3).toInt(); //take the first 2 elements after the "P" and use them as the pixel index
        red = incomingString.substring(3, 6).toInt(); //take the 3 elements after the pixel index
        green = incomingString.substring(6, 9).toInt();
        blue = incomingString.substring(9, 13).toInt();
        if (debug) { // if debug is on display the incoming pixel message
          Serial.print("Pixel = ");
          Serial.println(pixel);
          Serial.print("Red = ");
          Serial.println(red);
          Serial.print("Green = ");
          Serial.println(green);
          Serial.print("Blue= ");
          Serial.println(blue);
        }
        strip.setPixelColor(pixel, strip.Color(red, green, blue));
        strip.show();
      }
      incomingString = "";

    }
  }


  /* if (Serial.available())
   { // If data is available to read,
     val = Serial.read(); // read it and store it in val
   }
   if (val == '1')
   { // If 1 was received
     colorWipe(r, g, b);
     digitalWrite(ledPin, HIGH); // turn the LED on
   } else if (val == '0') {
     clearPixels();
     digitalWrite(ledPin, LOW); // otherwise turn it off
   }
   *///delay(10); // Wait 10 milliseconds for next reading
}




void colorWipe(unsigned int r, unsigned int g, unsigned int b ) {
  for (uint16_t i = 0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, strip.Color(r, g, b));
    strip.show();
    //delay(wait);
  }
}


void clearPixels() {
  for (uint16_t i = 0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, strip.Color(0, 0, 0));
  }
  strip.show();
}

void testLED(int toggle) {
  if (toggle == 1) {
    digitalWrite(ledPin, HIGH); // turn the test LED on when this function recieves a '1'
  }
  else if (toggle == 0) {
    digitalWrite(ledPin, LOW); // turn the test LED off when this function recieves a '0'
  }
  else {
    Serial.println("Void testLED recieved an invalid argument: " + toggle);
  }
}




void setG() {
  if (debug) { //printing input
    Serial.print("G STRING: ");
    Serial.println(incomingString);
  }
  //setting g
  g = ((incomingString.substring(1, incomingString.length() - 1)).toInt()); // element 1 till length - 1 will be set in a substring and converted to an integer that will define g

  //printing g to check
  if (debug) {
    Serial.println("G is now : " + String(r));
  }
}


void setB() {
  if (debug) { //printing input
    Serial.print("B STRING: ");
    Serial.println(incomingString);
  }
  //setting b
  b = ((incomingString.substring(1, incomingString.length() - 1)).toInt()); // element 1 till length - 1 will be set in a substring and converted to an integer that will define b

  //printing b to check
  if (debug) {
    Serial.println("B is now : " + String(r));
  }
}

void setR() {
  if (debug) { //printing input
    Serial.print("R STRING: ");
    Serial.println(incomingString);
  }
  //setting r
  r = ((incomingString.substring(1, incomingString.length() - 1)).toInt()); //element 1 till length - 1 will be set in a substring and converted to an integer that will define r

  //printing r to check
  if (debug) {
    Serial.println("R is now : " + String(r));
  }
}

void setPixel() {
  if (debug) {
    Serial.println("Recieved Pixel message");
    Serial.print("Pixel : ");
    Serial.println(pixel);
    Serial.print("Red = ");
    Serial.println(red);
    Serial.print("Blue = ");
    Serial.println(blue);
    Serial.print("Green = ");
    Serial.println(green);


  }
  strip.setPixelColor(pixel, strip.Color(red, green, blue));
}

void testPixels(int r, int g, int b) {
  for (uint16_t i = 0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, strip.Color(r, g, b));
  }
  strip.show();
  delay(500);
  clearPixels();

}
