class Field {
  float x;
  float y;
  float a;
  int state;
  boolean isCheckable;
  boolean isMouseAbove;

  Field(float x, float y, float a) {
    this.x = x;
    this.y = y;
    this.a = a;
    this.state = 0;
    this.isCheckable = true;
    this.isMouseAbove = false;
  }

  //checking if mouse above
  void checkMouse() {
    isMouseAbove = (mouseX>x && mouseX<x+a && mouseY>y && mouseY<y+a)? true : false;
  }

  //display function
  void render() {
    if (!game.debug) {
      if (state == 0) {
        if (isMouseAbove) {
          fill(#BC8C37);
        } else {
          if (isCheckable) {
            fill(#F0D9B1);
          } else {
            fill(#F0D9B1);
          }
        }
        stroke(#6C3A04);
        strokeWeight(a/40);
        rect(x, y, a, a);
      } else {
        fill(#F0D9B1);
        stroke(#6C3A04);
        strokeWeight(a/40);
        rect(x, y, a, a);
        if (state == 1) {
          noStroke();
          fill(firstPlayer.moveColor);
          ellipse(x + a/2, y + a/2, a- 0.1*a, a-0.1*a);
        } else {
          noStroke();
          fill(secondPlayer.moveColor);
          ellipse(x + a/2, y + a/2, a- 0.1*a, a-0.1*a);
        }
      }
    } else {
      if (state == 0) {
        if (isMouseAbove) {
          fill(200);
        } else {
          if (isCheckable) {
            fill(200);
          } else {
            fill(150);
          }
        }
      } else {
        if (state == 1) {
          fill(firstPlayer.moveColor);
        } else {
          fill(secondPlayer.moveColor);
        }
      }
      stroke(#6C3A04);
      strokeWeight(a/40);
      rect(x, y, a, a);
    }
  }
}
