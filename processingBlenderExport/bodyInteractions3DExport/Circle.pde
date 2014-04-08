class Circle extends Body {
  
  float r;
  
  Circle(PVector pos_, PVector speed_, PVector accln_, float mass_, float r_){
    super(pos_, speed_, accln_, mass_);
    r = r_;
  }
  
  void render(){
    noStroke();
    fill(100);
    pushMatrix();
    translate(pos.x,pos.y,t);
    sphere(r);
    popMatrix();
  }
}
