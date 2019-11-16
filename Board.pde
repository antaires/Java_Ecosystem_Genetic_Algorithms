/*  store positions in 'buckets' based on x, y

  | 0  | 1  | 2  | 3  | 4  |
  | 5  | 6  | 7  | 8  | 9  |
  | 10 | 11 | 12 | 13 | 14 |
  | 15 | 16 | 17 | 18 | 19 |
  | 20 | 21 | 22 | 23 | 24 |
  
    connections
  | x-6 | x-5 | x-4 |   
  | x-1 |  x  | x+1 |
  | x+4 | x+5 | x+6 |

width / 5 = bucket width
height /5 = bucket height
  
 /idea later, can keep plant positions separately, because they 
 /only change on birth and death
  
  -Board has checkCollisions, and it uses Collider to do this, updating entities as needed
  
  The board could have a lot of useful functions, like given an entity id, return nearest PLANT, PREY or PRED etc
  
  tracks births lists, and adds them to entity list at end
*/
  
  class Board {
  
    int totalBuckets = 25; 
    private int w;
    private int h;
    private int bucketW;
    private int bucketH;
    private ArrayList<Bucket> bucketList = new ArrayList<Bucket>();
    //used to determine proper bucket for storage
    private int[][] insertList = new int[5][5];
    //to track new entities
    private ArrayList<Entity> birthList = new ArrayList<Entity>();
    //for pred to find prey
    private ArrayList<Entity> huntedList = new ArrayList<Entity>();
    private boolean hasCreature = false;
    // to prevent overpopulation freezing the program
    private int maxPrey = 50;
    private int maxPred = 20;
    private int currPrey = 0;
    private int currPred = 0;
    
    public Board(int w, int h, ArrayList<Entity> startPop){
      this.w = w;
      this.h = h; 
      bucketW = w/5;
      bucketH = h/5;
      createBuckets();
      createInsertList();
      for(Entity e: startPop){
        insert(e);
      }
      
    //run tests only once if testMode declared
    if (testMode && !hasRunBoardTests) {
      hasRunBoardTests = true;
      tests();
    }
   }
        
    private void createBuckets(){
      Bucket b;
      for (int i = 0; i < totalBuckets; i++){
        b = new Bucket(i);
        bucketList.add(b);
      }
    }
    
    private void createInsertList(){
      int cnt = 0;
      for(int i = 0; i < 5; i++){
        for(int j = 0; j < 5; j++){
          insertList[i][j] = cnt++;
        }
      }
    }
    
    //checks collisions, updates entities
    public void update(){ 
      ArrayList<Entity> temp = new ArrayList<Entity>();
      //ArrayList<Integer> conns; 
      hasCreature = false;
      
      //add births from previous update
      for (Entity e : birthList){
        insert(e);
      }
      birthList.clear();
      
      for (Bucket b : bucketList){
        if (temp != null) {temp.clear();}
        temp = (ArrayList) b.getAll();
        
        checkCollisions(temp);
      }
      
      //removes dead entities and re-sorts based on updated position
      fillBuckets();
    }
    
    private void checkCollisions(ArrayList<Entity> temp){
        plantCount = 0; currPrey = 0; currPred = 0;
        for (int i = temp.size()-1; i>=0; i--){
          // update all entities
          temp.get(i).update();
          
          //spawn new plant
          if (temp.get(i).getTag().equals(Tag.PLANT)){
              plantCount++;
             //chance of spawning more food near current food location
               if (Probability.coinFlip(plantSpawnChance)){
                 PVector pos = temp.get(i).getPos(); 
                 Color c = temp.get(i).getColor();
                 entity = cb.nextGenPlant(pos, c);
                 //birthList.add(entity);
                 birthList.add(entity);
              }
           } else {
             hasCreature = true;
           }
    
          //avoid checking collisions already checked, by keeping j larger than i
          for (int j = temp.size()-1; j>=i; j--){
            if (j == i){}
            else if (temp.get(i).getTag().equals(Tag.PLANT)){
              if (temp.get(j).getTag().equals(Tag.PREY)){
                //plant - prey
                if (Collider.hasCollision(temp.get(i), temp.get(j))){
                  //FX
                  temp.get(j).colFX(); temp.get(i).colFX();
                  
                  temp.get(j).addHealth(35);
                  temp.get(i).eaten(10);
                }
              }
            } else if (temp.get(i).getTag().equals(Tag.PREY)){
              currPrey++;
              //add to prey list
              huntedList.add(temp.get(i));
        
            if (temp.get(j).getTag().equals(Tag.PLANT)){
              //prey - plant
              if (Collider.hasCollision(temp.get(i), temp.get(j))){
                //FX
                temp.get(j).colFX(); temp.get(i).colFX();
                temp.get(j).setHasCollision(true);
                temp.get(i).addHealth(35);
                temp.get(j).eaten(10);
              } else {
                temp.get(j).setHasCollision(false);
              }
            } else if (temp.get(j).getTag().equals(Tag.PREY)){
              currPrey++;
              //prey - prey
              //FX
              temp.get(j).colFX(); temp.get(i).colFX();
              if (Probability.coinFlip(preySpawnChance) && (currPrey < maxPrey)){
                Entity child = cb.reproduce(temp.get(i), temp.get(j));
                birthList.add(child);
              }  
            } else {
            //prey - pred
              if (Collider.hasCollision(temp.get(i), temp.get(j))){
                //FX
                temp.get(j).colFX(); temp.get(i).colFX();
                
                temp.get(j).addHealth(150);
                temp.get(i).kill();
              }
            }
          } else if (temp.get(i).getTag().equals(Tag.PRED)){
            currPred++;
            //access huntedList
            if (!temp.get(i).hasHunted() && huntedList.size()>0){
              //get a random prey from list
              int hunted = ThreadLocalRandom.current().nextInt( 0 , huntedList.size() );
              temp.get(i).setHunted(huntedList.get(hunted));
            }
          
          if (temp.get(j).getTag().equals(Tag.PREY)){
            //pred - prey
            if (Collider.hasCollision(temp.get(i), temp.get(j))){
              //FX
              temp.get(j).colFX(); temp.get(i).colFX();
              
              temp.get(i).addHealth(150);
              temp.get(j).kill();
            }
          } else if (temp.get(j).getTag().equals(Tag.PRED)){
            currPred++;
            //pred - pred
             if (Collider.hasCollision(temp.get(i), temp.get(j))){
                //FX
                temp.get(j).colFX(); temp.get(i).colFX();
               
               if (Probability.coinFlip(predSpawnChance) && (currPred < maxPred)){
                 //predators have multiple offspring
                 Entity child;
                 for(int k = 0; k < 3; k++){
                    child = cb.reproduce(temp.get(i), temp.get(j));
                    birthList.add(child);
                 }
                } 
               }
              }
            }
          }

        //remove dead creatures
        if (!temp.get(i).isAlive()){
          temp.remove(i);
        }
          
      }
      
      //if plantCount below minPlants, spawn random plant
      if (plantCount < minPlants){
        entity = cb.newPlant();
        temp.add(entity);
      }
    }
    
    public void fillBuckets(){
      //get all entities on board
      ArrayList<Entity> temp = getBuckets();
      
      //clear old bucket values
      for (Bucket b : bucketList){
        b.clear();
      }
      //re-sort living entities
      for (Entity e : temp){
        if (e.isAlive()){
          insert(e); 
        }
      }
    }
    
    public void insert(Entity e){
      //places e in correct bucket using x, y
      int i = getZone(e.getPos());
      bucketList.get(i).add(e); 
    }
    
    public int getZone(PVector v){
      int x = convert(v.getX(), bucketW);
      int y = convert(v.getY(), bucketH); 
      
      int i = insertList[x][y];
      
      return i;
    }
    
    private int convert(float x, float bucketSize){
      if ( x <= bucketSize) {return 0;}
      else if ( x <= bucketSize * 2) {return 1;}     
      else if ( x <= bucketSize * 3) {return 2;}     
      else if ( x <= bucketSize * 4) {return 3;}         
      else {return 4;}
    }
    
    public ArrayList<Entity> getBuckets(){
      ArrayList<Entity> temp = new ArrayList<Entity>();
      //build array list from buckets
      for (Bucket b : bucketList){
        for (int i = 0; i < b.size(); i++){
          temp.add(b.get(i));
        }
      }
      return temp;
    }
    
    public void draw(){
      for (Bucket b: bucketList){
        System.out.println(b.name());
        for(int i = 0; i< b.size(); i++){
          System.out.println(b.get(i).getPos().getX() + " " + b.get(i).getPos().getY());
        }
      }
    }
    
    public boolean hasCreature(){
      return hasCreature;
    }
    
    private void tests() {
    
      System.out.println("board tests passed");
    }
  }
