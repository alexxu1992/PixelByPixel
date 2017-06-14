class Junction{
  int x;
  int y;
  int level;
  int age; // 0 is younger, 1 is elder
  float branchAngle; //determine the basic direction
  float storedAngle;  //used for setting the sequence
  boolean stop;
  Junction father;
  Junction brother;
  Junction uncle;
  Junction remoteUncle;
  Junction remoteCousin;
  ArrayList<Junction> children;
  
  Junction(int X, int Y, int Level, float Angle, Junction Father, Junction Brother){
    x= X;
    y = Y;
    level = Level;
    storedAngle = Angle;
    father = Father;
    brother = Brother;
    children = new ArrayList<Junction>();
    stop = false;
  }
  
  void display(){
      if(age == 0){
      fill(110,110,255);
    }else{
      fill(255,110,110);
    }
    //ellipse(x, y, 10, 10);  
    if(level > 0){
      strokeWeight(2);
      stroke(220,80);
      line(x, y, father.x, father.y);
      line(x, y, brother.x, brother.y); 
      if(level >= 2){
        if(remoteCousin != null){ 
          line(x, y, remoteCousin.x, remoteCousin.y);
        }
       
      }
    }
  }
  
  Junction getChild(int theAge){
    if(theAge == 0){
      if(this.children.get(0).age == 0){
        return this.children.get(0);
      }else{
        return this.children.get(1);
      }
    }
    else{      
      if(this.children.get(0).age == 1){
        return this.children.get(0);
      }else{
        return this.children.get(1);
      }
    }  
  }
    
}

void firstGeneration(Junction father){
  float actualAngle = 0.0;
  float storeAngle = 0.0;
  float radius = random(5, 10);
  //Junction ourFather = junctions.get(0);
  Junction ourFather = father;
  Junction newChild;
  for(int i = 0; i < 5; i++){
    radius = random(25, 75);
    int posX = ourFather.x + floor(radius * cos(actualAngle));
    int posY = ourFather.y + floor(radius * sin(actualAngle));
    storeAngle = angleTransition(actualAngle);
    ///////////////////////////////////////////////divide into two condition according to the 
    if(ourFather.children.size() == 0){   
      newChild = new Junction(posX, posY , ourFather.level + 1, storeAngle, ourFather, null);  
    }else{
      newChild = new Junction(posX, posY, ourFather.level + 1, storeAngle, ourFather, ourFather.children.get(ourFather.children.size() -1));
      shapes.add(new Shape(newChild.x, newChild.y, newChild.father.x, newChild.father.y, newChild.brother.x, newChild.brother.y));
    }  
    junctions.add(newChild);
    ourFather.children.add(newChild); 
    newChild.branchAngle = actualAngle;
    actualAngle += 2*PI / 5; 
    if(i == 4){
      int childNum = ourFather.children.size();
      Junction firstChild = ourFather.children.get(0);
      firstChild.brother = ourFather.children.get(childNum - 1);
      shapes.add(new Shape(firstChild.x, firstChild.y, firstChild.father.x, firstChild.father.y, firstChild.brother.x, firstChild.brother.y));
    }
  }
}

