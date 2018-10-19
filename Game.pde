class Game {
  int state;
  float spacing;
  Field[][] board;
  int whichPlayerMoves;
  int lastI;
  int lastJ;
  PImage ending;
  int blur;

  //beginning state of the game:
  Game() {
    state = 1;
    board = makeNewBoard();
    whichPlayerMoves = 1;
    lastI = -1;
    lastJ = -1;
    blur = 20;
  }

  //making new board:
  Field[][] makeNewBoard() {
    Field[][] newBoard = new Field[10][10];
    spacing = width/newBoard.length;
    for (int i = 0; i < newBoard.length; i++) {
      for (int j = 0; j < newBoard[i].length; j++) {
        newBoard[i][j] = new Field(j*spacing, i*spacing, spacing);
      }
    }
    return newBoard;
  }

  //display functions
  void displayBeginning() { 
    PImage img;
    img = loadImage("Start600.jpg");
    image(img, 0, 0);
    //background(255);
    //fill(#2C87E5);
    //textSize(40);
    //text("beginning text", 10, 50);
  }
  void displayBoard() {
    for (Field[] row : board) {
      for (Field field : row) {
        field.checkMouse();
        field.render();
      }
    }
  }
  void displayEnding() {
    ending = get();
    if (blur>0) {
      ending.filter(BLUR);
    }
    blur--;
    image(ending, 0, 0, width, height);
    if (blur == 0) {
      if (board[lastI][lastJ].state == 1) {
        fill(firstPlayer.moveColor);
        rect(50, 200, 500, 100);
        fill(secondPlayer.moveColor);
        textSize(40);
        text("CONGRATULATIONS!", 100, height/2-40);
      } else {
        fill(secondPlayer.moveColor);
        rect(50, 200, 500, 100);
        fill(firstPlayer.moveColor);
        textSize(40);
        text("OHHHHH YOU LOST!", 200, height/2-40);
      }
    }
  }
  
  //updating game state after player's move:
  void update(int i, int j) {
    //checking if it is a first move
    if (lastI == -1) {
      for (int k = 0; k < board.length; k++) {
        for (int l = 0; l < board[k].length; l++) {
          board[k][l].isCheckable = false;
        }
      }
    }
    
    //managing field's state and checkability:
    board[i][j].state = whichPlayerMoves;
    board[i][j].isCheckable = false;
    for (int k = i-1; k <= i+1; k++) {
      for (int l = j-1; l <= j+1; l++) {
        if (k >= 0 && k < board.length && l >= 0 && l < board[0].length) {
          if (board[k][l].state == 0 && board[k][l] != board[i][j]) {
            board[k][l].isCheckable = true;
          }
        }
      }
    }
    
    //updating game variables
    displayBoard();
    if (checkWin(board, i, j)) game.state = 3;
    lastI = i;
    lastJ = j;
    whichPlayerMoves *= -1;
  }
  
  //checking if somebody won
  boolean checkWin(Field[][] winBoard, int i, int j) {
    Field f = winBoard[i][j];
    int howManyH = 0;
    int howManyV = 0;
    int howManyD1 = 0;
    int howManyD2 = 0;
    boolean won = false;

    // horizontal and vertical
    for (int n = 0; n < winBoard.length; n++) {
      if (winBoard[i][n].state == f.state) {
        howManyH += 1;
      } else {
        howManyH = 0;
      }
      if (winBoard[n][j].state == f.state) {
        howManyV += 1;
      } else {
        howManyV = 0;
      }
      if (howManyH == 5 || howManyV == 5) {
        won = true;
        break;
      }
    }
    if (!won) {
      // diagonal
      for (int n = 0; n < winBoard.length; n++) {
        for (int m = 0; m < winBoard[n].length; m++) {
          if (n-i == m-j) {
            if (winBoard[n][m].state == f.state) {
              howManyD1 += 1;
            } else {
              howManyD1 = 0;
            }
          }
          if (n-i == j-m) {
            if (winBoard[n][m].state == f.state) {
              howManyD2 += 1;
            } else {
              howManyD2 = 0;
            }
          }
          if (howManyD1 == 5 || howManyD2 == 5) {
            won = true;
            break;
          }
        }
      }
    }
    return won;
  }
}
