class Predator extends GraphicObject {

  float angle = 0.0;
  float size = 20;                 // triangle 20 px

  // État / paramètres de vision
  boolean pursuing = false;
  float visionDistance = 50;       // (on fera ±5 plus tard)
  float visionAngle = radians(120);

  // Rotation quand la proie n’est pas vue
  float rotationSpeed;             // rad/s (0.25–0.5 tour/s)
  int rotationDir;                 // +1 horaire, -1 antihoraire

  // Vitesse de poursuite (moyenne 3 ± 1)
  float chaseSpeed;

 Predator(int x, int y) {
  instantiate();
  angle = random(0, TWO_PI);
  location.x = x;
  location.y = y;

  rotationSpeed = random(HALF_PI, PI);   // 0.25 à 0.5 tour/s
  rotationDir = (random(1) < 0.8) ? 1 : -1;
  chaseSpeed   = random(2, 4);           // 3 ± 1 px/frame

  // Vision réaliste
  visionDistance = random(45, 55);
}


  void instantiate() {
    location = new PVector();
    velocity = new PVector();
    acceleration = new PVector();
  }

  // Détection : la proie est-elle dans le cône de vision ?
  boolean sees(Proie prey) {
    PVector toPrey = PVector.sub(prey.location, location);
    float distance = toPrey.mag();
    if (distance > visionDistance) return false;

    PVector dir = new PVector(cos(angle), sin(angle));
    float dot = PVector.dot(dir, toPrey.copy().normalize());
    float theta = acos(dot);
    return theta < visionAngle / 2.0;
  }

  // Implémentation demandée par GraphicObject
  void update(int deltaTime) {
    if (proie == null) return; // sécurité

    if (sees(proie)) {
      pursuing = true;

      // Se dirige vers la proie
      PVector toPrey = PVector.sub(proie.location, location);
      toPrey.normalize();
      toPrey.mult(chaseSpeed);
      velocity = toPrey;

      // Oriente le triangle
      angle = atan2(velocity.y, velocity.x);

    } else {
      pursuing = false;
      velocity.mult(0);

      // Rotation sur place
      angle += rotationDir * rotationSpeed * (deltaTime / 1000.0);
    }

    // Mise à jour de la position
    location.add(velocity);
  }

  void display() {
    pushMatrix();
      translate(location.x, location.y);
      rotate(angle);

      // Rouge si poursuite, gris sinon
      fill(pursuing ? color(255, 0, 0) : color(200));
      stroke(0);
      triangle(-size/2, size/2,  size/2, size/2,  0, -size/2);
    popMatrix();
  }
}
