/**
 * oscP5parsing by andreas schlegel
 * example shows how to parse incoming osc messages "by hand".
 * it is recommended to take a look at oscP5plug for an
 * alternative and more convenient way to parse messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OPC opc;


OscP5 oscP5;
NetAddress myRemoteLocation;
String frame;
void setup() {
  size(400, 400);
  //frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);
  opc = new OPC(this, "127.0.0.1", 7890);
}

void draw() {
  background(0);
  noStroke();
  if (frame != null) {
    println("Length = " + frame.length());
    //for more pixels you need to change the dividor
    for (int i = 0; i < (frame.length ()/9); i ++) { // divide the long string into parts of 9, r g and b//

      //println(i + 1);
      String pixel = frame.substring(i *9, (i + 1) * 9); // each of these strings hold one pixel
      String r = pixel.substring(0, 3);
      String g = pixel.substring(3, 6);
      String b = pixel.substring(6, 9);
      //println(pixel + " stripped to " + r + g + b);
      opc.setPixel(i, color(int(r), int(g), int(b))); //these leds mix up colors somehow
      fill(int(r), int(g), int(b));
      ellipse((width/(frame.length()/9))*i, height/2, 10, 10);
    }
    opc.writePixels(); //sending buffer to the fadecandy
  }
}



void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */
  String name = theOscMessage.addrPattern();
  
  if (name.equals("/frame")) { // if we recieve a frame message, load it into the local frame variable
    String red, green, blue;
    frame = theOscMessage.get(0).stringValue();
    //println(frame);
  }
}

