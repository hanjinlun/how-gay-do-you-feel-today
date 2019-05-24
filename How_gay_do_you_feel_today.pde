import processing.serial.*;

// Game variables
Serial myPort;  // Create object from Serial class
PFont font;
int findplayers_start_ms;
int bounce_start_ms;
int correct1_start_ms;
int wrong1_start_ms;
int correct2_start_ms;
int wrong2_start_ms;
int player1_colour = 0;
int player2_colour = 0;
int choice = 0;

// Bounce variables
int rad = 20;        // Width of the shape
int xpos, ypos;    // Starting position of shape    
float xspeed;   // Speed of the shape
float yspeed;   // Speed of the shape
int xdirection = 1;  // Left or Right
int ydirection = 1;  // Top to Bottom
IntList inventory;
IntList posX;
IntList posY;
FloatList dirX;
FloatList dirY;
FloatList speedX;
FloatList speedY;
StringList colour;


public enum States { 
  START, FINDPLAYERS, EXPLAIN, PLAYER1, PLAYER2, GUESS, GUESS1, GUESS2, WRONG1, CORRECT1, WRONG2, CORRECT2, THANKYOU, BOUNCE,
};

States state = States.START;
String slide_text[] = 
  {
  "Hello, please press any button to start", 
  "This is a two player game. You have one minute to find another person to start the game. Please press any button when you are both ready.", 
  "Both of you will need to rate yourselves from 1 to 5 based on ‘how gay do you feel today’. Please don’t look at each others answers !"
};

void bounce_setup()
{
  inventory = new IntList();
  posX = new IntList();
  posY = new IntList();
  dirX = new FloatList();
  dirY = new FloatList();
  speedX = new FloatList();
  speedY = new FloatList();  
  // Set the starting position of the shape
  xpos = width/2;
  ypos = height/2;
  fullScreen();
  smooth();
  noStroke();
  frameRate(30);
  ellipseMode(RADIUS);
}

void setup()
{
  String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  bounce_setup();
  fullScreen();
  font=loadFont("RiftSoft-Bold-48.vlw"); 
  textFont(font);


  // Set the starting position of the shape
}

void draw_slide(String text) {
  background(255);
  textSize(60);
  text(text, 300, height/2 );
  smooth();
  fill(0);
}

void add_ball(int colour)
{
  inventory.append(colour); // Add a new ball
  println("here:", colour);
  println("list:", inventory, ", ", inventory.hasValue(colour));

  xpos = int(random(5, width-5));
  ypos = int(random(5, height-5));
  println("xpos:", xpos, "ypos:", ypos);
  xspeed = random (0.5, 3);
  yspeed = random (0.5, 3);

  posX.append(xpos);
  posY.append(ypos);
  dirX.append(1);
  dirY.append(1);
  speedX.append (xspeed);
  speedY.append (yspeed);
  println("posX[]:", posX, "\nposY[]:", posY);
}

void draw_bounce()
{
  background(255);
  if (inventory.size() != 0 ) {
    println("posX[]:", posX, "\nposY[]:", posY);

    for (int i = 0; i < inventory.size(); i = i+1) {
      println("i:", i);

      if (inventory.get(i) == 1) // Colouring the ball
        fill(247, 75, 89);
      if (inventory.get(i) == 2)
        fill(8, 250, 148);
      if (inventory.get(i) == 3)
        fill(210, 216, 216);
      if (inventory.get(i) == 4)
        fill(30, 225, 245); 
      if (inventory.get(i) == 5)
        fill(236, 250, 45);

      ellipse(posX.get(i), posY.get(i), rad, rad); // Draw the ball

      xpos = posX.get(i) + int( speedX.get(i) * dirX.get(i) ); // Move the ball
      ypos = posY.get(i) + int( speedY.get(i) * dirY.get(i) );

      if (xpos > width-rad || xpos < rad) {
        dirX.set(i, dirX.get(i) * -1);
      }
      if (ypos > height-rad || ypos < rad) {
        dirY.set(i, dirY.get(i) * -1);
      }
      // Draw the shape

      //ellipse(posX.get(i), posY.get(i), rad, rad);

      posX.set(i, xpos);
      posY.set(i, ypos);
    }
  }
}


