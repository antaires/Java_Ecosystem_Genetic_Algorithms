/* Handles checking collisions between two entity objects. Takes into account
vector 2D position and entity scale to determine if the entities overlap*/
static class Collider {
    
  private static boolean hasRunColliderTests = false;
  
  public static boolean hasCollision(Entity a, Entity b){
      
    //get distance between two entities based on scale
    PVector dist = PVector.sub(a.getPos(), b.getPos());
    float distance = dist.mag();
    //if distance smaller than scale of both objects, collision!
    int totalScale = a.getScale()/2 + b.getScale()/2;
    
    //run tests only once if testMode declared
    if (testMode && !hasRunColliderTests) {
      hasRunColliderTests = true;
      tests();
    }
    
    if (distance <= totalScale){
      return true;
    }    
    return false;
  }
  
  private static void tests() {
    // NOTE: All collider tests are run from Entity, to access Entity constructor
  }
}
