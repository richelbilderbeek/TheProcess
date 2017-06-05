class HealthPack {
  int size = 32;
  PVector position = new PVector();
  
  HealthPack(PVector pos)
  {
    position = pos;
  }
  
  void update()
  {
    position.add(new PVector(0, tick * (-435 + ((height - player.position.y) / height) * 400)));
  }
  
  void display()
  {
    //Teken cirkel
    float intoSequence = (millis % 1000) * 0.001;
    float diameter = intoSequence * size * 4;
    noFill();
    stroke(0, 255, 255, 255 - 255 * intoSequence);
    strokeWeight(2.0);
    
    ellipse(position.x, position.y, diameter, diameter);
    
    //Teken kruis als één vorm
    float alpha = 255 * pow(sin(millis * 0.005), 4);
    fill(0, 0, 255, 255 - alpha / 2);
    stroke(0, 255, 255, 64 + 2 * alpha / 3);
    strokeWeight(random(2.0, 3.0));

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
  
  boolean hitPlayer()
  {
    if (playerLives() && player.position.dist(position) < (size * 2) / 2 + player.radius)
      return true;
    else
      return false;
  }
}