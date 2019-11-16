class Transform {
  PVector position;
  float rotation; 
  int scale;
  
  PVector velocity;
  PVector acceleration; 
  
  float mass; 
  
  Transform(){
    position = new PVector(0,0);
    scale = 1;
    rotation = 0; 
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    mass = 1;
  }
  
  Transform(float mass, float x, float y, int scale){
    position = new PVector(x,y);
    this.scale = scale;
    rotation = 0;   
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    this.mass = mass;
  }
  
  //applies all limits
  void update(int topSpeed){
    velocity.limit(topSpeed);
  }
  
  public void setPos(float x, float y) {
    position.setX(x);
    position.setY(y);
  }
  
  public int getScale(){
    return scale;
  }
  
  public PVector getPos(){
    return position;
  }
  
  public float getMass(){
    return mass;
  }
  
  public void setScale(int s) {
    scale = s;
    mass = scale/2;
  }
}
