class Square extends Body {
  // not currently used
  float r;
  
  Square(PVector pos_, PVector speed_, PVector accln_, float mass_, float r_){
    super(pos_, speed_, accln_, mass_);
    r = r_;
  }
  
  void render(){
  }
}
