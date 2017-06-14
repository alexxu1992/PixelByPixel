class Shape{
  int x1, y1, x2, y2, x3, y3, x4, y4;
  int originx1, originy1, originx2, originy2, originx3, originy3, originx4, originy4;
  int dimension;
  int centerX, centerY;
  boolean animation1 = false;
  boolean animation2 = false;
  boolean animation3 = false;
  
  Shape(int X1, int Y1, int X2, int Y2, int X3, int Y3){
    x1 = X1;
    y1 = Y1;
    x2 = X2;
    y2 = Y2;
    x3 = X3;
    y3 = Y3;
    originx1 = X1;
    originy1 = Y1;
    originx2 = X2;
    originy2 = Y2;
    originx3 = X3;
    originy3 = Y3; 
    dimension = 3;
    centerX = (X1 + X2 + X3)/3;
    centerY = (Y1 + Y2 + Y3)/3;
  }
  
  Shape(int X1, int Y1, int X2, int Y2, int X3, int Y3, int X4, int Y4){
    x1 = X1;
    y1 = Y1;
    x2 = X2;
    y2 = Y2;
    x3 = X3;
    y3 = Y3;
    x4 = X4;
    y4 = Y4;
    originx1 = X1;
    originy1 = Y1;
    originx2 = X2;
    originy2 = Y2;
    originx3 = X3;
    originy3 = Y3; 
    originx4 = X4;
    originy4 = Y4;
    dimension = 4;
    centerX = (X1 + X2 + X3 + X4)/4;
    centerY = (Y1 + Y2 + Y3 + Y4)/4;
  }
  
  void display(){
    if(dimension == 3){
      beginShape();
        //noStroke();
        strokeWeight(1);
        stroke(255,80);
        texture(img1);
        vertex(x1, y1, 0, originx1, originy1);
        vertex(x2, y2, 0, originx2, originy2);
        vertex(x3, y3, 0, originx3, originy3);
      endShape();
    }
    else if(dimension == 4){
      beginShape();
        //noStroke();
        strokeWeight(1);
        stroke(255,80);
        texture(img1);
        vertex(x1, y1, 0, originx1, originy1);
        vertex(x2, y2, 0, originx2, originy2);
        vertex(x3, y3, 0, originx3, originy3);
        vertex(x4, y4, 0, originx4, originy4);
      endShape();    
    }
    //this.update();
  }
  
  int distortionRate = 25;
  void update1(){
    if(animation1 == false){
      if(dimension == 3){
        x1 += random(-distortionRate,distortionRate);
        x2 += random(-distortionRate,distortionRate);
        x3 += random(-distortionRate,distortionRate);
        y1 += random(-distortionRate,distortionRate);
        y2 += random(-distortionRate,distortionRate);
        y3 += random(-distortionRate,distortionRate);
        
      }else{
        x1 += random(-distortionRate,distortionRate);
        x2 += random(-distortionRate,distortionRate);
        x3 += random(-distortionRate,distortionRate);
        x4 += random(-distortionRate,distortionRate);
        y1 += random(-distortionRate,distortionRate);
        y2 += random(-distortionRate,distortionRate);
        y3 += random(-distortionRate,distortionRate);
        y4 += random(-distortionRate,distortionRate);
      }
      animation1 = true;
    }  
  }
  
   int fallSpeed = 6;
   void update2(){
    int newCenterY = 0;
    if(animation2 == true){
      if(dimension == 3){
        y1 += random(fallSpeed);
        y2 += random(fallSpeed);
        y3 += random(fallSpeed);
        newCenterY = floor((y1 + y2 + y3)/3);
        
      }else{
        y1 += random(fallSpeed);
        y2 += random(fallSpeed);
        y3 += random(fallSpeed);
        y4 += random(fallSpeed);
        newCenterY = floor((y1 + y2 + y3 +y4)/4);
      }
    }
    if(centerY > height + 200) animation2 = false;
  }
  
  float backSpeed = 0.0022;
  void update3(){
    if(animation3 == true){
      if(dimension == 3){
        x1 = floor(x1 + (originx1 - x1) * backSpeed);
        y1 = floor(y1 + (originy1 - y1) * backSpeed);
        x2 = floor(x2 + (originx2 - x2) * backSpeed);
        y2 = floor(y2 + (originy2 - y2) * backSpeed);
        x3 = floor(x3 + (originx3 - x3) * backSpeed);
        y3 = floor(y3 + (originy3 - y3) * backSpeed);
        float newCenterX = (x1 + x2 + x3)/3;
        float newCenterY = (y1 + y2 + y3)/3;
        float theDist = dist(centerX, centerY, newCenterX, newCenterY);
        if(theDist < 15) animation3 = false;
      }
      else if(dimension == 4){
        x1 = floor(x1 + (originx1 - x1) * backSpeed);
        y1 = floor(y1 + (originy1 - y1) * backSpeed);
        x2 = floor(x2 + (originx2 - x2) * backSpeed);
        y2 = floor(y2 + (originy2 - y2) * backSpeed);
        x3 = floor(x3 + (originx3 - x3) * backSpeed);
        y3 = floor(y3 + (originy3 - y3) * backSpeed);
        x4 = floor(x4 + (originx4 - x4) * backSpeed);
        y4 = floor(y4 + (originy4 - y4) * backSpeed);
        float newCenterX = (x1 + x2 + x3 + x4)/4;
        float newCenterY = (y1 + y2 + y3 + y4)/4;
        float theDist = dist(centerX, centerY, newCenterX, newCenterY);
        if(theDist < 15) animation3 = false;
      }
    }
  }
    
}