import java.util.Collections;
class Player {
  String type;
  color moveColor;

  Player(String type, color moveColor) {
    this.type = type;
    this.moveColor = moveColor;
  }

  //player's move
  void move() {
    for (int i = 0; i < game.board.length; i++) {
      for (int j = 0; j < game.board[i].length; j++) {
        if (game.board[i][j].isMouseAbove && game.board[i][j].isCheckable) {
          game.update(i, j);
          //computer's move
          if (game.state != 3) {
            int bestResult = -10000000, bestI = 0, bestJ = 0;
            for (int k = 0; k < game.board.length; k++) {
              for (int l = 0; l < game.board[k].length; l++) {
                if (game.board[k][l].isCheckable) {
                  int tempResult = secondPlayer.minMax(game.board, k, l, 1, -1);
                  if (tempResult > bestResult) {
                    bestResult = tempResult;
                    bestI = k;
                    bestJ = l;
                  }
                }
              }
            }
            game.update(bestI, bestJ);
          }
          break;
        }
      }
    }
  }

  int minMax(Field[][] prevTempBoard, int i, int j, int level, int tempWhichPlayerMoves) {
    //copying the board
    Field[][] tempBoard = game.makeNewBoard();
    for (int y = 0; y < tempBoard.length; y++) {
      for (int z = 0; z < tempBoard[y].length; z++) {
        tempBoard[y][z].state = prevTempBoard[y][z].state;
        tempBoard[y][z].isCheckable = prevTempBoard[y][z].isCheckable;
      }
    }
    //making virtual move
    tempBoard[i][j].state = tempWhichPlayerMoves;
    tempBoard[i][j].isCheckable = false;
    for (int k = i-1; k <= i+1; k++) {
      for (int l = j-1; l <= j+1; l++) {
        if (k >= 0 && k < tempBoard.length && l >= 0 && l < tempBoard[0].length) {
          if (tempBoard[k][l].state == 0 && tempBoard[k][l] != tempBoard[i][j]) {
            tempBoard[k][l].isCheckable = true;
          }
        }
      }
    }
    if (level == 1) {
      return myHeuristic(tempBoard, i, j);
      //return heuristic(tempBoard);
    } else {
      //println("considering move: " + i + ", " + j + " on level: " + level + " with player " + tempWhichPlayerMoves);
      //going deeper
      ArrayList<Integer> results = new ArrayList<Integer>();
      if (level == 1 && game.checkWin(tempBoard, i, j)) {
        return 100000;
      } else {
        for (int k = 0; k < tempBoard.length; k++) {
          for (int l = 0; l < tempBoard[k].length; l++) {
            if (tempBoard[k][l].isCheckable) {
              results.add(secondPlayer.minMax(tempBoard, k, l, level+1, tempWhichPlayerMoves*-1));
            }
          }
        }
      }
      Collections.sort(results);
      return (tempWhichPlayerMoves == 1)? results.get(results.size()-1) : results.get(0);
    }
  }
}
