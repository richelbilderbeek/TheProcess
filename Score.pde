class Score{
  int score;
  PFont font = createFont("WhiteRabbitReloaded.ttf", 64);
  
  Score()
  {
    reset();
  }
  
  void display()
  {
    fill(0, 255, 0, 128);
    stroke(0, 255, 0);
    textFont(font);
    text(score, playerLives() ? width / 5 : height / 40, height / 18);
  }
  
  void reset()
  {
    setScore(0);
  }
  
  void setScore(int points)
  {
    score = points;
  }
  
  void addScore(int points)
  {
    setScore(score + points);
  }
}