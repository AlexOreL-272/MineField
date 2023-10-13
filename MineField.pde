int fieldSize = 25;
int cellSize = 40;
int minesNum = 120;
boolean firstClick = true;
boolean isMine[][] = new boolean[fieldSize][fieldSize]; // stores if a mine on that place
boolean flag[][] = new boolean[fieldSize][fieldSize];   // stores if a flag was placed
boolean revealed[][] = new boolean[fieldSize][fieldSize]; // stores if a tile was revealed

void settings() {
  size (cellSize * fieldSize, cellSize * fieldSize);
}

void setup() {
  colorMode(HSB);

  for (int i = 0; i < fieldSize; i++)
    for (int j = 0; j < fieldSize; j++) {
      isMine[i][j] = false;
      flag[i][j] = false;
      revealed[i][j] = false;
    }
}

int numOfRevealed = 0;
void draw() {
  background(0);

  for (int i = 0; i < fieldSize; i++) {
    for (int j = 0; j < fieldSize; j++) {
      stroke(0);
      if (flag[i][j])
        fill(230, 255, 255);
      else if (!revealed[i][j])
        fill(#d2d2d2);
      else
        fill(#bdbdbd);

      square(i * cellSize, j * cellSize, cellSize);

      int num = numOfMinesNear(i, j);
      color numColor = pickColor(num);

      if (num > 0 && revealed[i][j]) {
        fill(numColor);
        noStroke();

        textSize(cellSize - 10);
        float textSize = textWidth((char)num);
        float dist = (cellSize - textSize) / 2;
        textAlign(LEFT, TOP);
        text(num, i * cellSize + dist, j * cellSize + 2);
      }
    }
  }
}

boolean outOfBounds(int  x, int y) {
  return !(x >= 0 && x < fieldSize && y >= 0 && y < fieldSize);
}

void mousePressed() {
  int x = mouseX / cellSize;
  int y = mouseY / cellSize;

  if (mouseButton == RIGHT && !revealed[x][y]) {
    flag[x][y] = !flag[x][y];
  } else {
    if (firstClick) {
      firstClick = false;
      do {
        clearMines();
        placeMines();
      } while (numOfMinesNear(x, y) != 0);
    }

    if (!flag[x][y] && isMine[x][y]) {
      noLoop();
      revealMines();

      fill(255);
      textSize(width / 8);
      textAlign(LEFT, CENTER);
      text("GAME OVER!", width * 0.1, height / 2);
      
      return;
    }

    if (!flag[x][y])
      reveal(x, y);

    if (fieldSize * fieldSize - minesNum == numOfRevealed) {
      draw();
      
      noLoop();
      fill(#bdbdbd);
      square(x * cellSize, y * cellSize, cellSize);

      revealMines();

      fill(255);
      textSize(width / 8);
      textAlign(LEFT, CENTER);
      text("YOU WON!", width * 0.18, height * 0.5);
    }
  }
}

int pickColor(int num) {
  switch (num) {
  case 1:
    return #4646f0;
  case 2:
    return #2d822d;
  case 3:
    return #d23c3c;
  case 4:
    return #2d2d96;
  case 5:
    return #821414;
  case 6:
    return #2d91a5;
  case 7:
    return #2d2d96;
  case 8:
    return #821414; 
  default:
    return #000000;
  }
}

int numOfMinesNear(int x, int y) {
  if (!outOfBounds(x, y)) {
    int sum = 0;
    for (int i = -1; i <= 1; i++)
      for (int j = -1; j <= 1; j++)
        if (!outOfBounds(x + i, y + j))
          sum += isMine[x + i][y + j] ? 1 : 0;

    return sum;
  } else return -1;
}

void placeMines() {
  int x, y, i = 0;
  while (i < minesNum) {
    x = int(random(fieldSize));
    y = int(random(fieldSize));    
    if (!isMine[x][y]) {
      isMine[x][y] = true;
      i++;
    }
  }
}

void clearMines() {
  for (int i = 0; i < fieldSize; i++)
    for (int j = 0; j < fieldSize; j++)
      isMine[i][j] = false;
}

void revealMines() {
  for (int i = 0; i < fieldSize; i++) {
    for (int j = 0; j < fieldSize; j++) {
      if (isMine[i][j]) {
        fill(0);
        noStroke();

        circle(i * cellSize + cellSize * 0.5, j * cellSize  + cellSize * 0.5, cellSize * 0.5);
        stroke(0);
        //horizontal lines
        line(i * cellSize + cellSize / 2, j * cellSize + cellSize * 0.1, 
          i * cellSize + cellSize / 2, j * cellSize + cellSize * 0.9);
        line(i * cellSize + cellSize * 0.1, j * cellSize + cellSize * 0.5, 
          i * cellSize + cellSize * 0.9, j * cellSize + cellSize * 0.5);
        // diagonal lines
        line(i * cellSize + cellSize * 0.2, j * cellSize + cellSize * 0.2, 
          i * cellSize + cellSize * 0.8, j * cellSize + cellSize * 0.8);
        line(i * cellSize + cellSize * 0.8, j * cellSize + cellSize * 0.2, 
          i * cellSize + cellSize * 0.2, j * cellSize + cellSize * 0.8);
      }
    }
  }
}

void reveal(int x, int y) {    
  if (outOfBounds(x, y) || revealed[x][y])
    return;
  revealed[x][y] = true;
  flag[x][y] = false;
  numOfRevealed++;
  if (numOfMinesNear(x, y) != 0)
    return;
  reveal(x - 1, y);
  reveal(x + 1, y);
  reveal(x, y - 1);
  reveal(x, y + 1);
  reveal(x - 1, y - 1);
  reveal(x + 1, y - 1);
  reveal(x - 1, y + 1);
  reveal(x + 1, y + 1);
}
