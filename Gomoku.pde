int gameState;
void setup() {
  size(600, 600);
  gameState = 1;
}
void draw() {
  switch(gameState) {
    case 1:
      //display beginning
      break;
    case 2:
      //display board
      break;
    case 3:
      //display ending
      break;
  }
}
void mousePressed() {
  switch(gameState) {
  case 1: 
    gameState = 2;
    break;
  case 2:
    //first player moves
    break;
  case 3: 
    //new game
    break;
  }
}
