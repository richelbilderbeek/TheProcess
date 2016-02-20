Ship player;
PImage playerImg;

Star[] starField = new Star[1024];
IntList pressedKeys = new IntList();
ArrayList<Laser> lasers = new ArrayList<Laser>();

boolean paused = false;

void setup(){
  playerImg = loadImage("Player.png");
  
  fullScreen(P2D);
  noCursor();
  strokeWeight(2);
  player = new Ship(playerImg);
  player.reset();
  
  for (int s = 0; s < starField.length; ++s){
    starField[s] = new Star();
  }
}

void draw(){
  float skyFade = max(1-millis()/9000.0, 0);
  if (skyFade > 0){
    background(255 * pow(skyFade, 5), 255 * pow(skyFade, 3), 255 * pow(skyFade, 2));
  }
  else background(0);
  noStroke();
  for (int s = 0; s < starField.length; ++s){
    starField[s].update();
    starField[s].display();
  }
  
  for (int l = 0; l < lasers.size(); ++l){
    Laser laser = lasers.get(l);
    if (laser.position.y < -height) lasers.remove(l);
    laser.update();
    laser.display();
  }
    
  player.update();
  player.display();
  
  processInput();
}