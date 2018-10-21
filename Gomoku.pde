Game game;
Player firstPlayer;
Player secondPlayer;

void setup() {
  size(600, 600);
  game = new Game();
  firstPlayer = new Player("human", 255); //1
  secondPlayer = new Player("computer", 0); //-1
}

void draw() {
  switch(game.state) {
  case 1:
    game.displayBeginning();
    break;
  case 2: 
    game.displayBoard();
    break;
  case 3: 
    game.displayEnding();
    break;
  }
}

void mousePressed() {
  switch(game.state) {
  case 1: 
    game.state = 2;
    break;
  case 2:
    firstPlayer.move();
    break;
  case 3: 
    game = new Game();
    break;
  }
}
void keyPressed() {
  if(key == 'd') game.debug = !game.debug;
  if(key == 'h') println(firstPlayer.heuristic(game.board));
}
