void keyPressed(){
  if (key == 'p') {
    if (paused) loop();
    else noLoop();
    paused = !paused;
  }
  for (int k = 0; k < pressedKeys.size(); ++k){
    if (pressedKeys.get(k) == key) return;
  }
  pressedKeys.append(key);
}
void keyReleased(){
  for (int k = 0; k < pressedKeys.size(); ++k){
    if (pressedKeys.get(k) == key){
      pressedKeys.remove(k);
    }
  }
}
void processInput(){
  PVector playerDirection = new PVector();
  for (int k = 0; k < pressedKeys.size(); ++k){
    switch (pressedKeys.get(k)){
      case 'l': player.fire(); break;
      case 'w': { playerDirection.add( 0.0f, -1.0f); } break;
      case 'a': { playerDirection.add(-1.0f,  0.0f); } break;
      case 's': { playerDirection.add( 0.0f,  1.0f); } break;
      case 'd': { playerDirection.add( 1.0f,  0.0f); } break;  
    }
  }
  player.velocity = player.velocity.mult(9).add( playerDirection.normalize().mult(10).add(new PVector(0, 1)) ).mult(0.1f); //Bah! Met met vectoren rekenen zou in mijn ogen gewoon met +, - en * moeten kunnen; tegenvaller.
}