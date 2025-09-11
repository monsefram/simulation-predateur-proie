int currentTime;
int previousTime;
int deltaTime;

int forestWidth = 100;
int nbPreds;

ArrayList<Predator> preds;
Proie proie;

boolean gameOver = false;
boolean victory = false;
int endTime = -1; // moment où la partie se termine

void setup() {
  size(800, 600);
  restartGame();
}

void draw() {
  currentTime = millis();
  deltaTime = currentTime - previousTime;
  previousTime = currentTime;

  update(deltaTime);
  display();

  // Redémarrage 2 secondes après la fin du jeu
  if ((gameOver || victory) && endTime > 0 && millis() - endTime > 2000) {
    restartGame();
  }
}

void update(int deltaTime) {
  if (gameOver || victory) return; // rien si partie finie

  proie.update(deltaTime);

  for (var p : preds) {
    p.update(deltaTime);

    // Collision proie-prédateur
    float distToPrey = dist(p.location.x, p.location.y, proie.location.x, proie.location.y);
    if (distToPrey < (p.size/2 + proie.size/2)) {
      if (!gameOver) {
        gameOver = true;
        println("Jeu terminé"); 
        endTime = millis(); // mémoriser le temps
      }
    }
  }

  // Victoire : atteint la forêt droite
  if (proie.location.x >= width - forestWidth) {
    if (!victory) {
      victory = true;
      println("Jeu gagnant");
      endTime = millis(); // mémoriser le temps
    }
  }
}

void display() {
  background(0);

  // Forêts
  fill(0, 100, 0);
  rect(0, 0, forestWidth, height);
  rect(width - forestWidth, 0, forestWidth, height);

  // Champ
  fill(224, 188, 25);
  rect(forestWidth, 0, width - 2 * forestWidth, height);

  // Affichage prédateurs et proie
  for (var p : preds) {
    p.display();
  }
  proie.display();
}

// Fonction pour réinitialiser la partie
void restartGame() {
  gameOver = false;
  victory = false;
  endTime = -1;

  // Nouveau nombre de prédateurs
  nbPreds = (int)random(10, 16);
  preds = new ArrayList<Predator>();

  // Recréer les prédateurs avec marge de 50px
  for (int i = 0; i < nbPreds; i++) {
    int x, y;
    boolean valid = false;
    while (!valid) {
      x = (int)random(forestWidth + 50, width - (forestWidth + 50));
      y = (int)random(50, height - 50);
      float distToPrey = dist(x, y, 20, height/2);
      if (distToPrey > 50) {
        preds.add(new Predator(x, y));
        valid = true;
      }
    }
  }

  // Replacer la proie au départ
  proie = new Proie(20, height / 2);
}


// Affiche une flèche représentant le vecteur v à partir du point (x, y)
void drawVectorArrow(PVector v, float x, float y, color arrowColor) {
  pushMatrix();
    translate(x, y);
    stroke(arrowColor);
    strokeWeight(2);
    fill(arrowColor);
    
    // Dessine la ligne principale
    line(0, 0, v.x, v.y);

    // Dessine la tête de flèche
    float arrowSize = 7;
    float angle = atan2(v.y, v.x);

    pushMatrix();
      translate(v.x, v.y);
      rotate(angle);
      triangle(0, 0, -arrowSize, arrowSize/2, -arrowSize, -arrowSize/2);
    popMatrix();
  popMatrix();
}
