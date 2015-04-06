PImage target;
PGraphics pg;
PGraphics canvas;
int errInd;
float nStroke = 0;
int minErr = 100000000;
float px = random(width);
float py = random(height);
int skipCount = 0;

void setup(){
  size(960,540);
  background(255);
  pg = createGraphics(width,height);
  canvas = createGraphics(width,height);
  canvas.beginDraw();
  canvas.background(255);
  canvas.endDraw();
  target = loadImage("tokyo.jpg");
  target.resize(width, height);
  frameRate(120);
  px = random(width);
  py = random(height);
}

void draw(){
  // Try some possible strokes
  background(255);
  int errInd = -1;
  int nAng = 30;
  
//  float[] x1 = new float[100];
//  float[] y1 = new float[100];
//  float[] x2 = new float[100];
//  float[] y2 = new float[100];
//  for (int i=0; i<100; i++) {
//    x1[i] = random(width);
//    y1[i] = random(height);
//    x2[i] = x1[i] + random(-10,10);
//    y2[i] = y1[i] + random(-10,10);
//  }
  
  canvas.loadPixels();
  
  for (int iStroke=0; iStroke<nAng; iStroke++){
    // copy the current canvas
//    pg.loadPixels();
//    pg.pixels = canvas.pixels;
//    pg.updatePixels();
    pg.copy(canvas,0,0,width,height,0,0,width,height);
    pg.beginDraw();
    pg.stroke(noise(0,0,nStroke*iStroke),100);
    pg.strokeWeight(2);
    float step = 5;
    float nx = px + step*cos(TWO_PI*iStroke/nAng);
    float ny = py + step*sin(TWO_PI*iStroke/nAng);
    pg.line(px, py,nx,ny);
    pg.endDraw();
    
    // calculate the error
    int totErr = 0;
    pg.loadPixels();
    target.loadPixels();
    for (int iPix=0; iPix<canvas.pixels.length; iPix++){
      totErr += abs(blue(pg.pixels[iPix]) - blue(target.pixels[iPix]));
       
    }
   // println( blue(pg.pixels[100]));
    if (totErr < minErr){
      errInd = iStroke;
      minErr = totErr;
    }
    
    
    //println(blue(pg.pixels[100]));
  }
 
  // Pick the best
  if (errInd >-1){
     println(minErr);
 
  // Render to screen
  canvas.beginDraw();
  canvas.stroke(0,100);
  canvas.strokeWeight(2);
  canvas.stroke(noise(0,0,nStroke*errInd),100);
  float step = 5;
    float nx = px + step*cos(TWO_PI*errInd/nAng);
    float ny = py + step*sin(TWO_PI*errInd/nAng);
    canvas.line(px, py,nx,ny);
    px = nx;
       py = ny;
   } else {
     println("skipping");
     skipCount++;
   }
   canvas.endDraw();
   
   if (skipCount > 5){
     px = random(width);
     py = random(height);
     skipCount = 0;
   }
   if (keyPressed){
   }else{
     
     image(canvas,0,0);
   }
  nStroke+=random(100);
}
