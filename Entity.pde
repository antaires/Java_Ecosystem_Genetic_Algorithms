/*This class follows a component architecture system, and allows for the 
construction of all entity types found in the program. Mass is determined by size,
and speed is limited by mass*/

class Entity {
  
  private int maxHealth = 350;
  private Render r;
  private Color c = new Color(0, 0, 0);
  private Tag tag;
  private Transform t;
  private int health = 350; 
  private int topSpeed; 
  private boolean isAlive = true;
  private int turnProb = 0;
  private int restProb = 0;
  private float restAmount = 0;
  private Entity hunted = null; //for use by Pred to track specific prey
  private int foodValue = 100; //for use by Prey to eat plant, pred to eat prey
  private boolean hasCollision = false;
  private PImage image;
  
  Entity(Tag tag, PImage image, int topSpeed, float x, float y, int scale, int turnProb, int restProb, float restAmount){
    this.tag = tag;
    t = new Transform(scale/2, x, y, scale);
    t.velocity.setXY(0, 0); 
    this.topSpeed = topSpeed; 
    this.image = image;
    r = new Render(t.getScale(), tag, c, image);
    this.turnProb = turnProb;
    this.restProb = restProb;
    this.restAmount = restAmount;
    
    //run tests only once if testMode declared
    if (testMode && !hasRunEntityTests) {
      hasRunEntityTests = true;
      tests();
    }
  }
  
  //constructor for testing (in this class and others)
  public Entity(int restProb, int scale) {
    this.tag = Tag.PREY;
    t = new Transform(scale, 0, 0, scale);
    t.velocity.setXY(0, 0); 
    this.topSpeed = 10; 
    this.turnProb = 10;
    this.restProb = 10;
    this.restAmount = 0.25;
    this.restProb = restProb;
  }
  
  void update(){
    if (isAlive){
      if (!tag.equals(Tag.PLANT)){
        //moveRandom(); this is just random movement, stays constant
        if (tag.equals(Tag.PREY) && !hasCollision){
          move(); //takes into account turnProb
        } else {
          hunt();
        }
        t.update(topSpeed);//applies limits
        t.velocity.add(t.acceleration);
        t.position.add(t.velocity);
        checkEdges();
        health--;
      }
      //health value is indicated by alpha channel
       r.render(t.position, health);
    }
    if (health < 0){
      isAlive = false;
    }
  }
  
  public void applyForce(PVector force){
    PVector f = force.get();
    f.div(t.mass);
    t.acceleration.add(f);
  }
  
  private void moveRandom(){
    t.acceleration = PVector.random2D(-1, 1); 
    t.acceleration.div(t.mass);
  }
  
  private void hunt(){
    if (hunted != null && !hunted.isAlive()){
       hunted = null;
       t.acceleration.mult(0);
    }
    if (hunted != null){
      //gets vector needed to track specific prey
      //get current position of chosen prey
      PVector huntedPos = hunted.getPos();
      track(huntedPos.getX(), huntedPos.getY());
    }
  }
  
  public void setHunted(Entity hunted){
    this.hunted = hunted;
  }
  
  public boolean hasHunted(){
    if (hunted != null){
      return true;
    }
    return false;
  }
  
  //allows predators to hunt prey
  void track(float x, float y){
    PVector target = new PVector(x,y); 
    //PVector target = new PVector(mouseX, mouseY);
    PVector dir = PVector.sub(target, t.position);
    dir.normalize();
    //dir.mult(0.25);
    t.acceleration = dir; 
    t.acceleration.div(t.mass);
    rest();
  }
  
  void move(){
    //continue straight, turn based on probability
    turn();
    //pause/slow down based on restProb and restValue
    rest();
  }
  
  //with this, creatures go straight until turn
  boolean turn(){
    if (Probability.coinFlip(turnProb)){
      moveRandom();
      return true;
    }
    return false;
  }
  
  boolean rest(){
    if (Probability.coinFlip(restProb)){
      t.acceleration.mult(restAmount);
      return true;
    }
    return false;
  }
  
  public boolean isAlive(){
    return isAlive;
  }
  
