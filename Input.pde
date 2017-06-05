void keyPressed()
{
  if (key == 'p' && playerLives()) {
    if (paused)
      loop();
    else
      noLoop();
    paused = !paused;
  }
  for (int k = 0; k < pressedKeys.size(); ++k){
    if (pressedKeys.get(k) == key) return;
  }
  pressedKeys.append(key);
}

void keyReleased()
{
  for (int k = 0; k < pressedKeys.size(); ++k){
    if (pressedKeys.get(k) == key){
      pressedKeys.remove(k);
    }
  }
}

void processInput()
{
  if (!playerLives())
    return;
    
  PVector playerDirection = new PVector();
  for (int k = 0; k < pressedKeys.size(); ++k){
    switch (pressedKeys.get(k)){
      case '9': saveFrame();
      case 'l': player.fire(); break; //L is voor laser
      case 'w': { playerDirection.add( 0.0f, -1.0f); } break;
      case 'a': { playerDirection.add(-1.0f,  0.0f); } break;
      case 's': { playerDirection.add( 0.0f,  1.0f); } break;
      case 'd': { playerDirection.add( 1.0f,  0.0f); } break;  
    }
  }
  player.velocity = player.velocity.mult(9).add(playerDirection.normalize().mult(500).add(
                          new PVector(0, 42 * (1 - (player.position.y / height)) )) ).mult(0.1f);
                          //Met met vectoren rekenen zou in mijn ogen gewoon met +, - en * moeten kunnen; valt me een beetje tegen van Processing.
}