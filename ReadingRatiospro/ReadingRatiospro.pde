float[] data;
//PVector[] positions ; //= new PVector[60];
ArrayList<PVector> positions = new ArrayList<PVector>();
void setup() {
  size(400, 400);
  // Load text file as a string
  String[] stuff = loadStrings("positions.txt");
  // Convert string into an array of integers using ',' as a delimiter
  for (int i = 0; i < stuff.length; i ++) {
    data = float((split(stuff[i], ',')));
    positions.add(new PVector(data[0] - 0.5, data[1] - 0.5));
  }
  println(positions);
}

void draw() {
  background(0);
  for (PVector p : positions) { //advanced for loop
    fill(255);
    ellipse(p.x * mouseX + (height/2),p.y * mouseX + (height/2), 4, 4); //getting the points, centering them and scaling them to mouse positions
  }
}

