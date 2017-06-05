class Star {
  PVector position = new PVector();
  float speed, zFactor, diameter, sizeMultiplier;
  color tint;
  
  Star()
  {
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
  
  void update()
  {
    speed = (425.0 - (235.0 * player.position.y / height)) * zFactor;
    position.y += tick * speed;
    position.y %= height;
  }
  
  void display()
  {
    sizeMultiplier = min(max((millis() - 2358) / 5000.0, 0), 1);
    float starHeight = sizeMultiplier * diameter + speed * speed * 0.000042;
    stroke(tint, 255 * sizeMultiplier);
    strokeWeight(1);
    line(position.x,
         position.y,
         position.x,
         position.y + starHeight);
  }
  
  void drawClouds()
  {
    if (sizeMultiplier < 1 && zFactor > 1.0) {
      fill(224, 224, 224, position.y * 0.1 - 128 * sizeMultiplier * zFactor);
      noStroke();
      ellipse(width - position.x, position.y + height / 4, zFactor * width * 0.1, zFactor * width * 0.025);
    }
  }
}