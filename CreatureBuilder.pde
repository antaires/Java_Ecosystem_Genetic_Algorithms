/*this class handles generating a new child creature given 2 parent creatures. This
class handles reproduction and is the genetic algorithm responsible for the entity
evolution. It holds the paramters that define how the evolution will progress*/
class CreatureBuilder{
  
  PImage preyImage;
  PImage predImage;
  PImage plantImage;
  
  //default values
  int mutationProb = 10;
  int scaleMutRange = 5;
  int speedMutRange = 2;
  int turnProbMutRange = 5;
  int restProbMutRange = 5;
  float restAmountMutRange = 0.2;
  
  int predMinSpeed = 10;
  int predMaxSpeed = 50;
  int predSizeMin = 1;
  int predSizeMax = 40;
  int predTurnProb = 50;
  int predRestProb = 10;
  float predRestAmount = 0.25;
  
  int preyMinSpeed = 10;
  int preyMaxSpeed = 50;
  int preySizeMin = 1;
  int preySizeMax = 40;
  int preyTurnProb = 10;
  int preyRestProb = 50;
  float preyRestAmount = 0.25;
  
  int plantSizeMin = 1;
  int plantSizeMax = 20;
  
  Color preyColor = new Color(19, 214, 142);
  Color predColor = new Color(193, 77, 0);
  // Color plantColor1 = new Color(194, 214, 21);
  Color plantColor2 = new Color(108, 122, 6);
  Color plantColor3 = new Color(147, 165, 11);
  Color plantColor1 = new Color(85, 119, 20);

  public CreatureBuilder(PImage prey, PImage pred, PImage plant ){
    plantImage = plant;
    preyImage = prey;
    predImage = pred;
    
    //run tests only once if testMode declared
    if (testMode && !hasRunCreatureBuilderTests) {
      hasRunCreatureBuilderTests = true;
      tests();
    }
  }
  
  // for testing, mutation is turned off
  private CreatureBuilder(PImage prey, PImage pred, PImage plant, boolean mutation){
    plantImage = plant;
    preyImage = prey;
    predImage = pred;  
    
    if (!mutation) {
       mutationProb = 0;
       scaleMutRange = 0;
       speedMutRange = 0;
    }
    
  }
  
  public void setEcosystemParameters(int a, int b, int c, int d, int e, int f, int g, int h, int i, int j, int k, int l, int m, int n, int o, int p, int q){
    // to avoid confusion, this method is used carefully with arrays in a set order, to assure each field is correctly assigned
    mutationProb = a;
    scaleMutRange = b;
    speedMutRange = c;
    turnProbMutRange = d;
    restProbMutRange = e;
    
    //pred
    predMaxSpeed = f;
    predSizeMin = g;
    predSizeMax = h; 
    predTurnProb = i;
    predRestProb = j;

    //prey
    preyMaxSpeed = k;
    preySizeMin =l;
    preySizeMax = m;
    preyTurnProb = n;
    preyRestProb = o;
    
    //plant
    plantSizeMin = p;
    plantSizeMax = q;
  }

  public Entity newPred(){
    Entity pred;
    
    if (predSizeMin >= predSizeMax) {
      predSizeMin = 1;
    }
    
    pred = new Entity(Tag.PRED, predImage,
      ThreadLocalRandom.current().nextInt( 1 , predMaxSpeed ), //maxSpeed
      ThreadLocalRandom.current().nextInt(0, width+1),  //x
      ThreadLocalRandom.current().nextInt(0, height+1), //y
      ThreadLocalRandom.current().nextInt(predSizeMin, predSizeMax), //size
      predTurnProb, //turnProb
      predRestProb, //restProb
      predRestAmount //restAmount
      );
    pred.setColor(predColor);
    return pred;
  }

  public Entity newPrey(){
    Entity prey;
    
    if (preySizeMin >= preySizeMax) {
      preySizeMin = 1;
    }
    
    prey = new Entity(Tag.PREY, preyImage,
      ThreadLocalRandom.current().nextInt( 1, preyMaxSpeed ), //maxSpeed
      ThreadLocalRandom.current().nextInt(0, width+1),  //x
      ThreadLocalRandom.current().nextInt(0, height+1), //y
      ThreadLocalRandom.current().nextInt(preySizeMin, preySizeMax), //size
      10, //turn Prob
      50, //rest prob
      0.25 //restAmount
      );
      
    prey.setColor(preyColor);
    
    return prey;
  }
  
    public Entity newPlant(){
    Entity plant;
    
    if (plantSizeMin >= plantSizeMax) {
      plantSizeMin = 1;
    }
    
    plant = new Entity(Tag.PLANT, plantImage,
      0,
      ThreadLocalRandom.current().nextInt(0, width+1),  //x
      ThreadLocalRandom.current().nextInt(0, height+1), //y
      ThreadLocalRandom.current().nextInt(plantSizeMin, plantSizeMax), //size
      0,
      0,
      0
      );
      
    if (Probability.coinFlip(3)){
       entity.setColor(plantColor1);
     } else {
       entity.setColor(plantColor2);
     }
      
    return plant;
  }

