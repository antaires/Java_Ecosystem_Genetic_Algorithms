/*deals with random acts*/
static class Probability {

  public static boolean coinFlip(int range){
    //generate random number in given range
    int rand = ThreadLocalRandom.current().nextInt(0, range+1);
    
    if (rand == range){
      return true;
    }
    return false;
  }

}
