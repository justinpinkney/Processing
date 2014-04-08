// Particle system generated 3D objects, export occurs via text file

System particles;
float t=0;
PrintWriter output;

void setup() {
  size(500, 500, P3D);
  output = createWriter("temp.txt");
  background(0);
  
  // initialise particle system
  particles = new System();
  
  //populate with particles
  for (int i=0;i<100;i++) {
    particles.addCircle();
  };

  // position the camera
  rotateX(-PI/1.5);
  lights();
  
  // for each time step update the particle system
  for (int i=0; i<500; i++) {
    particles.interact();
    particles.update();
    t += 1;
    println(i);
  }
  
  // write particle positions to a text file
  particles.writePositions();
  output.flush();
  output.close();
}



