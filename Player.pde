class Ship {
  PShape image = loadShape("Graphics/Player.svg");
  PVector position, velocity, size;
  float radius;
  
  int shotInterval = 235;
  int lastShot = millis() + shotInterval;
  ArrayList<Laser> lasers = new ArrayList<Laser>();

  Health health = new Health(10.0);
  Score score = new Score();
  
  //Aanmaken van het schip
  Ship() {
    velocity = new PVector();
    size = new PVector(image.width, image.height);
    radius = size.x / 2 - 5;
  }
  
  void reset()
  {
    position = new PVector(width / 2, height / 2);
    velocity.mult(0);
    health.resetHealth();
  }
  
  void update()
  {
    //Verplaats schip
    position.add(velocity.copy().mult(tick));
    if (position.x < - 0.5 * image.width) {
      position.x += width;
    } else if (position.x > width + 0.5 * image.width) {
      position.x -= width;
    }
    position.y = constrain(position.y, playerLives() ? size.y : height - size.y, height - size.y);
    
    //Lasers bijwerken
    for (int l = 0; l < lasers.size(); ++l) {
      Laser laser = lasers.get(l);
      if (laser.position.y < 0)
        lasers.remove(l);
      else {
        //Kijk of deze laser met een pentagon botst
        for (int p = 0; p < pentagons.size(); ++p) {
          Pentagon pentagon = pentagons.get(p);
          if (laser.hitPentagon(pentagon) && !pentagon.health.isZero()) {
            pentagon.health.hit(laser.damage);
            lasers.remove(l);
            if (pentagon.health.isZero()) {
              score.addScore(5);
            }
            break;
          }
        }
        laser.update();
      }
    }
  }
  
  void display()
  {
    //Teken lasers
    strokeWeight(2);
    for (int l = 0; l < lasers.size(); ++l) {
      Laser laser = lasers.get(l);
      laser.display();
    }
    //Teken score
    score.display();
    if (health.isZero())
      return;
      
    //Teken levensbalk
    health.display();
      
    //Teken vlam
    blendMode(ADD);
    for (int i = -1; i <= 1; ++i){
      for (int f = 0; f < 3; ++f){
        fill(random(128, 255), random(128, 255), random(32 * f, 32 * f + 128), 128);
        stroke(128, 0, 0);
        ellipse(position.x - i * width, position.y + 32 + random(5, 5 + 2 * f), random(1, 20 - 2 * f), 42 - 0.03 * velocity.y + random(5));
      }
    }
    
    //Teken schip
    blendMode(BLEND);
    for (int i = -1; i <= 1; ++i){
      shape(image,
            position.x - image.width / 2 + i * width,
            position.y - image.height / 2);
    }
  }
  
  //Schiet lasers
  void fire()
  {
    if (millis > lastShot + shotInterval){ 
      for (int i = -1; i <= 1; ++i){
        lasers.add(new Laser( new PVector(player.position.x + i * 23, player.position.y + abs(i % 2) * 64 - 23) ));
        lastShot = millis;
      }
    }  
  }
}

class Laser {
  PVector position, velocity, size;
  float damage = 1.0;
  
  Laser(PVector pos)
  {
    size = new PVector(5, 32);
    position = new PVector(pos.x, pos.y);
    velocity = new PVector(0, -2350);
  }
  
  void update()
  {
    position.add(velocity.copy().mult(tick));
  }
  
  void display()
  {
    if (position.y < -size.y * 2)
      return;
      
    blendMode(ADD);
    fill (random(255), 255, random(64));
    stroke(random(128), random(255), random(128), 128);
    
    for (int i = -1; i <= 1; ++i) {
      ellipse(position.x + i * width, position.y,
              size.x, size.y * 2);
    }
  }
  
  boolean hitPentagon(Pentagon pentagon)
  {
    if (pentagon.position.dist(position) < size.x + pentagon.radius
     && !pentagon.health.isZero())
    {
      drawFlash(position.copy(), color(64, 255, 32));
      return true;
    } else {
      return false;
    }
  }
}