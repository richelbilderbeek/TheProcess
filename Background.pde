class Star {
  PVector position = new PVector();
  float velocity;
  float diameter;
  color tint;
  
  Star(){
    position.x = random(width);
    position.y = random(height);
    position.z = random(0.0, 1.0);
    
    diameter = 5 / (position.z + 2);
    tint = color(random(192, 255),
                 random(192, 255),
                 random(192, 255),
                 255 / (2 * position.z + 1));
  }
  
  void update(){
    velocity = (4.2 - (3.0 * player.position.y / height)) * (1.5 - position.z);
    position.y += velocity;
    position.y %= height;
  }
  
  void display(){
    float sizeMultiplier = min(max((millis()-2358)/5000.0, 0), 1);
    fill(tint); 
    ellipse(position.x,
            position.y,
            sizeMultiplier * diameter,
            sizeMultiplier * diameter + 0.5 * velocity);
  }
}