// Hough transform, but transfrom to mean colour rather than number of votes
PImage photo; // photo to be transformed
int rMax;
int nSamples = 100;

void setup(){
  size(800,500);
  background(255);
  
  // load the image
  photo = loadImage("imageFileName.jpg");
  
  // calculate the maximum radius needed
  rMax = ceil(sqrt(photo.width*photo.width + photo.height*photo.height));
  
  // loop over r and theta
  for (int xPix=0;xPix<height;xPix++){
    for (int yPix=0;yPix<width;yPix++){
      
      // calculate the current r and theta
      float r = map(xPix,0,height,-rMax,rMax);
      float theta = map(yPix,0,width,0,PI);
      
      // calculate the edge points of the lines
      // y0 is the y co-ord when x = 0, etc
      float y0 = r/sin(theta);
      float yMax = r/sin(theta) - photo.width*cos(theta)/sin(theta);
      float x0 = r/cos(theta);
      float xMax = r/cos(theta) - photo.height*sin(theta)/cos(theta);
      
      // take the two end points p1 and p2
      // two conditions, if x0 < xMax or otherwise
      // check the four point to find which lie in the box
      // sometimes there are more than two points (corners?)
      float [] x = new float[4];
      float [] y = new float[4];
      int count = 0;
      if (x0 > 0 && x0 < photo.width){x[count] = x0; y[count] = 0; count++;}
      if (xMax > 0 && xMax < photo.width){x[count] = xMax; y[count] = photo.height; count++;}
      if (y0 > 0 && y0 < photo.height){x[count] = 0; y[count] = y0; count++;}
      if (yMax > 0 && yMax < photo.height){x[count] = photo.width; y[count] = yMax; count++;}
      
      // sample along the line
      color[] sampledCols = new color[nSamples];
      for (int iSample=0; iSample<nSamples; iSample++){
        int xCur = round(map(iSample,0,nSamples,x[0],x[1]));
        int yCur = round(map(iSample,0,nSamples,y[0],y[1]));
        if (xCur >0 && xCur <photo.width && yCur >0 && yCur <photo.height){
          // if the point lies in the image get the current colour
          sampledCols[iSample] = photo.get(xCur,yCur);
        } else {
          // otherwise set it to black
          sampledCols[iSample] = color(0,0,0);
        }
      }
      
      // set the stroke colour to be the mean of the sampled pixels
      color c = calcColor(sampledCols);
      stroke(c);
      // changed these round as it looks better horizontally
      point(yPix,xPix);
    }
  }
}

color calcColor(color[] colArray){
  // function to calculate the mean of colours in an array
  // (could use other methods for picking a colour)
  float reds = 0;
  float greens = 0;
  float blues = 0;
  float count = 0;
  for(int iCol=0; iCol < colArray.length; iCol++){
    reds += red(colArray[iCol]);
    greens += green(colArray[iCol]);
    blues += blue(colArray[iCol]);
    // if the blue channel doesn't equal zero, increase the count by 1
    if (blue(colArray[iCol]) != 0){
      count++;
    }
  }
  color c;
  reds = reds/count;
  greens = greens/count;
  blues = blues/count;
  if (count !=0){
    c = color(reds,greens,blues);
  } else {
    // output white if there are no colours to sample over
    c = color(255);
  }
  return c;
}
