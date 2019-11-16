/* A class to handle all graphical aspects of the game */
class Render {
   private int scale;
   private Tag tag;
   private PVector loc = new PVector(0,0);
   private Color c;
   private PImage image;
   private PImage [] sprites; 
   
   // Sprite information
   private final int spriteX = 4;
   private final int spriteY = 4;
   private final int totalSprites = spriteX * spriteY; // 16
   private int currentSprite = ThreadLocalRandom.current().nextInt( 0 , totalSprites );
   private int spriteW;
   private int spriteH;
   private int index = 0;
   
   public Render(int scale, Tag tag, Color c, PImage image){
    this.scale = scale;
    this.tag = tag;
    this.c = c;
    this.image = image; 
    this.sprites = new PImage[totalSprites];
    spriteW = image.width/spriteX;
    spriteH = image.height/spriteY;
    
    // set up sprite sheet
    index = 0;
    for (int x = 0; x < spriteX; x++){
      for (int y = 0; y < spriteY; y++) {
        sprites[index] = image.get(x * spriteW, y * spriteH, spriteW, spriteH);
        index++;
      }
    }
   }
   
   //constructor for drawing screens
   public Render(){}
  
  void render(PVector loc, int health){
    this.loc = loc;
    fill(c.getR(), c.getG(), c.getB(), health); 
    noStroke();
    //ellipse(loc.getX(), loc.getY(), scale, scale); 
    imageMode(CENTER);
    tint(c.getR(), c.getG(), c.getB(), health);
    // can also apply Tint alpha without changing color by using (255, health);
    
    //display the sprite
    //move the sprite
    currentSprite++;
    currentSprite %= totalSprites;
    
    image(sprites[currentSprite], loc.getX(), loc.getY(), scale, scale); 
  }
  
  public void colFX(PVector loc){
    this.loc = loc;
    fill(255, 255, 255); 
    noStroke();
    ellipse(loc.getX(), loc.getY(), scale, scale);  
  }
  
  public void drawIntroScreen(PImage titleScreen) {
    background(44, 61, 1);
    image(titleScreen, 0, 0, width, height);
  }
  
  public void drawUIScreen() {
    background(44, 61, 1);
    fill(208, 255, 0);
    
    // instructions
    textSize(20);
    textAlign(CENTER);
    text("Set the evolutionary parameters of the Ecosystem and hit ENTER", 0, 50, width, height);
    textAlign(LEFT);
    textSize(15);
    
    //draw field labels and slider values
    int distance = 90;
    for (int i = 0; i < fields.length; i++){
      text(fields[i], 10, distance, width, height);
      text(Integer.toString(scrollbarValues[i]), 600, distance, width, height);
      distance += 35;
    }
    
    // draw sliders on screen with updated values
    for (int i = 0; i < scrollbars.length; i++){
      scrollbars[i].update();
      scrollbars[i].display();
      //update value
      scrollbarValues[i] = (int) scrollbars[i].getPos();
    }
  }
  
  public void drawGameScreen() {
    color lightGreen = color(162, 214, 19);
    background(lightGreen);
  }
  
  public void drawGameOverScreen(PImage gameoverImage) {
    imageMode(CORNER);
    noTint();
    image(gameoverImage, 0, 0, width, height);
  }
}
