import java.util.Collections;

// image to redraw
PImage img;
ArrayList colours;
ArrayList available;
int i = 0;
Boolean[][] availCheck;
Boolean rgbMode = true;
int tstart, tfinish;

void setup() {
  size(640, 360);
  background(0);
  // load the image
  img = loadImage("DSC035132.JPG");
  img.resize(width, height);
  frameRate(10000);
  availCheck = new Boolean[round(width)][round(height)];
  // create every color once and randomize the order
  colours = new ArrayList();
  for (int i=0;i<img.width;i++) {
    for (int j=0;j<img.height;j++) {
      color c = img.get(i, j);
      colours.add(c);
      availCheck[i][j] = false;
    }
  }
  // shuffle the colours
  Collections.shuffle(colours);
  //Collections.sort(colours);
  println(colours.size());
  // creat the available list
  available = new ArrayList();
//  PVector temp = new PVector(width/2,height/2);
  PVector temp = new PVector(1,1);
  //availCheck[round(temp.x)][round(temp.y)] = true;
  available.add(temp);
  tstart = 60*60*hour() + 60*minute() + second();
//  PVector temp2 = new PVector(100, 100);
//  ArrayList addAvailable = getneighbours(temp2);
//  for (int j=0; j<addAvailable.size(); j++) {
//    PVector current = (PVector) addAvailable.get(j);
//    available.add(current);
//  }
//  stroke(255, 0, 0);
//  point(round(temp2.x), round(temp2.y));
//  
//    PVector temp3 = new PVector(300, 100);
//  ArrayList addAvailable3 = getneighbours(temp3);
//  for (int j=0; j<addAvailable3.size(); j++) {
//    PVector current3 = (PVector) addAvailable3.get(j);
//    available.add(current3);
//  }
//  stroke(0, 0, 255);
//  point(round(temp3.x), round(temp3.y));
}

void draw() {
  // loop through all colors that we want to place

  for (int tempi =0; tempi<10; tempi++) {
    if (i < colours.size()) {
      //    println(i);
      //    println(frameRate);
      color c = (color)(Integer) colours.get(i);
      PVector bestLoc = new PVector();
      if (available.size() > 0) {
        // check the min diff for each available space
        int bestj = 0;
        float bestDiff = 500000;
        for (int j=0; j<available.size(); j++) {
          PVector current = (PVector) available.get(j);
          float mindiff = calcdiff(current, c);
          // check the index of the lowest mindiff
          if (mindiff < bestDiff) {
            bestj = j;
            bestDiff = mindiff;
          }
        }
        bestLoc = (PVector) available.get(bestj);
        if (i == 1){bestLoc.x = width-1; bestLoc.y = height-1;}
        available.remove(bestj);
        //      availCheck[round(bestLoc.x)][round(bestLoc.y)] = false;
        //      println(available.size());
      }

      // place the pixel

      set(round(bestLoc.x), round(bestLoc.y), c);

      // update the available list

      ArrayList addAvailable = getneighbours(bestLoc);
      //    println(addAvailable.size());
      for (int j=0; j<addAvailable.size(); j++) {
        PVector current = (PVector) addAvailable.get(j);
        color check = get(round(current.x), round(current.y));
        // if the cell is empty
        if (red(check) + green(check) + blue(check) == 0) {
          //      if ((check>>16 & 0xFF) + (check>>8 & 0xFF) + (check & 0xFF) == 0){
          // and the cell isn't in the list already
          Boolean ok = true;
          for (int jj=0; jj<available.size(); jj++) {
            PVector temp = (PVector) available.get(jj);
            if (temp.x == current.x && temp.y == current.y) {
              ok = false;
              break;
            }
          }

          if (ok) {
            //        if (!availCheck[round(current.x)][round(current.y)]){
            //          availCheck[round(current.x)][round(current.y)] = true;
            available.add(current);
            //        }
          }
          //        println(j);
        }
      }
      //   println(available);
      i++;
    } 
    else {
      tfinish = 60*60*hour() + 60*minute() + second();
      println(tfinish-tstart);
      noLoop();
    }
  }
  
  if (i % 100 == 0) {
    //saveFrame("frames2/pixelClour#####.png");
    println(i);
  }
}

// gets the difference between two colors
float coldiff(color c1, color c2) {
  float result;
  if (rgbMode) {
    float r = red(c1) - red(c2);
    float g = green(c1) - green(c2);
    float b = blue(c1) - blue(c2);
    //    float r = (c1>>16 & 0xFF) - (c2>>16 & 0xFF);
    //    float g = (c1>>8 & 0xFF) - (c2>>8 & 0xFF);
    //    float b = (c1 & 0xFF) - (c2 & 0xFF);
    result = r*r + g*g + b*b;
  } 
  else {
    float h = hue(c1) - hue(c2);
    float s = saturation(c1) - saturation(c2);
    float b = brightness(c1) - brightness(c2);
    result = h*h + s*s + b*b;
  }
  return result;
}

// gets the neighbors (3..8) of the given coordinate
ArrayList getneighbours(PVector xy) {
  ArrayList ret = new ArrayList();
  for (int dy = -1; dy <= 1; dy++) {
    if (xy.y + dy == -1 || xy.y + dy == height) {
      continue;
    }
    for (int dx = -1; dx <= 1; dx++) {
      if (xy.x + dx == -1 || xy.x + dx == width || (dx==0 && dy==0) ) {
        continue;
      }
      ret.add(new PVector(xy.x + dx, xy.y + dy));
    }
  }
  return ret;
}

// calculates how well a color fits at a given coordinate
float calcdiff(PVector xy, color c) {
  // get the diffs for each neighbor separately
  FloatList diffs = new FloatList();
  ArrayList neighbours = getneighbours(xy);
  for (int i=0;i<neighbours.size();i++) {
    PVector n = (PVector) neighbours.get(i);
    color nc = get(round(n.x), round(n.y));
    if (red(nc)+green(nc)+blue(nc) != 0) {
      //      if (nc != 0){
      diffs.append(coldiff(nc, c));
    }
  }
  // exception for the first one
  if (diffs.size() == 0) {
    diffs.append(0);
  }

  return diffs.min();
  //return diffs.max();
  //return diffs.sum()/diffs.size();
}

void keyPressed() {
  saveFrame("sortRGB###.png");
}