int read_buttons()
{
  int tempNum = 0;
  if ( myPort.available() > 0)
  {  // If data is available,
    tempNum = myPort.read();
  }
  return tempNum;
}

/*
state = States.BOUNCE;
 bounce_start_ms = millis();
 add_ball(1);
 add_ball(2);
 */

void draw () {
  switch (state)
  {
  case START:
    draw_slide("Hello, please press any button to start");
    if (read_buttons() > 0)
    {
      state = States.FINDPLAYERS;
      findplayers_start_ms = millis();
    }
    break;

  case FINDPLAYERS:
    draw_slide("This is a two player game.\nYou have one minute to find another person\nto start the game.\nPlease press any button when you are both ready.");
    if (read_buttons() > 0)
      state = States.EXPLAIN;
    if (millis() - findplayers_start_ms > 60000)
    {
      state = States.START;
    }
    break;

  case EXPLAIN:
    draw_slide("Both of you will need to rate yourselves from\n1 to 5 based on ‘how gay do you feel today’\nPlease don’t look at each others answers!\nPress any button to continue.");

    if (read_buttons() > 0)
    {
      state = States.PLAYER1;
    }
    break;

  case PLAYER1:
    draw_slide("Player 1:\nHow gay do you feel today?");
    choice = read_buttons();
    if (choice > 0)
    {
      state = States.PLAYER2;
      player1_colour = choice;
    }
    break;

  case PLAYER2:
    draw_slide("Player 2:\nHow gay do you feel today?");
    choice = read_buttons();
    if (choice > 0)
    {
      state = States.GUESS;
      player2_colour = choice;
      //bounce_start_ms = millis();
      add_ball(player1_colour);
      add_ball(player2_colour);
    }
    break;

  case GUESS:
    draw_slide("Great!\nNow time to guess each other’s answers…\nPress any button to continue.");
    //choice = read_buttons();
    if (read_buttons()> 0)
    {
      //player2_colour = choice;
      state = States.GUESS1;
    }
    break;

  case GUESS1:
    draw_slide("Player 1:\nWhich button did Player 2 press?");
    
    choice = read_buttons();
    if (choice != 0)
    {
      if (choice != player2_colour)
      { 
        state = States.WRONG1;
        wrong1_start_ms = millis();
        print("wrong");
      } 

      else
      {   
        state = States.CORRECT1;
        correct1_start_ms = millis();
      }
    }
    break;

  case CORRECT1:
    draw_slide("Correct!");
    
    if (millis() - correct1_start_ms > 1000)
    {
      state = States.GUESS2;
    }
    //delay(5000);
    //state = States.GUESS2;
    break;

  case WRONG1:
    draw_slide("Wrong!");
    
    if (millis() - wrong1_start_ms > 1000)
    {
      state = States.GUESS2;
    }
    //delay(5000);
    //state = States.GUESS2;
    break;

  case GUESS2:
    draw_slide("Player 2:\nWhich button did Player 1 press?");

   choice = read_buttons();
    if (choice != 0)
    {
      if (choice != player1_colour)
      { 
        state = States.WRONG2;  
        wrong2_start_ms = millis();
      } 

      else
      {   
        state = States.CORRECT2;
        correct2_start_ms = millis();
      }
    }
    break;

  case CORRECT2:
    draw_slide("Correct!");
    
    if (millis() - correct2_start_ms > 1000)
    {
      state = States.THANKYOU;
    }
    //delay(5000);
    //state = States.THANKYOU;
    break;

  case WRONG2:
    draw_slide("Wrong!");
    
    if (millis() - wrong2_start_ms > 1000)
    {
      state = States.THANKYOU;
    }
    //delay(5000);
    //state = States.THANKYOU;
    break;

  case THANKYOU:

    draw_slide("Thanks for playing!\nPlease take a minute to scan the QR code below\nto learn more about the project.\nPress any button to see live results of\nhow gay everyone feels today! ");

    if (read_buttons() > 0)
    {
      state = States.BOUNCE;
      bounce_start_ms = millis();
    }
    break;

  case BOUNCE:
    draw_bounce();
    if (millis() - bounce_start_ms > 12000)
      state = States.START;   
    break;
  }
}
