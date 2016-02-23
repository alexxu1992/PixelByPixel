float radius = 250.0;
float rWidth = 7.0;
float noiseSeed1 = 0;
float angBorder = 0.0;

int[] lastFrame;

PImage coolcat;


void setup(){
  size(1080, 800);
  colorMode(RGB,255);
  background(0);
  blendMode(EXCLUSION);
  
  PVector originOne = new PVector(width/2, height/2);
  circles.add(new colorCircle(originOne));
  NoiseSeeds.append(random(0,2));
  
  coolcat = loadImage("coolcat.jpg");
  coolcat.resize(width, height);
  coolcat.loadPixels();
  imageMode(CENTER);
  
  lastFrame = new int[width * height];
  for(int i = 0; i < lastFrame.length; i ++){
    lastFrame[i] = coolcat.pixels[i];
  }
  
  
}


void draw(){
  background(0);
  showCircles();
  
  
  //println(frameRate);
  
}

float mapAng(float ang){
  if(ang > -PI && ang < 0){
     ang = map(ang, 0, -PI, 0, PI);
  }else if(ang > 0 && ang <= PI){
    ang = map(ang, PI, 0, PI, 2 * PI);
  }
  
  if(ang < angBorder){
    ang = map(ang, 0, angBorder, 2*PI - angBorder, 2*PI);
  }
  else{
    ang = map(ang, angBorder, 2* PI, 0, 2*PI - angBorder);
  } 
  return ang;
 
}

void mousePressed(){
  PVector newPos = new PVector();
  newPos.x = mouseX;
  newPos.y = mouseY;
  circles.add(new colorCircle(newPos));
  NoiseSeeds.append(random(0,2));
}