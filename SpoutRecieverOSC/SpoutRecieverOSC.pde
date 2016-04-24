import oscP5.*;
import netP5.*;
import java.awt.*; // needed for frame insets

Insets insets; // Frame caption and borders for resizing
PImage img;

OscP5 oscP5;
NetAddress myRemoteLocation;

int i = 0;

color pixelcolor;
PFont font;


int ledLength = 49;

StringList list;

color[] pixelarray = new color[100];
//PVector[] positions = new PVector[100];

boolean low_resource = false;

///////////////////////////
////////RATIOS////////////
//////////////////////////
float[] data;
ArrayList<PVector> positions = new ArrayList<PVector>();
int scaling = 200;

// Load text file as a string



// DECLARE A SPOUT OBJECT HERE
Spout spout;

void setup() {


  size(640, 360, OPENGL);

  //OSC
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("169.254.5.32", 12000);
  // 169.254.5.32 = rasp ip
  frame.setResizable(true); // Optionally adapt to sender frame size
  insets = frame.getInsets(); // Get the caption and borders for frame resizing

  background(0);


  // Create an image to receive the data.
  img = createImage(width, height, ARGB);

  font = loadFont("ArialMT-48.vlw");

  //fill the pixel array
  for (int i = 0; i < ledLength; i ++) { 
    pixelarray[i] = color(0, 0, 0);
  }

  String[] stuff = loadStrings("positions.txt");
  ledLength = stuff.length;
  println("Number of leds set to: " + ledLength);
  // Convert string into an array of integers using ',' as a delimiter
  for (int i = 0; i < stuff.length; i ++) {
    data = float((split(stuff[i], ',')));
    positions.add(new PVector(data[0] - 0.5, data[1] - 0.5));
  }
  println(positions);


  for (PVector p : positions) { //advanced for loop
    fill(255);
    ellipse(p.x * height + (height/2), p.y * height + (height/2), 4, 4); //getting the points, centering them and scaling them to mouse positions
  }


  // CREATE A NEW SPOUT OBJECT HERE
  spout = new Spout();

  // INITIALIZE A SPOUT RECEIVER HERE
  // Give it the name of the sender you want to connect to
  // Otherwise it will connect to the active sender
  // img will be updated to the sender size
  spout.initReceiver("", img);
} 

void draw() {
  background(0);
  // RECEIVE A SHARED TEXTURE HERE
  img = spout.receiveTexture(img);

  if (mousePressed && mouseButton == LEFT) {
    scaling = mouseX;// if you click and drag you can make the circle bigger or smaller
  }

  // If the image has been resized, optionally resize the frame to match.
  if (img.width != width || img.height != height && img.width > 0 && img.height > 0) {
    // Reset the frame size - include borders and caption
    frame.setSize((img.width ) + (insets.left + insets.right), (img.height) + (insets.top + insets.bottom));
  }

  // Draw the result
  if (!low_resource) { 
    image(img, 0, 0, width, height);
    for (int i = 0; i < ledLength; i++) { // iterate through the frame horizontally and draw dots where the leds will be relatively
      PVector pos = positions.get(i);

      fill(pixelarray[i]); //get the color from the color array
      if (mousePressed && mouseButton == LEFT) {
        fill(255); //if you are changing the size of the circle make the dots white
      }
      ellipseMode(CENTER);
      ellipse(pos.x * scaling + (width/2) + 10, pos.y * scaling + (height/2), 10, 10); // draw nice dots
      //What number are we working with?
      fill(0);
      textFont(font, 12);
      text(i, pos.x * scaling + (width/2) + 10, pos.y * scaling + (height/2));
    }
  }


  setLEDS(); // the core of it allll



  //display the framerate
  fill(255);
  textFont(font, 32);
  text(int(frameRate), 10, 40);
  textFont(font, 16);
  text(JSpout.GetSenderName(), 70, 20);
  text("low_resource = " + low_resource, 70, 40);
}


// RH click to select a sender
void mousePressed() {
  // SELECT A SPOUT SENDER HERE
  if (mouseButton == RIGHT) {
    // Bring up a dialog to select a sender from
    // the list of all senders running.
    JSpout.SenderDialog();
  }
  if (mouseButton == LEFT) {
    //low_resource =!low_resource;
  }
}

void setLEDS() {
  //OscMessage pixelString = new OscMessage("/frame");
  String pixelString= "";
  int index = 0;
  for (PVector p : positions) { //advanced for loop
    pixelcolor = img.get(int(p.x * scaling + (width/2)), int(  p.y * scaling + (height/2))); // read the color per pixel
    String r = nf(int((pixelcolor >> 16) & 0xFF), 3); // these weird number are a faster way of getting the r g and b values of a color
    String g = nf(int((pixelcolor >> 8) & 0xFF), 3);
    String b = nf(int(pixelcolor & 0xFF), 3);
    pixelString = pixelString + r+ g + b;
    pixelarray[index] = color(pixelcolor); // this is a local array of colors which holds the current frame for debugging purposes
    //println(index);
    index ++;
  }

  //SENDING THE FRAME TO myRemoteLocation
  OscMessage oscFrame = new OscMessage("/frame");
  oscFrame.add(pixelString);
  oscP5.send(oscFrame, myRemoteLocation);
}


void oscEvent(OscMessage theOscMessage) {
  int confirm;
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}

void exit() {
  // CLOSE THE SPOUT RECEIVER HERE
  spout.closeReceiver();
  super.exit();
} 

