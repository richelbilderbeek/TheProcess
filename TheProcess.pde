float tick;
int millis;

Ship player;

Star[] starField = new Star[666];
IntList pressedKeys = new IntList();
ArrayList<Pentagon> pentagons = new ArrayList<Pentagon>();
ArrayList<HealthPack> healthPacks = new ArrayList<HealthPack>();

float pentagonInterval = 2.3;
float sincePentagonSpawn = pentagonInterval;
int maxPentagons = 5;

boolean paused = false;

void setup()
{
  fullScreen(P2D);
  noCursor();
  frameRate(60);
  
  player = new Ship();
  player.reset();
  
  for (int s = 0; s < starField.length; ++s) {
    starField[s] = new Star();
  }
  
  for (int p = 0; p < 5; ++p) {
    pentagons.add(new Pentagon(new PVector(random(width), -random(2, 3) * height)));
  }
}

void draw()
{
  tick = paused ? 0.0 : (millis() - millis) * 0.001;
  millis = millis();
  
  //HealthPack toevoegen
  if (millis > 2000 && healthPacks.size() == 0
   && player.health.norm < 0.5
   && playerLives()) {
    healthPacks.add(new HealthPack(new PVector(random(width), height+512)));
  }
  
  //Verlaat de atmosfeer
  float skyFade = 1 - millis / 9000.0;
  if (skyFade > 0) {
    background(255 * pow(skyFade, 5), 255 * pow(skyFade, 3), 255 * pow(skyFade, 2));
  } else {
    background(0);
  }
  
  //Ververs sterren
  noStroke();
  for (int s = 0; s < starField.length; ++s) {
    
    starField[s].update();
    starField[s].display();
  }
  
  //Ververs speler
  if (!paused)
    player.update();
  player.display();
  
  //Ververs pentagons
  for (int p = 0; p < pentagons.size(); ++p) {
    Pentagon pentagon = pentagons.get(p);
    pentagon.update();
    if (pentagon.position.y > height + pentagon.radius
     || pentagon.health.isZero() && pentagon.bullets.size() == 0) {
      pentagons.remove(p);
    } else {
      pentagon.display();
    }
  }
  //Maak nieuwe pentagons aan
  sincePentagonSpawn += tick;
  int activePentagons = 0;
  for (int p = 0; p < pentagons.size(); ++p) {
    if (!pentagons.get(p).health.isZero())
      ++activePentagons;
  }
  if (sincePentagonSpawn > pentagonInterval && activePentagons < maxPentagons) {
    sincePentagonSpawn = 0.0;
    pentagonInterval = random(max(0.5, 50000 / millis * 5 - pentagons.size()));
    pentagons.add(new Pentagon(new PVector(random(width), -random(1, 2) * height)));
  }
  
  //Ververs HealthPack
  for (int h = 0; h < healthPacks.size(); ++h) {
    HealthPack healthPack = healthPacks.get(h);
    healthPack.update();
    healthPack.display();
    if (healthPack.position.y < -32)
      healthPacks.remove(h);
    else if (healthPack.hitPlayer()) {
      healthPacks.remove(h);
      player.health.resetHealth();
    }
  }
  
  //Teken wolken
  for (int s = 0; s < starField.length; ++s) {
    
    starField[s].drawClouds();
  }
  
  processInput();
}

boolean playerLives()
{
  return !player.health.isZero();
}

void drawFlash(PVector pos, color col)
{
      blendMode(ADD);
      //stroke(col);
      //strokeWeight(5);
      fill(col);
      noStroke();
        //Flits tekenen
      float angle = TWO_PI / 10;
      for (int f = 0; f < 2; ++f) {
        float rotation = random(TWO_PI);
        beginShape();
        for (float a = 0; a < TWO_PI; a += angle) {
          float px = pos.x + cos(a + rotation) * (a % (angle * 2) == 0 ? random(23 - f * 10, 34 - f * 11) : 5);
          float py = pos.y + sin(a + rotation) * (a % (angle * 2) == 0 ? random(23 - f * 10, 34 - f * 11) : 5);
          vertex(px, py);
        }
        endShape(CLOSE);
      }
      blendMode(BLEND);
}