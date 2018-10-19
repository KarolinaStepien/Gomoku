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
  
  int heuristic(Field[][] fields) {
    //int jedynki = 0;
    int dwojki = 0;
    int trojki = 0;
    int czworki = 0;
    int piatki = 0;

    int suma1 = 0;
    int suma2 = 0;
    int suma = 0;

    int licznikPoziom;
    int licznikPion;
    int licznikSkosI; // \ od srodka w gore
    int licznikSkosII; // \ od ponizej srodka w dol
    int licznikSkosIII; // / od gory do srodka
    int licznikSkosIV; // / od ponizej srodka w dol /

    int dlugosc = fields.length;

    int whichPlayerMoves;

    for (int f = 0; f < 2; f++) {
      if (f == 0) {
        whichPlayerMoves = 1; //computer (different than anywhere else)
      } else {
        whichPlayerMoves = -1; //human
      }
      for (int n = 0; n < dlugosc; n++) {
        licznikPoziom = 0;
        licznikPion = 0;
        licznikSkosI = 0;
        licznikSkosII = 0;
        licznikSkosIII = 0;
        licznikSkosIV = 0;
        for (int m = 0; m < dlugosc; m++) {
          //poziom
          if (fields[n][m].state == whichPlayerMoves) {
            licznikPoziom++;
          } else {
            switch(licznikPoziom) {
              //case 1: 
              //  jedynki++;
              //  break;
            case 2: 
              dwojki++;
              break;
            case 3: 
              trojki++;
              break;
            case 4: 
              czworki++;
              break;
            case 5: 
              piatki++;
              break;
            }
            licznikPoziom = 0;
          }
          //pion
          if (fields[m][n].state == whichPlayerMoves) {
            licznikPion++;
          } else {
            switch(licznikPion) {
              //case 1: 
              //  jedynki++;
              //  break;
            case 2: 
              dwojki++;
              break;
            case 3: 
              trojki++;
              break;
            case 4: 
              czworki++;
              break;
            case 5: 
              piatki++;
              break;
            }
            licznikPion = 0;
          }
          //skos1

          // od glownej przekatnej w gore \
          if (m+n < dlugosc) {
            // od glownej przekatnej w gore \
            if (fields[m][m+n].state == whichPlayerMoves) {
              licznikSkosI++;
            } else {
              switch(licznikSkosI) {
                //case 1: 
                //  jedynki++;
                //  break;
              case 2: 
                dwojki++;
                break;
              case 3: 
                trojki++;
                break;
              case 4: 
                czworki++;
                break;
              case 5: 
                piatki++;
                break;
              }
              licznikSkosI = 0;
            }
          }
          // od glownej przekatnej w dol \
          if (m+n+1 < dlugosc) {
            if (fields[m+n+1][m].state == whichPlayerMoves) {
              licznikSkosII++;
            } else {
              switch(licznikSkosII) {
                //case 1: 
                //  jedynki++;
                //  break;
              case 2: 
                dwojki++;
                break;
              case 3: 
                trojki++;
                break;
              case 4: 
                czworki++;
                break;
              case 5: 
                piatki++;
                break;
              }
              licznikSkosII = 0;
            }
          }

          // skos2

          // od gory do glownej przekatnej /
          if (n-m >= 0) {
            if (fields[n-m][m].state == whichPlayerMoves) {
              licznikSkosIII++;
            } else {
              switch(licznikSkosIII) {
                //case 1: 
                //  jedynki++;
                //  break;
              case 2: 
                dwojki++;
                break;
              case 3: 
                trojki++;
                break;
              case 4: 
                czworki++;
                break;
              case 5: 
                piatki++;
                break;
              }
              licznikSkosIII = 0;
            }
          }
          // od glownej przekatnej w dol /
          if (n+m+1 < dlugosc) {
            if (fields[dlugosc-1-m][n+m+1].state == whichPlayerMoves) {
              licznikSkosIV++;
            } else {
              switch(licznikSkosIV) {
              //case 1: 
              //  jedynki++;
              //  break;
              case 2: 
                dwojki++;
                break;
              case 3: 
                trojki++;
                break;
              case 4: 
                czworki++;
                break;
              case 5: 
                piatki++;
                break;
              }
              licznikSkosIV = 0;
            }
          }
        } //m
      } //n
      if(whichPlayerMoves == 0){
        suma1 = /*jedynki +*/ dwojki*5 + trojki*20 + czworki*100 + piatki*1000 + (int)random(3);
      } else {
        suma2 = /*jedynki +*/ dwojki*5 + trojki*20 + czworki*100 + piatki*1000 + (int)random(3);
      }
      
    }
    suma = suma1 - suma2;
    return suma;
  }
}
