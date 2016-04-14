
import java.awt.*; // needed for frame insets


Insets insets; // Frame caption and borders for resizing
PImage img;

OPC opc;

int i = 0;

color pixelcolor;

int ledLength = 49;

StringList list;


// DECLARE A SPOUT OBJECT HERE
Spout spout;

void setup() {
  size(640, 360, OPENGL);


  opc = new OPC(this, "127.0.0.1", 7890);
  frame.setResizable(true); // Optionally adapt to sender frame size
  insets = frame.getInsets(); // Get the caption and borders for frame resizing
  background(0);

  // Create an image to receive the data.
  img = createImage(width, height, ARGB);

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


  // If the image has been resized, optionally resize the frame to match.
  if (img.width != width || img.height != height && img.width > 0 && img.height > 0) {
    // Reset the frame size - include borders and caption
    frame.setSize((img.width * 10) + (insets.left + insets.right), (img.height * 10) + (insets.top + insets.bottom));
  }

  // Draw the result
  image(img, 0, 0, width, height);

  setLEDS();

  for (int i = 0; i < ledLength; i++) { // iterate through the frame horizontally and draw dots where the leds will be relatively
    fill(255);
    ellipse( (width/ledLength) * i, height/2, 4, 4);
  }
  
  //display the framerate
  textSize(32);
  fill(255);
  text(frameRate, 10, 40);
  text(JSpout.GetSenderName(), 10, 50);  
}


// RH click to select a sender
void mousePressed() {
  // SELECT A SPOUT SENDER HERE
  if (mouseButton == RIGHT) {
    // Bring up a dialog to select a sender from
    // the list of all senders running.
    JSpout.SenderDialog();
  }
}

void setLEDS() {
  
  for (int i = 0; i < ledLength; i++) { // iterate through the frame horizontally
    pixelcolor = img.get((img.width/ledLength) * i, img.height/2); // read the color per pixel
    float r = red(pixelcolor);
    float g = green(pixelcolor);
    float b = blue(pixelcolor);
    opc.setPixel(i, color(g, r, b)); //these leds mix up colors somehow
  }
  opc.writePixels(); //sending buffer to the fadecandy
}

void exit() {
  for (int i =0; i < ledLength; i ++) { //make sure all leds turn off at shutdown
    opc.setPixel(i, color(0, 0, 0));
  }
  opc.writePixels();
  // CLOSE THE SPOUT RECEIVER HERE
  spout.closeReceiver();
  super.exit();
} 