  private void checkEdges(){
    if (t.position.getX() > width){
      t.position.setX(width);
      t.velocity.mult(-1);
      t.acceleration.setXY(0,0);
    } else if (t.position.getX() < 0){
      t.position.setX(0);
      t.velocity.mult(-1);
      t.acceleration.setXY(0,0);
    }
    
    if (t.position.getY() > height){
      t.position.setY(height); 
      t.velocity.mult(-1);
      t.acceleration.setXY(0,0);
    } else if (t.position.getY() < 0){
      t.position.setY(0);
      t.velocity.mult(-1);
      t.acceleration.setXY(0,0);
    }
  }
  
  public void setColor(Color c){
    setColor(c.getR(), c.getG(), c.getB());
  }
  
  public void setColor(int r, int g, int b){
    c.r = r;
    c.g = g;
    c.b = b;
    this.r = new Render(t.getScale(), tag, c, image);
  }
  
  public PVector getPos(){
    return t.getPos();
  }
  
  public int getScale(){
    return t.getScale();
  }
  
  public void addHealth(int h){
    health = health + h; 
    if (health > maxHealth){
      health = maxHealth;
    }
  }
  
  public int getHealth() {
    return health; 
  }
  
  public int getMaxHealth() {
    return maxHealth;
  }
  
  public void damage(int amount) {
    health -= amount;
    if (health < 0) {
      health = 0;
    }
  }
  
  public void eaten(int amount){
    if (foodValue > 0){
      foodValue -= amount; 
    }
    
    if (foodValue <= 0){
      kill();
    }
  }
  
  public void setHasCollision(boolean value){
    hasCollision = value;
  }
  
  public void kill(){
    health = 0;
    isAlive = false;
  }
  
  public Tag getTag(){
    return tag;
  }
  
  public float getMass(){
    return t.getMass();
  }
  
  public int getTopSpeed(){
    return topSpeed;
  }
  
  public Color getColor(){
    return c;
  }
  
  public int getTurnProb(){
    return turnProb;
  }
  
  public int getRestProb(){
    return restProb;
  }
  
  public float getRestAmount(){
    return restAmount;
  }
  
  public void colFX(){
    render.colFX(t.getPos());
  }
  
  public PVector getAcceleration() {
    return t.acceleration; 
  }
  
  private void setPos(float x, float y) {
    t.setPos(x, y);
  }
  
  private void setTag(Tag t){
    tag = t;
  }
  
  private void setScale(int s) {
    t.setScale(s);
  }
  
  private void tests() {
    Entity e = new Entity(2, 1);
    
    assert(e.getRestProb() == 2);
    
    //cannot add health to full health
    assert(e.getHealth() == e.getMaxHealth());
    e.addHealth(50);
    assert(e.getHealth() == e.getMaxHealth());
   
    e.damage(100);
    assert(e.getHealth() == e.getMaxHealth() - 100);
    
    //apply force
    PVector force = new PVector (1, 1);
    e.applyForce(force);
    assert(e.getAcceleration().getX() == 1 && e.getAcceleration().getY() == 1);
    // show resting slows entity down
    if (e.rest()) { assert(e.getAcceleration().getX() < 1 && e.getAcceleration().getY() < 1); }
      
    e.kill();
    assert(e.getHealth() == 0 && e.isAlive() == false);
    System.out.println("entity tests passed");
    
    colliderTests();
  }
  
  private void colliderTests() {
    Entity e1 = new Entity(2, 1);
    Entity e2 = new Entity(2, 1);
    e2.setTag(Tag.PRED);
    
    e1.setPos(0, 0);
    e2.setPos(0, 0);
    assert(Collider.hasCollision(e1, e2) == true);
    
    e1.setPos(1, 1);
    e2.setPos(0, 0);
    assert(Collider.hasCollision(e1, e2) == false);    
    
    e2.setScale(10);
    e1.setPos(0, 0);
    e2.setPos(0.5, 0.5);
    assert(Collider.hasCollision(e1, e2) == true);

    e1.setPos(0, 0);
    e2.setPos(0, 2);
    assert(Collider.hasCollision(e1, e2) == true);
    
    System.out.println("collider tests passed");
  }
}
