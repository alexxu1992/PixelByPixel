ArrayList<colorCircle> circles = new ArrayList<colorCircle>();
FloatList NoiseSeeds = new FloatList();

class colorCircle{
  PVector centrePos;
  float radius;
  float radiusNew;
  float AngBorder;
  float spinSpeed;
  
  colorCircle(PVector position){
    centrePos = position;
    radius = random(50,150);
    radiusNew = 0;
    AngBorder = 0.0;
    spinSpeed = random(0.01,0.05);   
  }
  
  void update(float noiseSeed){
    //println(200*(noise(noiseSeed) - 0.5));
    this.radiusNew = this.radius + 200*(noise(noiseSeed)-0.5); // updating radius  
    if(this.AngBorder >=0 && this.AngBorder <2 * PI){ // updating angle border
       this.AngBorder += this.spinSpeed;
    }else{
      this.AngBorder = 0; 
    }       
  }
  
  float mapAng(float ang){
   if(ang > -PI && ang < 0){
      ang = map(ang, 0, -PI, 0, PI);
    }else if(ang > 0 && ang <= PI){
      ang = map(ang, PI, 0, PI, 2 * PI);
    }
  
   if(ang < this.AngBorder){
    ang = map(ang, 0, this.AngBorder, 2*PI - this.AngBorder, 2*PI);
   } else{
    ang = map(ang, this.AngBorder, 2* PI, 0, 2*PI - this.AngBorder);
   } 
   return ang;
      
  }
    
}

void showCircles(){
  //loadPixels();
  for(int y = 0; y < height; y++){
    for(int x = 0; x < width; x++){
      int index = y * width + x;
      //set(x,y,lastFrame[index]);
      for(int i = 0; i < circles.size(); i++){
        float distance = dist(x, y, circles.get(i).centrePos.x, circles.get(i).centrePos.y);
        if(distance > circles.get(i).radiusNew && distance < circles.get(i).radiusNew + rWidth ){
          float Ang = atan2(y - circles.get(i).centrePos.y, x - circles.get(i).centrePos.x);
          Ang = circles.get(i).mapAng(Ang);
          int Hue = floor(map(Ang, 0, 2*PI, 10, 220));
          color c = color(251,150,Hue,Hue);
         // set(x,y,c);
          set(x,y,lastFrame[index]);
         // pixels[index] = color(251,150,Hue,Hue);
          //lastFrame[index] = pixels[index];
          //float opacity = alpha(lastFrame[index]);
         }    
        
     }      
    }
   }
  //updatePixels();
  updateCircles();
  
}

void updateCircles(){
  for(int i = 0; i < circles.size(); i++){
    NoiseSeeds.add(i,0.005);
    circles.get(i).update(NoiseSeeds.get(i)); 
  }
  
  
  
}