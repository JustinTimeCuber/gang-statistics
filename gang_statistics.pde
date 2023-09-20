int game_state = 0;
int round = 1;
int timer = 0;
int timeout = 3000;
int score = 0;
int lives = 2;
float mode1;
float mode2;
float mode3;
float peak1;
float peak2;
float peak3;
float dev1;
float dev2;
float dev3;
float skew;
float[] probs = new float[51];
float area;
float expectation_integral;
float range;
float guess;
float answer;
int rating;
PImage gang_statistics;
PImage rating1;
PImage rating2;
PImage rating3;
PImage rating4;
PImage rating5;
PImage star;
PImage life;
java.text.DecimalFormat df4 = new java.text.DecimalFormat("0.0000");
void setup() {
  gang_statistics = loadImage("gang_statistics.jpg");
  rating1 = loadImage("rating1.jpg");
  rating2 = loadImage("rating2.jpg");
  rating3 = loadImage("rating3.jpg");
  rating4 = loadImage("rating4.jpg");
  rating5 = loadImage("rating5.jpg");
  star = loadImage("star.png");
  life = loadImage("life.jpg");
  fullScreen();
  frameRate(25);
}
void draw() {
  background(0);
  if(game_state == 0) {
    image(gang_statistics, (width - gang_statistics.width*height/gang_statistics.height)/2, 0, gang_statistics.width*height/gang_statistics.height, height);
    fill(0);
    stroke(255);
    strokeWeight(2);
    rect(width/2 - height/6, 5*height/6, height/3, height/12);
    textSize(height/18);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Play", width/2, 0.87*height);
  }
  if(game_state == 1) {
    if(timer < probs.length) {
      probs[timer] = getCurve((float)timer/(probs.length - 1));
      if(timer < probs.length - 1) {
        area += 0.5*(probs[timer] + getCurve((float)(timer + 1)/(probs.length - 1)));
        expectation_integral += 1/6f*((3f*timer/(probs.length - 1) + 1f/(probs.length - 1))*probs[timer] + 
        (3f*timer/(probs.length - 1) + 2f/(probs.length - 1))*getCurve((float)(timer + 1)/(probs.length - 1)));
      }
      timer++;
      stroke(255);
      strokeWeight(2);
      line(0, height/3, width, height/3);
      line(0, 5*height/6, width, 5*height/6);
      noStroke();
      fill(255);
      for(int i = 0; i < probs.length - 1; i++) {
        quad(i*width/(probs.length - 1), 5*height/6, (i + 1)*width/(probs.length - 1) + 1, 5*height/6,
        (i + 1)*width/(probs.length - 1) + 1, 5*height/6 - probs[i + 1]*height/2, i*width/(probs.length - 1), 5*height/6 - probs[i]*height/2);
      }
      textAlign(CENTER, CENTER);
      textSize(height/36);
      text("Loading...", width/2, height/6);
      textAlign(LEFT, TOP);
      text("Score: " + score, 5, 5);
      textAlign(RIGHT, TOP);
      text("Level: " + round, width - 5, 5);
      textAlign(RIGHT, CENTER);
      textSize(height/18);
      text("Lives: ", width/2 - 5, 11*height/12);
      for(int i = 0; i < lives; i++) {
        image(life, width/2 + i*height/12, 7*height/8, height/12, height/12);
      }
    } else {
      answer = expectation_integral/area;
      range = getRange(round);
      game_state = 2;
      timeout = 3000;
    }
  }
  if(game_state == 2) {
    timeout--;
    if(timeout <= 0) {
      game_state = 0;
      round = 1;
      score = 0;
      lives = 2;
    }
    stroke(255);
    strokeWeight(2);
    line(0, height/3, width, height/3);
    line(0, 5*height/6, width, 5*height/6);
    noStroke();
    fill(255);
    for(int i = 0; i < probs.length - 1; i++) {
      quad(i*width/(probs.length - 1), 5*height/6, (i + 1)*width/(probs.length - 1) + 1, 5*height/6,
      (i + 1)*width/(probs.length - 1) + 1, 5*height/6 - probs[i + 1]*height/2, i*width/(probs.length - 1), 5*height/6 - probs[i]*height/2);
    }
    textAlign(CENTER, CENTER);
    textSize(height/36);
    text("Coach Mathes wants you to estimate the mean of this\nprobability density function. Click on the distribution to make a guess.", width/2, height/6);
    textAlign(LEFT, TOP);
    text("Score: " + score, 5, 5);
    textAlign(RIGHT, TOP);
    text("Level: " + round, width - 5, 5);
    textAlign(RIGHT, CENTER);
    textSize(height/18);
    text("Lives: ", width/2 - 5, 11*height/12);
    for(int i = 0; i < lives; i++) {
      image(life, width/2 + i*height/12, 7*height/8, height/12, height/12);
    }
    fill(255, 0, 0, 32);
    rect(mouseX - range*width/3, height/3, 2*range*width/3, height/2 + 1);
    rect(mouseX - range*width, height/3, 2*range*width, height/2 + 1);
    rect(mouseX - 2*range*width, height/3, 4*range*width, height/2 + 1);
    stroke(255, 0, 0);
    strokeWeight(2);
    line(mouseX, 5*height/6, mouseX, height/3);
  }
  if(game_state == 3) {
    if(timer >= 125) {
      game_state = 4;
      timer = 0;
      float z = abs(guess - answer)/range;
      if(z <= 1f/3) {
        rating = 5;
      } else if(z <= 1) {
        rating = 4;
      } else if(z <= 2) {
        rating = 3;
      } else if(z <= 3) {
        rating = 2;
      } else {
        rating = 1;
      }
      return;
    }
    stroke(255);
    strokeWeight(2);
    line(0, height/3, width, height/3);
    line(0, 5*height/6, width, 5*height/6);
    noStroke();
    fill(255);
    for(int i = 0; i < probs.length - 1; i++) {
      quad(i*width/(probs.length - 1), 5*height/6, (i + 1)*width/(probs.length - 1) + 1, 5*height/6,
      (i + 1)*width/(probs.length - 1) + 1, 5*height/6 - probs[i + 1]*height/2, i*width/(probs.length - 1), 5*height/6 - probs[i]*height/2);
    }
    textAlign(CENTER, CENTER);
    textSize(height/36);
    fill(255, 0, 0);
    text("Your guess: " + df4.format(guess), width/2, height/8);
    if(timer >= 25) {
      fill(0, 0, 255);
      text("Answer: " + df4.format(answer), width/2, height/6);
    }
    if(timer == 50) {
      score += getScore(range, guess, answer);
    }
    if(timer >= 50) {
      fill(255);
      int s = getScore(range, guess, answer);
      if(s != 1) {
        text(s + " Points", width/2, 5*height/24);
      } else {
        text("1 Point", width/2, 5*height/24);
      }
    }
    fill(255);
    textAlign(LEFT, TOP);
    text("Score: " + score, 5, 5);
    textAlign(RIGHT, TOP);
    text("Level: " + round, width - 5, 5);
    textAlign(RIGHT, CENTER);
    textSize(height/18);
    text("Lives: ", width/2 - 5, 11*height/12);
    for(int i = 0; i < lives; i++) {
      image(life, width/2 + i*height/12, 7*height/8, height/12, height/12);
    }
    fill(255, 0, 0, 32);
    rect(guess*width - range*width/3, height/3, 2*range*width/3, height/2 + 1);
    rect(guess*width - range*width, height/3, 2*range*width, height/2 + 1);
    rect(guess*width - 2*range*width, height/3, 4*range*width, height/2 + 1);
    stroke(255, 0, 0);
    strokeWeight(2);
    line(guess*width, 5*height/6, guess*width, height/3);
    if(timer >= 25) {
      stroke(0, 0, 255);
      line(answer*width, 5*height/6, answer*width, height/3);
    }
    timer++;
  }
  if(game_state == 4) {
    textSize(height/18);
    textAlign(CENTER, CENTER);
    fill(255);
    text("MATHES RATING:", width/2, height/4);
    if(timer >= 25) {
      if(rating == 5) {
        image(rating5, width/2 - height/6, height/3, height/3, height/3);
      }
      if(rating == 4) {
        image(rating4, width/2 - height/6, height/3, height/3, height/3);
      }
      if(rating == 3) {
        image(rating3, width/2 - height/6, height/3, height/3, height/3);
      }
      if(rating == 2) {
        image(rating2, width/2 - height/6, height/3, height/3, height/3);
      }
      if(rating == 1) {
        image(rating1, width/2 - height/6, height/3, height/3, height/3);
      }
      imageMode(CENTER);
      for(int i = 0; i < rating; i++) {
        image(star, width/2 + (i - (rating - 1)/2f) * 50, 3*height/4, 50, 50);
      }
      imageMode(CORNER);
    }
    if(timer >= 50) {
      textSize(height/36);
      if(lives < 3 && rating == 5) {
        text("+1 Life", width/2, 5*height/6);
      }
      if(lives > 1 && rating < 3) {
        text("-1 Life", width/2, 5*height/6);
      }
      if(lives == 1 && rating < 3) {
        text("Game Over", width/2, 5*height/6);
      }
    }
    if(timer >= 100) {
      if(lives < 4 && rating == 5) {
        lives++;
      }
      if(rating < 3) {
        lives--;
      }
      if(lives == 0) {
        game_state = 5;
        timer = 0;
      } else {
        round++;
        game_state = 1;
        generateCurve();
        return;
      }
    }
    timer++;
  }
  if(game_state == 5) {
    timeout--;
    if(timeout <= 0) {
      game_state = 0;
      round = 1;
      score = 0;
      lives = 2;
    }
    textSize(height/18);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Game Over\nLevel reached: " + round + "\nYour score: " + score, width/2, height/3);
    fill(0);
    stroke(255);
    strokeWeight(2);
    rect(width/2 - height/6, 5*height/6, height/3, height/12);
    fill(255);
    text("Return", width/2, 0.87*height);
  }
}
boolean mouseInRect(float x1, float y1, float dx, float dy) {
  return mouseX > x1 && mouseX < x1 + dx && mouseY > y1 && mouseY < y1 + dy;
}
void generateCurve() {
  probs = new float[51];
  timer = 0;
  mode1 = random(0.998) + 0.001;
  mode2 = random(0.998) + 0.001;
  mode3 = random(0.998) + 0.001;
  peak1 = random(1);
  peak2 = random(1);
  peak3 = random(1);
  dev1 = exp(random(5) + 2);
  dev2 = exp(random(5) + 2);
  dev3 = exp(random(5) + 2);
  skew = random(1) - 0.5;
  float peak_sum = peak1 + peak2 + peak3;
  peak1 /= peak_sum;
  peak2 /= peak_sum;
  peak3 /= peak_sum;
  area = 0;
  expectation_integral = 0;
}
float getCurve(float input) {
  float adj_input = skew <= 0 ? pow(input, skew + 1) : 1 - pow(1 - input, 1 - skew);
  return peak1/exp(dev1*(adj_input - mode1)*(adj_input - mode1)) + peak2/exp(dev2*(adj_input - mode2)*(adj_input - mode2)) + peak3/exp(dev3*(adj_input - mode3)*(adj_input - mode3));
}
float getRange(int r) {
  if(r == 1) return 0.1;
  if(r == 2) return 0.08;
  if(r == 3) return 0.06;
  if(r == 4) return 0.04;
  if(r == 5) return 0.03;
  if(r == 6) return 0.025;
  if(r == 7) return 0.0225;
  if(r == 8) return 0.02;
  if(r == 9) return 0.0175;
  if(r == 10) return 0.015;
  else return 0.015*log(5)/log(r/2f);
}
int getScore(float r, float guess, float answer) {
  float multiplier = 10/r;
  float delta = abs(guess - answer);
  if(delta <= r) {
    return round(multiplier);
  } else {
    return round(multiplier*exp(1 - delta/r));
  }
}
void mousePressed() {
  if(game_state == 0) {
    if(mouseInRect(width/2 - height/6, 5*height/6, height/3, height/12)) {
      game_state = 1;
      generateCurve();
    }
  }
  if(game_state == 2) {
    if(mouseY > height/3 && mouseY < 5*height/6) {
      guess = (float)mouseX/width;
      timer = 0;
      game_state = 3;
    }
  }
  if(game_state == 5) {
    if(mouseInRect(width/2 - height/6, 5*height/6, height/3, height/12)) {
      game_state = 0;
      round = 1;
      score = 0;
      lives = 2;
    }
  }
}
void mouseMoved() {
  timeout = 3000;
}
