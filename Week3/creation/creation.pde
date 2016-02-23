float zoom = 5.0;

void setup(){
 size(1080, 720,P3D); 
 //fullScreen();
 background(0);
 initthePara();
 //colorMode(HSB, 255);
 
}

void draw(){
 generateJ(); 
 scale(1,1,zoom);
 C.r = map(mouseX, 0, width, -1, 1);
 C.i = map(mouseY, 0, height, -1, 1);
 
 textSize(22);
 text("the C.r = " + C.r, 100, 100);
 text("the C.i = " + C.i, 100, 150);
 
}