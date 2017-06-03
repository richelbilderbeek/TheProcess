class Score{
  int score;
  PFont font = createFont("WhiteRabbitReloaded.ttf", 64);
  
  Score()
  {
    reset();
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
  void display()
  {
    fill(0, 255, 0, 128);
    stroke(0, 255, 0);
    textFont(font);
    text(score, width / 5, height / 18);
  }
}