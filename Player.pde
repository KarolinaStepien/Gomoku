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
    if (level == 2) {
      //return myHeuristic(tempBoard, i, j);
      return heuristic(tempBoard);
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

  //int myHeuristic(Field[][] tempBoard, int playedI, int playedJ) {
  //  println("checking " + playedI + " " + playedJ);
  //  int state = tempBoard[playedI][playedJ].state;
  //  int score = 0;
  //  int[] value = new int[4];
  //  // horizontal -
  //  value[0] = 0;
  //  int howMany = 0;
  //  for (int i = playedJ -4; i <= playedJ +4; i++) {
  //    if (i>=0 && i < tempBoard.length) {
  //      if (tempBoard[playedI][i].state != state) {
  //        howMany = 0;
  //      } else {
  //        howMany++;
  //        if (howMany > value[0]) value[0] = howMany;
  //      }
  //    }
  //  }
  //  // vertical |
  //  value[1] = 0;
  //  howMany = 0;
  //  for (int j = playedI -4; j <= playedI +4; j++) {
  //    if (j>=0 && j < tempBoard.length) {
  //      if (tempBoard[j][playedJ].state == state) {
  //        howMany++;
  //      } else {
  //        if (howMany > value[1]) value[1] = howMany;
  //        howMany = 0;
  //      }
  //    }
  //  }
  //  // backslah \
  //  value[2] = 0;
  //  howMany = 0;
  //  for (int i = -4; i <= 4; i++) {
  //    if (playedI + i >= 0 && playedI + i < tempBoard.length && playedJ + i >= 0 && playedJ + i < tempBoard.length) {
  //      if (tempBoard[playedI + i][playedJ + i].state == state) {
  //        howMany++;
  //      } else {
  //        if (howMany > value[2]) value[2] = howMany;
  //        howMany = 0;
  //      }
  //    }
  //  }
  //  // slash /
  //  value[3] = 0;
  //  howMany = 0;
  //  for (int i = - 4; i <= 4; i++) {
  //    if (playedI - i >= 0 && playedI - i < tempBoard.length && playedJ + i >= 0 && playedJ + i < tempBoard.length) {
  //      if (tempBoard[playedI - i][playedJ + i].state == state) {
  //        howMany++;
  //      } else {
  //        if (howMany > value[3]) value[3] = howMany;
  //        howMany = 0;
  //      }
  //    }
  //  }
  //  for (int i =0; i<4; i++) {
  //    print(value[i] + " ");
  //  }
  //  for (int i =0; i<4; i++) {
  //    switch(value[i]) {
  //    case 0:
  //      score += 0;
  //      break;
  //    case 1:
  //      score += 0;
  //      break;
  //    case 2:
  //      score += 5;
  //      break;
  //    case 3:
  //      score += 20;
  //      break;
  //    case 4:
  //      score += 100;
  //      break;
  //    case 5:
  //      score += 1000;
  //      break;
  //    default:
  //      score += 1000;
  //    }
  //  }
  //  println("heuristic returned " + score);
  //  return score += (int) random(3);
  //}
}
