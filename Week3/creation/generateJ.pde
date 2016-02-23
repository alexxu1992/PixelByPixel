complex Z;
complex C;

void initthePara(){
  Z = new complex(0.0, 0.0); //<>//
  C = new complex(-0.7436416503961307, 0.1318269278684716);
}

int count = 0;
int maxItera = 200;
void generateJ(){
  for(float x = 0.0; x < width; x++){
    for(float y = 0.0; y < height; y++){
      int k;
      Z.r = -1.6 + 3.2 * (x / (width + 0.0));
      Z.i = -1.2 + 2.4 * (y / (height + 0.0));
      for( k = 0; k < maxItera; k++){
        if(Z.r * Z.r + Z.i * Z.i > 3) break;
        Z = (Z.multi(Z)).plus(C);     
      }    
      if(k < 30){
       k = floor(map(k, 0, 50, 0 ,255));
      }
      color c = color(k, k, k);
      //color colorC = defineColor(k);
      set(floor(x), floor(y), c);
    }  
  }
}

color defineColor(int itera){
  if(itera < 16) {
    return color(itera * 2,0,0);
  }else if (itera < 32) {
    return color((((itera - 16) * 128) / 126) + 128, 0, 0); 
  }else if(itera < 64){
    return color((((itera - 32) * 62) / 127) + 193, 0, 0);  
  }else if(itera < 128){
    return color((((itera - 64) * 62) / 127) + 193, 0, 0);
  }else if(itera < 256){
    return color(255, (((itera - 128) * 62) / 255) + 1, 0);
  }else{
    return color(0, 0, 0);
  }
  

}