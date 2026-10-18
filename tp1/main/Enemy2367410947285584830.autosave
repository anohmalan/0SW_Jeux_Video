  class Enemy extends GraphicObject {
    final int REST = 0;
    final int ATTACK = 1;
  
    int state = REST;
  
    PVector ceilingAnchor;
    PVector restPosition;
    Spring spring;       
  
    float mass = 40;
  
    float activationDistance = 200; 
    float deactivationDistance = 220;
    float maxRopeLength = 200;
    float ropeLength = 260; 
  
    float attractionConstant = 100000;
  
    PVector target;
    float heading = 0;
  
    Enemy(float x, float y, PVector anchor) {
      location = new PVector(x, y);
      velocity = new PVector(0, 0);
      acceleration = new PVector(0, 0);
  
      fillColor = color(140);
      strokeColor = color(60);
      strokeWeight = 1.5;
  
      ceilingAnchor = anchor;
      restPosition = location.copy();
  
      spring = new Spring(restPosition, 0.05, 0.12);
    }
  
    void setDistance(float activationDistance, float deactivationDistance) {
      this.activationDistance = activationDistance;
      this.deactivationDistance = deactivationDistance;
    }
  
    void setMaxRopeLength(float length) {
      this.maxRopeLength = length;
    }
  
    void setRopeLength(float length) {
      this.ropeLength = length;
    }
  
    void setTarget(PVector _target) {
      target = _target;
    }
  
    void updateTarget(float x, float y) {
      if (target == null) {
        target = new PVector();
      }
      target.x = x;
      target.y = y;
    }
  
    void applyForce(PVector force) {
      PVector f = force.copy();
      f.div(mass);
      acceleration.add(f);
    }
  
    PVector attract(PVector targetLocation) {
  
      PVector force = PVector.sub(targetLocation, location);
  
      float distance = force.mag();
      distance = constrain(distance, 10, deactivationDistance);
  
      float magnitude = attractionConstant / (distance * distance);
  
      force.setMag(magnitude);
  
      return force;
    }
  
    void update(float deltaTime) {
  
      if (target != null) {
        float distanceToTarget = PVector.dist(location, target);
        if (state == REST && distanceToTarget <= activationDistance) {
          state = ATTACK;
        } else if (state == ATTACK && distanceToTarget >= deactivationDistance) {
          state = REST;
        }
  
        float dx = target.x - location.x;
        float dy = target.y - location.y;
        heading = atan2(dy, dx);
      }
  
      if (state == ATTACK && target != null) {
        PVector attractionForce = attract(target);
        applyForce(attractionForce);
      } else {
        PVector springForce = spring.calculateForce(this);
        applyForce(springForce);
      }
  
      velocity.add(acceleration);
      velocity.mult(0.98);
      location.add(velocity);
      acceleration.mult(0);
  
      PVector fromRest = PVector.sub(location, restPosition);
      if (fromRest.mag() > maxRopeLength) {
        fromRest.setMag(maxRopeLength);
        location = PVector.add(restPosition, fromRest);
        velocity.mult(0.4);
      }
  
      PVector fromAnchor = PVector.sub(location, ceilingAnchor);
      if (fromAnchor.mag() > ropeLength) {
        fromAnchor.setMag(ropeLength);
        location = PVector.add(ceilingAnchor, fromAnchor);
        velocity.mult(0.4);
      }
    }
  
    void display() {
      stroke(60);
      strokeWeight(1.5);
      line(ceilingAnchor.x, ceilingAnchor.y, location.x, location.y);
  
      fill(60);
      noStroke();
      ellipse(ceilingAnchor.x, ceilingAnchor.y, 10, 10);
  
      noFill();
      stroke(120);
      strokeWeight(1);
      ellipse(location.x, location.y, deactivationDistance * 2, deactivationDistance * 2);
  
      fill(state == ATTACK ? color(230, 60, 50) : fillColor);
      stroke(strokeColor);
      strokeWeight(strokeWeight);
      ellipse(location.x, location.y, 40, 40);
    }
  }
