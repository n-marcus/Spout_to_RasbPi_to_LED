PImage image;
PVector[] points = new PVector[60];
int index = 0;
  
PrintWriter output;

void setup() {  
  image = loadImage("ratios.png");
  size(image.width, image.height);
  for (int i = 0; i < 60; i ++) { 
    points[i] = new PVector(0, 0);
  }
  
  output = createWriter("positions.txt"); 
}

void draw() {
  image(image, 0, 0);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    points[index].x = (float) mouseX/ (float) width;
    points[index].y= (float) mouseY / (float) width;
    println( points[index].x + ", " + points[index].y);
    output.println( points[index].x + ", " + points[index].y);
    index ++;
  }
}

void keyPressed() {
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  exit(); // Stops the program
}

