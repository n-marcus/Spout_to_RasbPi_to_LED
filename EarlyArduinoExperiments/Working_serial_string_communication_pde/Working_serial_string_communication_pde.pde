import controlP5.*;

ControlP5 cp5;

import processing.serial.*;



int i = 0;

Serial myPort;  // Create object from Serial class


boolean autoblink, autonoise, debug, randomcolors;
int flashbuttonint;
int intervalknob;
int r, g, b;

StringList list;



String s;

void setup() 
{
  background(0);
  frameRate(60);

  list = new StringList();

  //////////////////////////////////////////
  //////////// SERIAL BUSINESS    //////////
  //////////////////////////////////////////

  printArray(Serial.list());
  String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 250000);


  size(500, 200);


  //This is a test of ASCII to int conversion in Processing
  /*s = "This is a string";
   for (int i = 0; i < s.length (); i++) {
   println("This is the letter " + s.charAt(i) + " converted to ASCII = " + int(s.charAt(i)), 50, 100);
   }
   */

  //////////////////////////////////////////
  //////////// USER INTERFACEEE  ///////////
  //////////////////////////////////////////
  cp5 = new ControlP5(this);


  //////////////////////////////////////////
  //////////// KNOBSZZZZ ///////////////////
  //////////////////////////////////////////


  cp5.addKnob("intervalknob")
    .setRange(0, 100)
      .setValue(50)
        .setPosition(0, 0)
          .setRadius(40)
            .setDragDirection(Knob.VERTICAL)
              ;
  cp5.addKnob("R")
    .setRange(0, 255)
      .setValue(50)
        .setPosition(100, 0)
          .setRadius(40)
            .setDragDirection(Knob.VERTICAL)
              ;

  cp5.addKnob("G")
    .setRange(0, 255)
      .setValue(50)
        .setPosition(200, 0)
          .setRadius(40)
            .setDragDirection(Knob.VERTICAL)
              ;
  cp5.addKnob("B")
    .setRange(0, 255)
      .setValue(50)
        .setPosition(300, 0)
          .setRadius(40)
            .setDragDirection(Knob.VERTICAL)
              ;

  //////////////////////////////////////////
  ////////////   BUTTONS ///////////////////
  //////////////////////////////////////////


  cp5.addButton("flashbutton")
    .setValue(1)
      .setPosition(0, 100)
        .setSize(100, 30)
          .setId(1);

  cp5.addButton("noise")
    .setValue(1)
      .setPosition(100, 100)
        .setSize(100, 30)
          .setId(1);

  cp5.addButton("clearall")
    .setValue(1)
      .setPosition(0, 150)
        .setSize(100, 30)
          .setId(1);
  //////////////////////////////////////////
  //////////// TOOGGLESS ///////////////////
  //////////////////////////////////////////

  cp5.addToggle("autoblink")
    .setPosition(400, 10)
      .setSize(15, 15)
        .setState(false)
          ;
  cp5.addToggle("autonoise")
    .setPosition(400, 40)
      .setSize(15, 15)
        .setState(false)
          ;


  cp5.addToggle("debug")
    .setPosition(400, 70)
      .setSize(15, 15)
        .setState(false)
          ;


  cp5.addToggle("randomcolors")
    .setPosition(400, 100)
      .setSize(15, 15)
        .setState(false)
          ;
}

void draw() {
  fill(0, 0, 0, 10);
  rect(0, 0, width, height);
  if (frameCount % (intervalknob + 1) == 0 && autoblink) { // this is the trigger for the autoblink
    blink();
    background(r, g, b);
    clearall();
  }

  if (frameCount % (intervalknob + 1) == 0 && autonoise) { // this is the trigger for the autonoise
    noise();
  }
  if (autoblink && randomcolors && frameCount % (intervalknob + (intervalknob/2) + 1) == 0 ) {
    r = int(nf(int(random(255)), 3));
    g = int(nf(int(random(255)), 3));
    b = int(nf(int(random(255)), 3));
    myPort.write("R" + str(r));
    myPort.write("G" + str(g));
    myPort.write("B" + str(b));
    println("RANDOM COLORS");
  }
  fill(0, 0, 0, 255);
  rect(0, height-10, width, height);
  fill(255);
  String timesps = nf(frameRate/(intervalknob+1), 1, 2) ;
  String text = ("Blink time is about: " + timesps + " times per second." + "   This is about " + 1/(int(timesps)+0.1) + " ms in between each blink.");
  text(text, 0, 200);
}



void blink() 
{                           //if we clicked in the window
  myPort.write("y-");         //send a y

  i++; //count the blinks
  println("Blinked " + i + " times now...");
} 


void clearall()  //clear all pixels on ledstrip
{                           //otherwise
  myPort.write("n-");          //send a 0
}


void intervalknob(int theValue) {
  intervalknob = theValue;
}

// this is what happens when you press the flasshbutton, it flashes.
public void flashbutton(float theValue) {
  //println("flashbutton = "+theValue);
  blink();
  clearall();
}

//This method sends a message for the debug boolean. With the debug off the Arduino wont send any Serial.print or test Led messages. This might make it a bit faster.
public void debug(float theValue) {
  println("flashbutton = "+theValue);
  if (theValue > 0) {
    myPort.write("db1-"); // db1 and db0 stand for debug and the integer is the value.
  } else {
    myPort.write("db0-");
  }
}

public void R(float theValue) {
  String message = "R" + str(int(theValue));
  println("R sending : " + message);
  myPort.write(message);
  r = int(theValue);
}
public void G(float theValue) {
  String message = "G" + str(int(theValue));
  println("G sending : " + message);
  myPort.write(message);
  g =  int(theValue);
}

public void B(float theValue) {
  String message = "B" + str(int(theValue));
  println("B sending : " + message);
  myPort.write(message);
  b =  int(theValue);
}

void noise() { // A function that generates 60 random pixel messsages
  String r;
  String g;
  String b;
  String pixelmessage;

  list.clear();

  for (int i = 0; i <60; i ++ ) { //  generate random r g and b values 60 times and send them as one string to the arduino
    r = nf(int(random(255)), 3);
    g = nf(int(random(255)), 3);
    b = nf(int(random(255)), 3);
    pixelmessage = "P" + nf(i + 1, 2) +  r + g + b + "-";
    //println(message);
    //myPort.write(pixelmessage);
    //println(pixelmessage);
    list.append(pixelmessage);
  }
  //println(list);
  for (int i = 0; i < list.size (); i++) {
   myPort.write(list.get(i));
   //println(list.get(i));
   delay(4);
    //myPort.write();
  }
}

void exit() {
  clearall(); //clear everything when closing the application
}

