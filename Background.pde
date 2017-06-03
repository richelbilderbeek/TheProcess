class Star {
  PVector position = new PVector();
  float speed;
  float zFactor;
  float diameter;
  color tint;
  
  Star(){
    position.x = random(width);
    position.y = random(height);
    position.z = random(0.0, 1.0);
    zFactor = pow(1.23 - position.z, 5.0);
    
    diameter = 5 / (position.z + 2);
    tint = color(random(192, 255),
                 random(192, 255),
                 random(192, 255),
                 192 / (2 * position.z + 1));
  }
  
  void update(){
    speed = (425.0 - (235.0 * player.position.y / height)) * zFactor;
    position.y += tickify(speed);
    position.y %= height;
  }
  
  void display(){
    float sizeMultiplier = min(max((millis() - 2358) / 5000.0, 0), 1);
    //float starWidth = max((sizeMultiplier * diameter) / max(velocity * 0.023, 1.0), 1.0);
    float starHeight = sizeMultiplier * diameter + speed * speed * 0.000042;
    stroke(tint);
    strokeWeight(1);
    line(position.x,
         position.y,
         position.x,
         position.y + starHeight);
  }
}