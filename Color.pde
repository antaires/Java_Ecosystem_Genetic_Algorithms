//a class to store color information. This is useful in passing color 
//information to the renderer, and in altering this data between generations

class Color {
  private int r = 0;
  private int g = 0;
  private int b = 0;
  
  Color(int r, int g, int b){
    this.r = r;
    this.g = g;
    this.b = b;
  }
  
  public int getR(){
    return r;
  }
  
  public int getB(){
    return b;
  }
  
  public int getG(){
    return g;
  }
}
