class Ship {
  PImage image;
  PVector position, velocity, size;
  float health = 10;
  int shotInterval = 235;
  int lastShot = millis() + shotInterval;
  
  Ship(PImage shipImage) {
    image = shipImage;
    velocity = new PVector();
    size = new PVector(image.width, image.height);
  }
  
  void reset() {
    position = new PVector(width/2, height/2);
    velocity.mult(0);
  }
  
  void update(){
    position.add(velocity);
    if (position.x < - 0.5*image.width) { position.x += width; }
    else if (position.x > width + 0.5*image.width) { position.x -= width; }
    //position.x = constrain(position.x, size.x, width - size.x);
    position.y = constrain(position.y, size.y, height - size.y);
  }
  
  void display(){
    //Teken vlam
    blendMode(ADD);
    for (int i = -1; i <= 1; ++i){
      for (int f = 0; f < 5; ++f){
        fill(random(128, 255), random(128, 255), random(32*f, 32*f+128), 128);
        stroke(128, 0, 0);
        ellipse(position.x - 0.1*f * velocity.x + i * width, position.y + 32 + random(5, 5 + 2 * f), random(1, 20 - 2*f), 42 - 3*velocity.y + random(5));
      }
    }
    
    //Teken schip
    blendMode(BLEND);
    for (int i = -1; i <= 1; ++i){
      image(image,
            position.x - image.width/2 + i*width,
            position.y - image.height/2);
    }
  }
  
  void fire(){
    if (millis() > lastShot + shotInterval){ 
      for (int l = -1; l <= 1; ++l){
        lasers.add(new Laser( new PVector(player.position.x + l * 23, player.position.y + abs(l % 2) * 64) ));
        lastShot = millis();
      }
    }  
  }
}

class Laser {
  PVector position, velocity, size;
  
  Laser(PVector pos){
    size = new PVector(5, 32);
    position = new PVector(pos.x, pos.y - 23);
    velocity = new PVector(0, -42);
  }
  
  void update(){
    position.add(velocity);
  }
  
  void display(){
    if (position.y < -size.y * 2) return;
    blendMode(ADD);
    fill (random(255), 255, random(64));
    stroke(random(128), random(255), random(128), 128);
    for (int i = -1; i <= 1; ++i){
      ellipse(position.x + i*width, position.y,
              size.x, size.y*2);
    }
  }
}