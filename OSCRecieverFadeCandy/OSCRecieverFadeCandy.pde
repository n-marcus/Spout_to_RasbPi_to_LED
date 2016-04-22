import processing.io.*;
import oscP5.*;
import netP5.*;

OPC opc;

long last_second;
int recieved = 0;
int fps;

LED leds[];

OscP5 oscP5;
NetAddress myRemoteLocation;
String frame;

void setup() {
  String available[] = LED.list();
  print("Available: ");
  println(available);

  // create an object for each LED and store it in an array
  leds = new LED[available.length];
  for (int i=0; i < available.length; i++) {
    leds[i] = new LED(available[i]);
  }


  size(800, 400);
  //frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("169.254.118.33", 12000);

  opc = new OPC(this, "127.0.0.1", 7890);

  //All the timer business
  last_second = millis();

  GPIO.pinMode(4, GPIO.OUTPUT);
}

void draw() {
  background(0);
  noStroke();
  leds[0].brightness(1.0);


  fill(255);
  text("FPS : " + fps, 100, 100);
  if (opc.output == null) {
    text("No FadeCandy detected", 100, 130);
  } else {
    text("Seems like there is a FadeCandy connected", 100, 130);
  }

  if (millis() > last_second + 1000) {
    last_second = millis();
    fps = recieved;
    println("Recieved " + recieved + " frames this second");
    recieved = 0;
    OscMessage feedback = new OscMessage("/feedback");
    if (recieved > 1) {
      feedback.add(1);
    } else {
      feedback.add(0);
    }
    oscP5.send(feedback, myRemoteLocation);
  }

  if (fps > 0) { 
    blink();
    leds[1].brightness(1.0);
    leds[1].brightness(0.0);
  } else {
    leds[1].brightness(0.0);
  }

  if (frame != null) {
    //println("Length = " + frame.length());
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
    //blink led light

    //Timer business
    recieved ++;
    //println(frame);
  }
}

void blink() {
  GPIO.digitalWrite(4, GPIO.HIGH);
  GPIO.digitalWrite(4, GPIO.LOW);
}