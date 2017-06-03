class Health {
  float hp, initial;
  float norm;
  
  Health(float init)
  {
    initial = init;
    resetHealth();
  }
  
  void setHealth(float health)
  {
    hp = constrain(health, 0.0, initial);
    norm = hp / initial;
  }
  void resetHealth()
  {
    setHealth(initial);
  }
  void hit(float damage)
  {
    setHealth(hp - damage);
  }
  
  boolean isFull()
  {
    return hp == initial;
  }
  boolean isZero()
  {
    return hp == 0.0;
  }
  
  void display()
  {
    fill(max(255 * (1.0 - norm * norm * norm), 0.0),
         255 * norm,
         0, 128);
    noStroke();
    float barWidth = norm * width / 6;
    rect(height / 40, height / 40, barWidth, 30);
        
    noFill();
    stroke(max(255 * (1.0 - norm * norm * norm), 0.0),
           255 * norm,
           0);
    barWidth = width / 6;
    rect(height / 40, height / 40, barWidth, 30);
    
  }
  void display(PVector position)
  {
    if (isFull())
      return;
      
    fill(255, 0, 0);
    noStroke();
    float barWidth = norm * 50;
    rect(position.x - barWidth / 2, position.y, barWidth, 5);
    
    noFill();
    stroke(255, 0, 0, 128);
    strokeWeight(1);
    barWidth = 50;
    rect(position.x - barWidth / 2, position.y, barWidth, 5);
  }
}