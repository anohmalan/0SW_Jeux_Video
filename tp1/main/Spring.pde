  class Spring {
  
    PVector target; 
    float k;         
    float damping;  
  
    Spring(PVector target, float k, float damping) {
      this.target = target;
      this.k = k;
      this.damping = damping;
    }
  
    PVector calculateForce(GraphicObject obj) {
  
      PVector force = PVector.sub(target, obj.location);
      force.mult(k);
  
      PVector dampingForce = PVector.mult(obj.velocity, -damping);
      force.add(dampingForce);
  
      return force;
    }
  }
