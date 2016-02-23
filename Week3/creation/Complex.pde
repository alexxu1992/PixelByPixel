class complex{
  float r;
  float i;
  
  complex(float real, float imagine){
    r = real;
    i = imagine;
  }
  
  complex plus(complex guest){
    float thereal = this.r + guest.r;
    float theima = this.i + guest.i;
    complex newone = new complex(0, 0);
    newone.r = thereal;
    newone.i = theima;
    return newone;
  }
  
  complex multi(complex guest){
    float newR = this.r * guest.r - this.i * guest.i;
    float newI = this.r * guest.i + this.i * guest.r;
    complex newone = new complex(0,0);
    newone.r = newR;
    newone.i = newI;
    return newone;
    
  }
  
}