import oscP5.*;
import netP5.*;
import java.awt.*; // needed for frame insets


Insets insets; // Frame caption and borders for resizing
PImage img;

OscP5 oscP5;
NetAddress myRemoteLocation;

int i = 0;

color pixelcolor;

int ledLength = 49;

StringList list;
color[] pixelarray = new color[ledLength];
PVector[] positions = new PVector[ledLength];

boolean low_resource = false;


// DECLARE A SPOUT OBJECT HERE
Spout spout;

void setup() {
  size(640, 360, OPENGL);

  //OSC
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("169.254.5.32", 12000);

  frame.setResizable(true); // Optionally adapt to sender frame size
  insets = frame.getInsets(); // Get the caption and borders for frame resizing
  background(0);

  // Create an image to receive the data.
  img = createImage(width, height, ARGB);

  //fill the pixel array
  for (int i = 0; i < ledLength; i ++) { 
    pixelarray[i] = color(0, 0, 0);
    //positions[i] = new PVector((width/ledLength) * i, height/2); //linear spreading
    float phase = ((float)(i + 1)/ (float) ledLength); //getting a number from 0.0 to 1.0 based on i and ledLength
    phase *= TWO_PI;
    float x = (sin(phase)) * (height/4); //mapping it to from 0 to height
    float y = (cos(phase)) * (height/4); //mapping it to from 0 to height
    x += width/2;
    y += height/2;

    positions[i] = new PVector(x, y);
    //println(positions[i].x + " , " + positions[i].y);
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
    updateCircle();
  }

  for (int i = 0; i < ledLength; i ++) { 
    fill(255);
    ellipse(positions[i].x, positions[i].y, 10, 10);
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
      fill(pixelarray[i]); //get the color from the color array
      ellipse((width/ledLength) * i, height/2, 10, 10); // draw nice dots
    }
  }

  setLEDS();



  //display the framerate
  textSize(32);
  fill(255);
  text(int(frameRate), 10, 40);
  textSize(12);
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
  for (int i = 0; i < ledLength; i++) { // iterate through the frame horizontally
    pixelcolor = img.get((img.width/ledLength) * i, img.height/2); // read the color per pixel
    String r = nf(int((pixelcolor >> 16) & 0xFF), 3); // these weird number are a faster way of getting the r g and b values of a color
    String g = nf(int((pixelcolor >> 8) & 0xFF), 3);
    String b = nf(int(pixelcolor & 0xFF), 3);
    /*
    int r = (pixelcolor >> 16) & 0xFF;  // Faster way of getting red(argb)
     int g = (pixelcolor >> 8) & 0xFF;   // Faster way of getting green(argb)
     int b = pixelcolor & 0xFF;          // Faster way of getting blue(argb)
     */

    pixelString = pixelString + r+ g + b;
    if (!low_resource) {
      pixelarray[i] = color(pixelcolor); // this is a local array of colors which holds the current frame for debugging purposes
    }
    //println(pixelString);
  }
  //SENDING THE FRAME TO myRemoteLocation
  OscMessage oscFrame = new OscMessage("/frame");
  oscFrame.add(pixelString);
  oscP5.send(oscFrame, myRemoteLocation);
  fill(255);
  ellipse(width - 20, 20, 20, 20);
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

void updateCircle() {
  for (int i = 0; i < ledLength; i ++) { 
    pixelarray[i] = color(0, 0, 0);
    float phase = ((float)(i + 1)/ (float) ledLength); //getting a number from 0.0 to 1.0 based on i and ledLength
    phase *= TWO_PI;
    float x = (sin(phase)) * (mouseX); //mapping it to from 0 to height
    float y = (cos(phase)) * (mouseX); //mapping it to from 0 to height
    x += width/2;
    y += height/2;

    positions[i] = new PVector(x, y);
    //println(positions[i].x + " , " + positions[i].y);
  }
}