void restGeneration(){
   int theLevel = junctions.get(junctions.size() - 1).level;
   int levelNum = 0;
   int stopNum = 0;
   //boolean stop = false;
   while(theLevel < 5){                ///////////////////////////to generate 10 level of junction
   //while(!stop){
     int newLevel = theLevel + 1;
     levelNum = 0;
     stopNum = 0;
     for(int i = 0; i < junctions.size() - 1; i++){
       if(junctions.get(i).level == theLevel){ ////////////////////////here every junction will generate 2 children
         Junction Father = junctions.get(i);
         levelNum = levelNum + 1;        
         if(Father.stop) stopNum = stopNum + 1;       
         float branchAngle = Father.branchAngle;
         float changedAngle = random(PI/7, PI/6);
         if(!Father.stop){
             Junction Uncle = Father.brother;
             ////////////////////////////////////////////////the first child
             float angle1 = branchAngle + changedAngle;
             float storedAngle1 = angleTransition(angle1);
             float radius1 = random(100 + 40*theLevel, 150 + 40*theLevel);
             int thisposX1 = Father.x + floor(radius1 * cos(angle1));             
             int thisposY1 = Father.y + floor(radius1 * sin(angle1));
             int posX1 = constrain(thisposX1, 0, width);
             int posY1 = constrain(thisposY1, 0, height);
             Junction son1 = new Junction(posX1, posY1, newLevel, storedAngle1, Father, null);
             son1.branchAngle = branchAngle + 0.1 * angle1;
             Father.children.add(son1);
             junctions.add(son1);
             son1.uncle = Uncle;
             if(thisposX1 > width || thisposY1 > height || thisposX1 < 0 || thisposY1 < 0) son1.stop = true;
             ////////////////////////////////////////////////the second child
             float angle2 = branchAngle - changedAngle;
             float storedAngle2 = angleTransition(angle2);
             float radius2 = random(100 + 40*theLevel, 150 + 40*theLevel);
             int thisposX2 = Father.x + floor(radius2 * cos(angle2));       
             int thisposY2 = Father.y + floor(radius2 * sin(angle2));       
             int posX2 = constrain(thisposX2, 0, width);
             int posY2 = constrain(thisposY2, 0, height);
             Junction son2 = new Junction(posX2, posY2, newLevel, storedAngle2, Father, son1);
             son2.branchAngle = branchAngle - 0.1 * angle2;
             son1.brother = son2;
             son2.brother = son1;
             son2.uncle = Uncle;
             Father.children.add(son2);
             junctions.add(son2);
             if(thisposX2 > width || thisposY2 > height || thisposX2 < 0 || thisposY2 < 0) son2.stop = true;          
             shapes.add(new Shape(son1.x, son1.y, son2.x, son2.y, Father.x, Father.y));
             ////////////////////////////////////////////////to arrange their age according to the storedAngle
             if(angle1 * angle2 > 0){  ///should place in clock direction
               if(storedAngle1 > storedAngle2){
                 son1.age = 0;
                 son2.age = 1;
               }else{
                 son1.age = 1;
                 son2.age = 0;
               }
             }else{
               if(storedAngle1 > storedAngle2){
                 son1.age = 1;
                 son2.age = 0;
               }else{
                 son1.age = 0;
                 son2.age = 1;
               }
             }             
         } /////////////////////////////////// if(!Father.stop) end 
           
       } 
     }//here we finish creating the new level of junction, then we need to create the cousin for each child   
     float stopIndex = (stopNum * 2 + 0.0) / (levelNum + 0.0);
     //println("the level = " + theLevel + "the levelNum =  " + levelNum +"   the stopNum =   " +stopNum);
     if(stopIndex > 0.65){
       //stop = true;
       println(" i stop the adding");
     }   
     theLevel = newLevel;
   }//end while, end adding the junction 
   connectCousin();
}

void connectCousin(){       //now we have set up the correct sequence of a level and conncted the brother and son
   int theLevel = 2;
   while(theLevel < 6){
   for(int i = 0; i < junctions.size(); i++){        //so next we need to connect the cousin and uncle from level 2
     Junction Me = junctions.get(i);
     if(Me.level == theLevel){
     //////////////////////////////// this is just for level 2, because they don't have second uncle
     if(theLevel == 2){
       //println("now the level = " + theLevel);
       if(Me.age == 0){  //if i am the small one, then i need to find my uncle's elder one     
           Junction remoteCousin = Me.uncle.getChild(1);         
           Me.remoteCousin = remoteCousin;
           remoteCousin.remoteCousin = Me;
           shapes.add(new Shape(Me.x, Me.y, Me.remoteCousin.x, Me.remoteCousin.y, Me.uncle.x, Me.uncle.y, Me.father.x, Me.father.y));      
       }
     }
     //////////////////////////////// below is the rest levels and they have remote cousin
     else if(theLevel > 2){
      if(Me.father.age == 0){        //we can just use one side of junction for symmetry
        if(Me.age == 0){
           if(Me.father.remoteCousin != null){
              Me.remoteUncle = Me.father.remoteCousin;         
             if(!Me.remoteUncle.stop){
                Junction  remoteCousin = Me.remoteUncle.getChild(1); 
                Me.remoteCousin = remoteCousin;
                remoteCousin.remoteCousin = Me;
                shapes.add(new Shape(Me.x, Me.y, remoteCousin.x, remoteCousin.y, Me.remoteUncle.x, Me.remoteUncle.y, Me.father.x, Me.father.y));
             }
           }
        }
        else if(Me.age == 1){
          Me.uncle = Me.father.brother;
          if(!Me.uncle.stop){
            Junction remoteCousin;
            remoteCousin = Me.uncle.getChild(0);
            Me.remoteCousin = remoteCousin;
            remoteCousin.remoteCousin = Me;
            shapes.add(new Shape(Me.x, Me.y, Me.father.x, Me.father.y, Me.uncle.x, Me.uncle.y, Me.remoteCousin.x, Me.remoteCousin.y));
          }
       }
      }
     }
    ///////////////////////////////////
      }             ///////////////////////////////this ending Me.level == theLevel
    }               //this ending for loop
    theLevel = theLevel + 1;
   }//this ending while
  
  
}



float angleTransition(float originAngle){  /////////////from actual to stored
  if(originAngle > 0 && originAngle < 2*PI){
    originAngle = map(originAngle, 0, 2*PI, 2*PI, 0);
  }
  else{
    originAngle = map(originAngle, 0, -PI, 0, PI);
  } 
  return originAngle;
}