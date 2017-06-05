class Pentagon {
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
    rotation = 23 * randomizer;
    untilShot = 0.5 * shotInterval + randomizer;
  }

  void update()
  {
    //Kogeltjes verversen
    for (int b = 0; b < bullets.size(); ++b) {
      Bullet bullet = bullets.get(b);
      bullet.update();
    }

    //Als de pentagon stuk is hoeft hij verder niets meer te doen
    if (health.isZero())
      return;

    PVector oldPosition = position.copy();

    //Zak weg
    if (stationary) {
      position.add(new PVector(0, tick * (playerLives() ? 55 + (height - player.position.y) * 0.5 : 1000)));
      if (position.y > height - 200 && playerLives()) {
        targetPosition.x += random(-width / 5, width / 5);
        targetPosition.y = random(height / 4, height / 2);
        stationary = false;
      }
    //Spring vooruit
    } else {
      position = new PVector(0.025 * (position.x * 39.0 + targetPosition.x), 
        0.05 * (position.y * 19.0 + targetPosition.y));

      //Wikkel links en rechts
      if (position.x < 0) {
        targetPosition.x += width;
        position.x += width;
      } else if (position.x > width) {
        targetPosition.x -= width;
        position.x -= width;
      }

      //Kijk of het doel bereikt is
      if (position.copy().sub(targetPosition).mag() < 25) {
        stationary = true;
      }
    }

    //Draai
    rotation -= tick * (PI - max((oldPosition.y - position.y), 5.0));
    if (playerLives())
      rotation += tick * (height - player.position.y) * 0.005 + TWO_PI;

    //Schiet
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
          //De rode pentagon tekenen, kort voor een schot
          if (untilShot < 0.5) {
            float strobe = pow(0.5 + 0.5 * sin(untilShot * PI * 10), 0.5);
            stroke(255,
                   255 - untilShot * 512, 255 - untilShot * 512,
                   (255 - max(untilShot - 0.375, 0.0) * 511) * strobe);
            strokeWeight(8.0 - untilShot * 10.0);
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
        || bullet.position.y > height + radius)
      {
        bullets.remove(b);
      } else {
        bullet.display();
        //Kijk of de speler geraakt wordt
        if (bullet.hitPlayer()) {
          player.health.hit(bullet.damage);
          bullets.remove(b);
        }
      }
    }
  }
  
  void fire()
  {
    PVector bulletDirection = new PVector(player.position.x, player.position.y);
    bulletDirection.sub(position);
    bullets.add(new Bullet(new PVector(position.x, position.y), bulletDirection));
  }
}

class Bullet {
  PVector position, direction;
  float speed, radius, age, damage;
  float randomPhase = random(TWO_PI);

  Bullet(PVector pos, PVector dir)
  {
    damage = 1.0;
    age = 0.0;
    speed = 555.0;
    radius = 5.0;
    position = pos;
    direction = dir.normalize();
    position.add(direction.copy().mult(23.0));
  }

  void update()
  {
    age += tick;
    
    PVector velocity = new PVector(direction.x * speed, direction.y * speed);
    position.add(velocity.copy().mult(tick));
    if (position.x < 0)
      position.x += width;
    position.x %= width;
  }

  boolean hitPlayer()
  {
    if (player.position.dist(position) < radius + player.radius) {
      return true;
    } else {
      return false;
    }
  }

  void display()
  {
    if (hitPlayer()) {
      drawFlash(position.copy(), color(255, 32, 64));
    } else {    
      blendMode(ADD);
      for (int i = 1; i <= 3; ++i) {
        float brightness = random(511);
        fill(brightness / 2, max(brightness - 255, 0), max(brightness - 255, 0), 255 / i);
        strokeWeight(max(random(3 - i), 0));
        brightness = 320 - random(brightness);
        stroke(brightness / 2, max(brightness - 255, 0), max(brightness - 255, 0, 255 / i));
        float diameter = radius * (4 + 2 * sin((5 * i - millis) * 0.03));
        ellipse(position.x - direction.x * 10 * i, position.y - direction.y * 10 * i, diameter, diameter);
      }
      blendMode(BLEND);
    }
  }
}