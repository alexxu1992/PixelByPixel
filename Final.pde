import processing.sound.*;
import processing.video.*;

ArrayList<Junction> junctions = new ArrayList<Junction>();
ArrayList<Shape> shapes = new ArrayList<Shape>();
PImage img1;
SoundFile breakSound;
SoundFile[] natureSounds;
int hitted = 0;
int juncNum = 0;
int natureNum = 14;
int gobackNum = 0;
float zoom = 3;

Capture ourVideo;

void setup(){
  size(1280, 960, P3D);
  //fullScreen(P3D);
 
  img1 = loadImage("girl.jpg");
  img1.resize(width, height); 
  img1.loadPixels();
  
  String[] cameras = Capture.list();
  if(cameras.length == 0){
    println("there is no cameras available");
    exit();
  }else{
    println("Available");
    for(int i = 0; i < cameras.length; i++){
      println(cameras[i]);
    }
    ourVideo = new Capture(this, cameras[0]);
    ourVideo.start();    
  }
  
  //ourVideo = new Capture(this, width, height);
  //ourVideo.start();
  
  breakSound = new SoundFile(this, "glassbreak_2.wav");
  //breakSound = new SoundFile(this, "0.mp3");
  natureSounds = new SoundFile[natureNum];
  for(int i = 0; i < natureNum; i++){
    natureSounds[i] = new SoundFile(this, i + ".mp3");
  }
}


void draw(){
  background(0);  
  setTexture(); //this function is used to put the video data into img1
  //image(img1, 0, 0);
 
  //////////////////////////////////before broken
  if(hitted < 2){
    image(img1,0,0);
    zoom = 3;
    if(junctions.size() > 0){
      for(int i = 0; i < juncNum; i++){
        junctions.get(i).display();
      } 
    }
    if(hitted == 1){
       if(mousePressed){
         crackGrow();  
       }
    }
     for(int i = 0; i < natureNum; i++){
       natureSounds[i].stop();      
     }
 
  }
  /////////////////////////////////after broken
  if(hitted >= 2){
    
     if(hitted == 2){ //when hitted = 2, the glass break
       for(Shape shape:shapes){
         shape.display();
         shape.update1();
       }
       if(zoom > 1) zoom = zoom - 0.0001;
       translate(0,0,zoom);   
     }
     
     if(hitted > 2 && allfall == false){ //when hitted > 2, the glass fall down
       for(Shape shape:shapes){
         if(shape.animation2 == true){
           shape.display();
           shape.update2();
         }
         else{
           shape.display();
         }
       }
     }
     
     else if(hitted > 2 && allfall == true){ //this process is for going back
       gobackNum = 0;
       for(Shape shape:shapes){
         shape.display();
         if(shape.animation3 == true){
           shape.update3();
         }else{
           gobackNum++;
         }
       }
       if(gobackNum > 0.9 * shapes.size()) goback = true;
     }
    
  }
  
  println("hitted = " + hitted + "  juncNum = " + juncNum + " gobackNum= " + gobackNum);
}

//////////////////////////////////////////////put the video data into the img1
void setTexture(){
  if(ourVideo.available()){
    ourVideo.read();
    //ourVideo.loadPixels();
  }
  ourVideo.loadPixels();
  if(ourVideo.pixels.length != 0){ 
    for(int y = 0; y < height; y++){
      for(int x = 0; x < width; x++){
        getImagePixel(x, y, ourVideo.pixels, width);
        setImagePixel(x, y, R, G, B, A, img1.pixels, width);
      }
    }
  }
  img1.updatePixels();
}
//////////////////////////////////////////////show crack of the touch
float currentTime;
float lastTime = 0;
void crackGrow(){
  currentTime = millis();
  if(currentTime - lastTime > 700){
    if(juncNum < junctions.size() - 6){
      //juncNum++;
      juncNum += junctions.size()/6;
        if(juncNum > junctions.size() - 10 && juncNum < junctions.size() + 10){ //play the sound
             breakSound.play();
        }
    }
    else{
      hitted = 2;
    }
    lastTime = currentTime;
  }
}
///////////////////////////////////////////////
int fallNumber = 0;
boolean allfall = false;
boolean goback = false;
void mouseClicked(){
   if(hitted == 0 || hitted == 1 || hitted == 2){
      if(hitted == 1){ //this is used for hitted = 2
         for (int i = junctions.size() - 1; i >= 0; i--) {
             junctions.remove(i);   
         }
         for (int j = shapes.size() - 1; j >= 0; j--){
             shapes.remove(j);
         }
      }
      if(hitted == 0 || hitted == 1){
        Junction father = new Junction(mouseX, mouseY, 0, 0, null, null);
        junctions.add(father);
        firstGeneration(father);
        restGeneration();
      }
      //hitted = 1;
      if(hitted != 1) hitted ++;    
   }
   
   if(hitted > 2 && allfall == false){ // let user swipe the broken glass
      int haveFall = 0;
      for(Shape shape:shapes){
        if(shape.animation2 == false){
          float shapeDist = dist(shape.centerX, shape.centerY, mouseX, mouseY);
          if(shapeDist < 250){
            shape.animation2 = true;
            fallNumber++;
            if(fallNumber == shapes.size()) allfall = true;
          }
        }
        //if(shape.animation2 == false) haveFall++;
      }
      //if(haveFall == shapes.size()) allfall = true;
      hitted++;
      natureSounds[floor(random(natureNum - 1))].play(); ////////////////each hit will trigger one sound
   }
   
   if(hitted > 2 && allfall == true){
     for(Shape shape:shapes){
       shape.animation3 = true;
     }
     for(int i = 0; i < natureNum; i++){
       natureSounds[i].stop();      
     }
     for(int i = 0; i < natureNum; i++){
       natureSounds[i].play();      
     }
     //allfall = false;
     //natureSounds[13].play();
   }
   
   //if(allfall == true){
    if(goback == true){
      if(junctions.size() > 0){ //this is used for hitted = 2
         for (int i = junctions.size() - 1; i >= 0; i--) {
             junctions.remove(i);   
         }
         for (int j = shapes.size() - 1; j >= 0; j--){
             shapes.remove(j);
         }
      }
     for(int i = 0; i < natureNum; i++){
       natureSounds[i].stop();      
     }
     natureSounds[13].stop();
     hitted = 0;
     fallNumber = 0;
     gobackNum = 0;
     goback = false;
     allfall = false;
   }
}

void mouseReleased(){
  //if(hitted == 1 || hitted == 2){
  //  juncNum = 0;
  //}
   if(hitted == 1 || hitted == 2){
    juncNum = 0;
   }
}



int R, G, B, A;
void getImagePixel(int posx, int posy, int[] thePixels, int theWidth) {
  color thePix = thePixels[posy * theWidth + posx];
  A = (thePix >> 24) & 0xFF;
  R = (thePix >> 16) & 0xFF;
  G = (thePix >> 8 ) & 0xFF;
  B = thePix & 0xFF;
}

void setImagePixel(int posx, int posy, int r, int g, int b, int a, int[] thePixels, int theWidth) {
  int index = posy * theWidth + posx;
  a = (a << 24);                       
  r = (r << 16);                       // We are packing all 4 composents into one int
  g = (g << 8);                           // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  thePixels[index]= argb;
}