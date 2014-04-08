class Body {
  ArrayList history; // stores particle locations
  PVector pos, speed, accln;
  float mass;
  float drag = 0.99;
  int stepSize = 5;
  
  Body(PVector pos_, PVector speed_, PVector accln_, float mass_){
    pos = pos_;
    speed = speed_;
    accln = accln_;
    mass = mass_;
    
    // initialise the history and add the initial position
    history = new ArrayList();
    PVector hPos = pos.get();
    hPos.z = t;
    history.add(hPos);
  }
  
  void update(){
    speed.add(accln);
    pos.add(speed);
    speed.mult(drag);
    accln.set(0,0);
    PVector hPos = pos.get();
    hPos.z = t;
    history.add(hPos);
  }
  
  void applyForce(PVector force){
    force.mult(1/mass);
    accln.add(force);
  }
  
  void changeSpeed(PVector newSpeed){
    speed = newSpeed;
  }
  
  void render(){
  }
  
  void writePositions(){
    for (int ii=0; ii<history.size(); ii++){
      if (ii % stepSize == 0){
        PVector p1 = (PVector) history.get(ii);
        if (ii<history.size()-1){
          output.print(p1.x/100 + " ");
          output.print(p1.y/100 + " ");
          output.print(p1.z/100 + ",");
        } else {
          output.print(p1.x/100 + " ");
          output.print(p1.y/100 + " ");
          output.print(p1.z/100);
        }
      }
    }
  }
}
