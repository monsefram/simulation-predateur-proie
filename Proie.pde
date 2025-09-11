class Proie extends GraphicObject {
  
  float angle = 0.0;
  float size = 20;
  float speed = 4.5;   // vitesse constante
  
  Proie(int x, int y) {
    instantiate();
    location.x = x;
    location.y = y;
  }
  
  void instantiate() {
    location = new PVector();
    velocity = new PVector();
    acceleration = new PVector();
  }
  
  void update(int deltaTime) {
    velocity.set(0, 0);  // réinitialiser à chaque frame

    // WASD
    if (keyPressed) {
      if (key == 'w' || key == 'W') velocity.y -= speed;
      if (key == 's' || key == 'S') velocity.y += speed;
      if (key == 'a' || key == 'A') velocity.x -= speed;
      if (key == 'd' || key == 'D') velocity.x += speed;
    }

    // mise à jour position
    location.add(velocity);
  }
  
  void display() {
    pushMatrix();
      translate(location.x, location.y);
      fill(0, 0, 200);
      ellipse(0, 0, size, size);
    popMatrix();
  }
}