    public Entity nextGenPlant(PVector pos, Color c){
    Entity plant;
    
    plant = new Entity(Tag.PLANT, plantImage,
      0,
      ThreadLocalRandom.current().nextInt((int)pos.getX()-20, (int)pos.getX()+20),  //x
      ThreadLocalRandom.current().nextInt((int)pos.getY()-20, (int)pos.getY()+20), //y
      ThreadLocalRandom.current().nextInt(1, 50), //size
      0, //turn Prob
      0,
      0
      );
      
    if (Probability.coinFlip(3)){
       entity.setColor(plantColor1);
     } else {
       entity.setColor(plantColor3);
     }
      
    
    return plant;
  }

  //assumes entity a and b are of the same type
  public Entity reproduce(Entity a, Entity b){
    
    Entity child;
    int min, max;
    
    //size
    if (a.getScale() > b.getScale()){
      min = b.getScale();
      max = a.getScale(); 
    } else {
      min = a.getScale();
      max = b.getScale();
    }
    int size = ThreadLocalRandom.current().nextInt( min , max+1 );
    if (Probability.coinFlip(mutationProb)){
      if (Probability.coinFlip(1)){
        size-=scaleMutRange;
      } else {
        size+=scaleMutRange;
      }
    }
    if (size <= 0){
      size = 1;
    }
    
    //speed
    if (a.getTopSpeed() > b.getTopSpeed()){
      min = b.getTopSpeed();
      max = a.getTopSpeed(); 
    } else {
      min = a.getTopSpeed();
      max = b.getTopSpeed();
    }
    int speed = ThreadLocalRandom.current().nextInt( min , max+1 );
    if (Probability.coinFlip(mutationProb)){
      if (Probability.coinFlip(1)){
        speed-=speedMutRange;
      } else {
        speed+=speedMutRange;
      }
    }
    if (speed <= 0){
      speed = 1;
    }
    
    //turnProb
    if (a.getTurnProb() > b.getTurnProb()){
      min = b.getTurnProb();
      max = a.getTurnProb(); 
    } else {
      min = a.getTurnProb();
      max = b.getTurnProb();
    }
    int turnProb = ThreadLocalRandom.current().nextInt( min , max+1 );
    if (Probability.coinFlip(mutationProb)){
      if (Probability.coinFlip(1)){
        turnProb-=turnProbMutRange;
      } else {
        turnProb+=turnProbMutRange;
      }
    }
    if (turnProb <= 0){
      turnProb = 1;
    }
    
    //restProb
    if (a.getRestProb() > b.getRestProb()){
      min = b.getRestProb();
      max = a.getRestProb(); 
    } else {
      min = a.getRestProb();
      max = b.getRestProb();
    }
    int restProb = ThreadLocalRandom.current().nextInt( min , max+1 );
    if (Probability.coinFlip(mutationProb)){
      if (Probability.coinFlip(1)){
        restProb-=restProbMutRange;
      } else {
        restProb+=restProbMutRange;
      }
    }
    if (restProb <= 0){
      restProb = 1;
    }
    
    //restAmount
    float minf;
    float maxf;
    if (a.getRestAmount() > b.getRestAmount()){
      minf = b.getRestAmount();
      maxf = a.getRestAmount(); 
    } else {
      minf = a.getRestAmount();
      maxf = b.getRestAmount();
    }
    float restAmount = (float) (Math.random() * ((maxf - minf + 1)) + minf);
    if (Probability.coinFlip(mutationProb)){
      if (Probability.coinFlip(1)){
        restAmount-=restAmountMutRange;
      } else {
        restAmount+=restAmountMutRange;
      }
    }
    if (restAmount < 0){
      restAmount = 0.1;
    } else if (restAmount > 1){
      restAmount = 1.0;
    }
    
    PImage childImage;
    if (a.getTag().equals(Tag.PRED)){
      childImage = predImage;
    } else if (a.getTag().equals(Tag.PREY)){
      childImage = preyImage;
    } else {
      childImage = plantImage;
    }
    
    child = new Entity(a.getTag(), childImage, speed, a.getPos().getX(), a.getPos().getY(), size, turnProb, restProb, restAmount);
    child.setColor(a.getColor());

    return child;
  }
  
  private void tests() {
    CreatureBuilder cb = new CreatureBuilder(preyImage, predImage, plantImage, false);
    // create 2 entities, e1 with scale 1 and e2 with scale 10
    Entity e1 = new Entity(2, 1);
    Entity e2 = new Entity(2, 10);
 
    Entity offspring = cb.reproduce(e1, e2);
    // show that offspring scale is between parent 1 and 2 scale without mutations
    assert(offspring.getScale() >= e1.getScale() && offspring.getScale() <= e2.getScale());
    
    System.out.println("creature builder tests passed");
  }
}
