class HealthPack{
  int size = 32;
  PVector position = new PVector();
  
  HealthPack(PVector pos)
  {
    position = pos;
  }
  void update()
  {
    position.add(new PVector(0, tick * (55 + (height - player.position.y) * 0.5)));
  }
  
  boolean hitPlayer()
  {
    if (player.position.dist(position) < size / 2 + player.radius)
      return true;
    else
      return false;
  }
  
  
  void display()
  {
    fill(0, 0, 255);
    stroke(0, 255, 255, 128);
    strokeWeight(random(2, 3));

    beginShape();
    for (float r = 0; r < TWO_PI; r += HALF_PI) {
      for (int p = 0; p < 3; ++p) {
        PVector pPos = new PVector();
        switch (p) {
          case 0: pPos.set(size / 6, size / 2); 
          break;
          case 1: pPos.set(size / 6, size / 6);
          break;
          case 2: pPos.set(size / 2, size / 6);
          break;
          default:
          break;
        }
        pPos.rotate(-r);
        pPos.add(position);
        vertex(pPos.x, pPos.y);
      }
    }
    endShape(CLOSE);
  }
}