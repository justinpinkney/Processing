class System {
  ArrayList circles;

  System() {
    circles = new ArrayList();
  }
  
  void addCircle(){
    Circle p = new Circle(new PVector(random(0,width),random(0,height)),new PVector(random(-1,1),random(-1,1)),new PVector(0,0),10.0,3.0);
    circles.add(p);
  }
  
  void update() {
    for (int i = circles.size() - 1; i >= 0; i-- ) {
      Circle p = (Circle) circles.get(i);
      p.update();
      p.render();
    }
  }
  
  void interact(){
    // self interact circles
    for (int i = circles.size() - 1; i >= 0; i-- ) {
      for (int j = i; j >= 0; j-- ) {
        Circle p = (Circle) circles.get(i);
        Circle q = (Circle) circles.get(j);
        PVector temp = PVector.sub(p.pos,q.pos);
        PVector temp2 = temp.get();
        if (temp.mag()<50+t/10 & temp.mag()>20){
          float d = temp.mag();
          temp.normalize();
          temp.rotate(0.01);
          temp.mult(-(500+t)/d/d);
          p.applyForce(temp);
          temp.mult(-1);
          //temp.rotate(1);
          q.applyForce(temp);
        } else if (temp.mag()<10){
          temp.normalize();
          temp.mult(0.01);
          p.applyForce(temp);
          temp.mult(-1);
          q.applyForce(temp);
        }
        //temp2.sub(new PVector(width/2,height/2));
//        temp2.normalize();
//        temp2.mult(-0.001);
//        temp2.rotate(PI/2);
//        p.applyForce(temp2);
      }
    }
  }
  
  void writePositions(){
    for (int i = circles.size() - 1; i >= 0; i-- ) {
        Circle p = (Circle) circles.get(i);
        p.writePositions();
        output.println(' ');
    }
  }
}
