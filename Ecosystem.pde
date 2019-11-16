/*Evolutionary algorithm program that contains 2 type of evolving
creatures (pred vs prey) and plants, that grow in clumps. 
Creatures slowly die (become transparent) as they go without food,
food increases their health. When they collide with a food source,
the food source is killed. When they collide with the same type of
creature, there is a small chance at reproduction, in which the
genetic information of both 'parents' is combined with a small chance
of mutations for the next generation. The longer a creature lives, 
the greater chance it has of reproducing, and spreading its genetic
material. 
*/
import java.util.*; 

/*0: initial screen
 1: user interface screen
 2: game screen
 2: game-over screen
 */

// TEST MODE - to activate and run tests, set testMode to true
static boolean testMode = false;
// Note: static class test variables not listed here
boolean hasRunEntityTests = false;
boolean hasRunCreatureBuilderTests = false;
boolean hasRunBucketTests = false;
boolean hasRunBoardTests = false;

int gameScreen = 0; 
int initScreenTimer = 90;
int numPrey = 35;
int numPred = 5; 
int numPlants = 100;
int plantCount;
int minPlants = 50;
int plantGrowth = 5;
int plantGrowthTimer = 100;
int plantSpawnChance = 700;
int preySpawnChance = 500;
int predSpawnChance = 200;

//images
PImage plantImage;
PImage preyImage;
PImage predImage;
PImage titleImage;
PImage gameoverImage;

//declare objects
ArrayList<Entity> creatureList = new ArrayList<Entity>();
CreatureBuilder cb;
Board board;
Render render = new Render();
Entity entity; 

// UI 
String input = "";
// scrollbar
Scrollbar sb1, sb2, sb3, sb4, sb5, sb6, sb7, sb8, sb9, sb10, sb11, sb12, sb13, sb14, sb15, sb16, sb17; 
Scrollbar [] scrollbars = {sb1, sb2, sb3, sb4, sb5, sb6, sb7, sb8, sb9, sb10, sb11, sb12, sb13, sb14, sb15, sb16, sb17};
Integer [] scrollbarValues = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
String[] fields = {"mutation prob", "mutation range", "mutation speed", "turn prob", "rest prob", "pred max speed", 
                      "pred min size", "pred max size", "pred turn prob", "pred rest prob", "prey max speed", 
                      "prey min size", "prey max size", "prey turn prob", "prey rest prob", "plant min size", 
                      "plant max size"};

void setup() {
  size(700, 700);
   
  plantImage = loadImage("plantSprite.png");
  preyImage = loadImage("preySprite.png");
  predImage = loadImage("predSprite.png");
  titleImage = loadImage("ecosystemTitleScreen.png");
  gameoverImage = loadImage("gameoverScreen.png");
  
  cb = new CreatureBuilder(preyImage, predImage, plantImage);
  
  // UI setup 
  textAlign(CENTER, CENTER);
  textSize(30);
  fill(0);
  // scrollbar
  int position = 100; 
  for(int i = 0; i < scrollbars.length; i++){
    scrollbars[i] = new Scrollbar(200, position, width/2, 16, 16);
    position+=35;
  }
}

/******* GAME MANAGER ********/
void draw() {
  //display contents of the current screen
  if (gameScreen == 0) {
    initScreen();
  } else if (gameScreen == 1) {
    UIScreen();
  } else if (gameScreen == 2) {
    gameScreen();
  } else if (gameScreen == 3) {
    gameOverScreen();
  }
}

/******* SCREEN CONTENTS ********/
void initScreen() {
  render.drawIntroScreen(titleImage);
  
  //after timer, switch to game
  if (initScreenTimer-- < 0){
    gameScreen = 1;
  }
}

// UI screen for user to input variables
void UIScreen() {
  render.drawUIScreen();
  // when user hits "ENTER" key, the input is loaded into the creature builder object and the main game screen loads
}

//main game loop 
void gameScreen() {
  render.drawGameScreen();
  plantCount = 0;
  
  // all of game logic
  board.update();
  
  //switch to gameOver screen if all entities are dead
  if (!board.hasCreature()){
    gameScreen = 3; //gameOver
  }
}

void gameOverScreen() {
  render.drawGameOverScreen(gameoverImage);
}

/* ------ HELPER METHODS  ------ */

void createStartPop(){
  for (int i = 0; i < numPrey; i++){
    //create prey
     entity = cb.newPrey();
     creatureList.add(entity);
  }
  
    for (int i = 0; i < numPred; i++){
    //create prey
     entity = cb.newPred();
     creatureList.add(entity);
  }
  
  for (int i = 0; i < numPlants; i++){
     //create plants
     //want some idea of plants more likely to spawn next to others...
     entity = cb.newPlant();
     creatureList.add(entity);
  }
}

/* ------ EVENT LISTENERS ------ */

void keyPressed() {
  //player.input.setMove(keyCode, true);
  //make this how to pause/restart etc
  
  //for user input for UI
  if (keyCode == BACKSPACE) {
    if (input.length() > 0){
      input = input.substring(0, input.length() - 1);
    }
  } else if (keyCode == DELETE) {
    input = "";
  } else if (keyCode == ENTER && gameScreen == 1) {
    // parse string and update variable values, then set gameScreen to 2
    cb.setEcosystemParameters(
      (int) scrollbars[0].getPos(),
      (int) scrollbars[1].getPos(),
      (int) scrollbars[2].getPos(),
      (int) scrollbars[3].getPos(),
      (int) scrollbars[4].getPos(),
      (int) scrollbars[5].getPos(),
      (int) scrollbars[6].getPos(),
      (int) scrollbars[7].getPos(),
      (int) scrollbars[8].getPos(),
      (int) scrollbars[9].getPos(),
      (int) scrollbars[10].getPos(),
      (int) scrollbars[11].getPos(),
      (int) scrollbars[12].getPos(),
      (int) scrollbars[13].getPos(),
      (int) scrollbars[14].getPos(),
      (int) scrollbars[15].getPos(),
      (int) scrollbars[16].getPos()
    );
    // generate creatures 
    createStartPop();
    board = new Board(700, 700, creatureList);
    gameScreen = 2; 
  } else if ((gameScreen == 3 || gameScreen == 2) && keyCode == ENTER) {
    //restart the game
    gameScreen = 1;
  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT) {
    input = input + key;
  }
}

void keyReleased() {}
