PImage target;
PGraphics pg;
PGraphics canvas;
int errInd;
float nStroke = 0;
int minErr = 100000000;

void setup(){
  size(600,500);
  background(255);
  pg = createGraphics(width,height);
  canvas = createGraphics(width,height);
  canvas.beginDraw();
  canvas.background(255);
  canvas.endDraw();
  target = loadImage("weathered-face2.jpg");
  target.resize(width, height);
  frameRate(120);
}

void draw(){
  // Try some possible strokes
  background(255);
  int errInd = -1;
  
  float[] x1 = new float[100];
  float[] y1 = new float[100];
  float[] x2 = new float[100];
  float[] y2 = new float[100];
  for (int i=0; i<100; i++) {
    x1[i] = random(width);
    y1[i] = random(height);
    x2[i] = x1[i] + random(-10,10);
    y2[i] = y1[i] + random(-10,10);
  }
  
  canvas.loadPixels();
  
  for (int iStroke=0; iStroke<100; iStroke++){
    // copy the current canvas
//    pg.loadPixels();
//    pg.pixels = canvas.pixels;
//    pg.updatePixels();
    pg.copy(canvas,0,0,width,height,0,0,width,height);
    pg.beginDraw();
    pg.stroke(noise(0,0,nStroke*iStroke),100);
    pg.strokeWeight(2);
    pg.line(x1[iStroke],y1[iStroke],x2[iStroke],y2[iStroke]);
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
  canvas.line(x1[errInd],y1[errInd],x2[errInd],y2[errInd]);
   } else {
     println("skipping");
   }
   canvas.endDraw();
   if (keyPressed){
   }else{
     
     image(canvas,0,0);
   }
  nStroke+=random(100);
}
