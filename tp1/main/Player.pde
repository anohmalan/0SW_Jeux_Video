  class Player extends GraphicObject {
  
    float diameter = 40;
    float speed = 5;
  
    Player() {
      location = new PVector(60, height - 60);
      velocity = new PVector(0, 0);
      acceleration = new PVector(0, 0);
      fillColor = color(230, 60, 50);
      strokeColor = color(60);
      strokeWeight = 1.5;
    }
  
    void applyForce(PVector force) {
    }
  
    void update(float deltaTime) {
  
         if (keyPressed) {
  
        if (key == 'a') {
          velocity.add(acceleration);
  
          float nextX = location.x - velocity.x;
  
          if (nextX >= 0) {
            location.x = nextX;
          }
        }
  
        if (key == 'd') {
          velocity.add(acceleration);
  
          float nextX = location.x + velocity.x;
  
          if (nextX + diameter <= width) {
            location.x = nextX;
          }
        }
      }
  
      acceleration.mult(0);
    }
  
    void display() {
      stroke(strokeColor);
      strokeWeight(strokeWeight);
      fill(fillColor);
  
      rect(location.x, location.y, diameter, diameter);
    }
  }
