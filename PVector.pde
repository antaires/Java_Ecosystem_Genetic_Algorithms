/*this class is based on work from the Nature of Code by Daniel Shiffman*/
import java.util.concurrent.ThreadLocalRandom;

static class PVector {
  
  private float x;
  private float y;
  private static boolean hasRunTests = false;
  
  PVector(float x_, float y_){
    x = x_;
    y = y_; 
    
    //run tests only once if testMode declared
    if (testMode && !hasRunTests) {
      hasRunTests = true;
      tests();
    }
  }
  
  void setAll(PVector p){
    x = p.x;
    y = p.y;
  }
  
  void setXY(float _x, float _y){
    x = _x;
    y = _y; 
  }
  
  void setX(float x_){
    x = x_; 
  }
  
  void setY(float y_){
    y = y_; 
  }
  
  float getX(){
    return x; 
  }
  
  float getY(){
    return y; 
  }
  
  void add(PVector v){
    y = y + v.y; 
    x = x + v.x; 
  }
  
  static PVector add(PVector v1, PVector v2){
    PVector v3 = new PVector(0,0);
    v3.add(v1);
    v3.add(v2);
    return v3;
  }
  
  void sub(PVector v) {
    x = x - v.x;
    y = y - v.y; 
  }
  
  static PVector sub(PVector a, PVector b){
    PVector subVec = new PVector(0,0);
    subVec.setX(a.getX()-b.getX());
    subVec.setY(a.getY()-b.getY());
    return subVec;
  }
  
  void mult(float n) {
    x = x * n;
    y = y * n;
  }
  
  void div(float n){
    x = x / n;
    y = y / n;
  }
  
  float mag() {
    return sqrt(x*x + y*y); 
  }
  
  void normalize() {
    float m = mag();
    if (m != 0) {
      div(m); 
    }
  }
  
  void limit(float max){
    if (this.mag() > max){
      this.normalize();
      this.mult(max); 
    } 
  }
  
  PVector get(){
    PVector copy = new PVector(x, y); 
    return copy; 
  }
  
  //Euclidean distance between 2 vectors
  //float dist(PVector a, PVector b){}
  
 
  static PVector random2D(int min, int max){
    PVector rand = new PVector((float)ThreadLocalRandom.current().nextInt(min, max+1), 
                               (float) ThreadLocalRandom.current().nextInt(min, max+1)); 
    return rand; 
  }
  
  private void tests(){
    testMath();
    System.out.println("pvector tests passed");
  }
  
  private void testMath() {
    PVector v1 = new PVector(1, 1);
    PVector v2 = new PVector(2, 2);
    PVector v3 = new PVector(1, 1);

    
    v1.add(v2);
    assert(v1.getX() == 3 && v1.getY() == 3);
    
    v1.sub(v2);
    assert(v1.getX() == 1 && v1.getY() == 1);
    
    v1.mult(5);
    assert(v1.getX() == 5 && v1.getY() == 5);

    v1.add(v3);
    assert(v1.getX() == 6 && v1.getY() == 6);
    v1.div(2);
    assert(v1.getX() == 3 && v1.getY() == 3);
  }
}
