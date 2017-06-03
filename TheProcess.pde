float tick;
int millis;

Ship player;
PImage playerImg;

HealthPack healthPack;

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
  
  playerImg = loadImage("Graphics/Player.png");
  player = new Ship(playerImg);
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
  
  if (millis > 2000 && healthPacks.size() == 0
   && player.health.norm < 0.5
   && playerLives()) {
    healthPacks.add(new HealthPack(new PVector(random(width), -512)));
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
  sincePentagonSpawn += tick;
  if (sincePentagonSpawn > pentagonInterval && pentagons.size() < maxPentagons) {
    sincePentagonSpawn = 0.0;
    pentagons.add(new Pentagon(new PVector(random(width), -random(1, 2) * height)));
  }
  
  //Ververs health pack
  for (int h = 0; h < healthPacks.size(); ++h) {
    HealthPack healthPack = healthPacks.get(h);
    healthPack.update();
    healthPack.display();
    if (healthPack.position.y > height + 32)
      healthPacks.remove(h);
    else if (healthPack.hitPlayer()) {
      healthPacks.remove(h);
      player.health.resetHealth();
    }
  }
  
  processInput();
}

PVector tickify(PVector vec)
{
  return new PVector(vec.x * tick, vec.y * tick);
}
float tickify(float val)
{
  return val * tick;
}
boolean playerLives()
{
  return !player.health.isZero();
}