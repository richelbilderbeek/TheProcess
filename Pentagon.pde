class Pentagon{
  boolean stationary = true;
  PVector position, targetPosition;
  float radius;
  float rotation;
  float untilShot;
  float shotInterval = 2.0;
  float randomizer = random(1.0);
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();
  
  Health health = new Health(5.0);
    
  Pentagon(PVector pos)
  {
    position = pos;
    targetPosition = new PVector(position.x, random(50, 200));
    radius = 42;
    rotation = 23;
    untilShot = 0.5 * shotInterval + randomizer;
  }
  
  void fire()
  {
    PVector bulletDirection = new PVector(player.position.x, player.position.y);
    bulletDirection.sub(position);
    bullets.add(new Bullet(new PVector(position.x, position.y),  bulletDirection));
  }
  
  void update()
  {
    for (int b = 0; b < bullets.size(); ++b) {
      Bullet bullet = bullets.get(b);
      bullet.update();
    }
    if (health.isZero())
      return;
      
    rotation += tick * PI / 2;
    if (stationary) {
      position.add(new PVector(0, tick * (playerLives() ? 55 + (height - player.position.y) * 0.5 : 1000)));
      if (position.y > height - 200 && playerLives()) {
        targetPosition.x += random(-width / 5, width / 5);
        targetPosition.y = random(height / 4, height / 2);
        stationary = false;
      }
    } else {
      position = new PVector(0.025 * (position.x * 39.0 + targetPosition.x),
                             0.05 * (position.y * 19.0 + targetPosition.y));
      
      if (position.x < 0) {
        targetPosition.x += width;
        position.x += width;
      } else if (position.x > width) {
        targetPosition.x -= width;
        position.x -= width;
      }
      
      if (position.copy().sub(targetPosition).mag() < 25) {
        stationary = true;
      }
    }
    
    untilShot -= tick;
    if (untilShot <= 0.0 && playerLives()) {
      fire();
      untilShot = shotInterval;
    }
  }
  
  void display()
  {
    if (!health.isZero()) {
      
      for (int i = -1; i <= 1; ++i) {
        stroke(96, 96, 96);
        strokeWeight(10);
        fill(64, 64, 64);
        
        //De grijze pentagon tekenen
        float angle = TWO_PI / 5;
        beginShape();
        for (float a = 0; a < TWO_PI; a += angle) {
          float px = i * width + position.x + cos(a + rotation) * radius;
          float py = position.y + sin(a + rotation) * radius;
          vertex(px, py);
        }
        endShape(CLOSE);
        
        if (playerLives()) {
          //Schot opladen
          if (untilShot < 0.5) {
            stroke(255, 255 - untilShot * 512, 255 - untilShot * 512);
            strokeWeight(5.0 - untilShot * 10.0);
            noFill();
          
            beginShape();
            for (float b = 0; b < TWO_PI; b += angle) {
              float px = i * width + position.x + cos(b + rotation) * radius * untilShot * 1.8;
              float py = position.y + sin(b + rotation) * radius * untilShot * 1.8;
              vertex(px, py);
            }
            endShape(CLOSE);
          }
        }
      }
      //Levensbalk tekenen
      health.display(position.copy().sub(new PVector(0.0, radius * 1.2)));
    }
    
    //Kogels tekenen of verwijderen
    for (int b = 0; b < bullets.size(); ++b) {
      Bullet bullet = bullets.get(b);
      if (bullet.position.y < -radius
       || bullet.position.y > height + radius
       || bullet.age > 5.0)
      {
        bullets.remove(b);
      } else {
        bullet.display();
      }
      
      if (bullet.hitPlayer()) {
        player.health.hit(bullet.damage);
        bullets.remove(b);
      }
    }
  }
}

class Bullet{
  PVector position, direction;
  float speed, radius, age, damage;
  float randomPhase = random(TWO_PI);
  
  Bullet(PVector pos, PVector dir)
  {
    damage = 1.0;
    age = 0.0;
    speed = 555.0;
    radius = 1.0;
    position = pos;
    direction = dir.normalize();
  }
  
  void update()
  {
    age += tick;
    radius = min(age * 10.0, 7.0);
    if (age < 0.1)
      radius = 10.0;
    else
      radius = 2.5 * sin(25.0 * age + randomPhase) + radius;
    
    PVector velocity = new PVector(direction.x * speed, direction.y * speed);
    position.add(tickify(velocity));
    if (position.x < 0)
      position.x += width;
    position.x %= width;
  }
  
  boolean hitPlayer()
  {
    if (player.position.dist(position) < radius + player.radius)
      return true;
    else
      return false;
  }
  
  void display()
  {
    float brightness = random(511);
    stroke(brightness / 2, max(brightness - 255, 0), max(brightness - 255, 0));
    strokeWeight(random(2));
    brightness = 320 - random(brightness);
    fill(brightness / 2, max(brightness - 255, 0), max(brightness - 255, 0));
    blendMode(ADD);
    for (int i = 1; i <= 2; ++i) {
      ellipse(position.x, position.y, radius * i, radius * i);
    }
    blendMode(BLEND);
  }
}