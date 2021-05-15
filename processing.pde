import processing.serial.*;
Serial bt;
String state1="null";
int steps1=0, startsteps=0, endsteps=0;
int steps2=0;
import processing.sound.*;
long t=0;
String ldr="OFF";
PImage startimg, bgimg, rocks, bird, can, bottles, end, startscreen;
PImage[] man= new PImage[24];
int x=0, obj1=550, obj2=550, obj3=550, obj4=550, start, ctr=0, trash1=0, trash2=0, score=0;

import processing.sound.*;
SoundFile file;
SoundFile file1, file2, file3, file4, file5, file6;
String bgmusic = "runmusic.mp3";
String jumpsound = "jumpsound2.mp3";
String errsound = "buzzsound.mp3";
String plussound = "alert.mp3";
String path;

void setup() 
{
  
  path = sketchPath(bgmusic);
  file = new SoundFile(this, path);
  file.play();
  
  size(550, 400);
  
  println("Available serial ports:");
  println((Object[])Serial.list());
  bt = new Serial(this, Serial.list()[1], 9600);
  bt.bufferUntil('\n');
 
  startscreen= loadImage("Capture2.png");
  bgimg = loadImage("newbg.jpg");
  rocks = loadImage("rocks.png");
  bird = loadImage("bird.gif");
  can= loadImage("can.png");
  bottles= loadImage("bottles.png");
  end= loadImage("gameover.jpg");
  
 
  man[0] = loadImage("0.gif");  
  man[1] = loadImage("1.gif");
  man[2] = loadImage("2.gif");
  man[3] = loadImage("3.gif");
  man[4] = loadImage("4.gif");
  man[5] = loadImage("5.gif");
  man[6] = loadImage("6.gif");
  man[7] = loadImage("7.gif");
  man[8] = loadImage("8.gif");
  man[9] = loadImage("9.gif");
  man[11] = loadImage("10.gif");
  man[12] = loadImage("12.gif");
  man[13] = loadImage("13.gif");
  man[14] = loadImage("14.gif");
  man[15] = loadImage("15.gif");
  man[16] = loadImage("16.gif");
  man[17] = loadImage("17.gif");
  man[18] = loadImage("18.gif");
  man[19] = loadImage("19.gif");
  man[20] = loadImage("20.gif");
  man[21] = loadImage("21.gif");
  man[22] = loadImage("22.gif");
  man[23] = loadImage("23.gif");
  
  frameRate(35);
  start=millis();
  
}

void obstacle1()
{
  image(rocks, obj1, 300, 80, 40);
  obj1-=3; 
}

void obstacle2()
{
  image(bird, obj2, 150, 100, 70);
  obj2-=4; 
}

void obstacle3()
{
  image(can, obj3, 300, 80, 60);
  obj3-=3; 
}

void obstacle4()
{
  image(bottles, obj4, 280, 100, 80);
  obj4-=3; 
}

void jump()
{
   image(man[frameCount%10], 50, 120, 110, 180);
   path = sketchPath(jumpsound);
   file1 = new SoundFile(this, path)  ;
   if(ctr==0)     
   {
     file1.play();
     if(50<obj1 && obj1<200)
     {
         score+=5;
     }
   }
      ctr++;   
}
void duck()
{
  image(man[frameCount%10], 50, 200, 110, 180);
  path = sketchPath(jumpsound);
  file2 = new SoundFile(this, path);
  if(ctr==0)
  {
    file2.play();
    if(55<obj2 && obj2<170)
     {
         score+=5;
     }
  }
  ctr++;
}

int flag=0, flag2=0;
float time;

void draw() 
{
  //state="run";
  fill(255);
  
  if(flag==0)
  {
    background(0); 
    image(startscreen, 0, 0, 550, 400);
    flag=key;
    start=millis();
  }
  else
  {
    image(bgimg, (x%-550), 0);
    image(bgimg, 550+(x%-550), 0);
    x-=3; 
    
    int timer = millis()-start;
    
    textSize(20);
    text("Time", 20, 30);
    text(float(timer)/1000, 10, 60);
    
    text("Player1", 20, 380);
    text("Score", 450, 30);
    textSize(16);
    text("Player1:", 420, 60);
    text(score+steps1, 500, 60);
   
   
       if(state1.equals("JUMP"))
       {
         key='j';
       }
       else if(state1.equals("DUCK"))
       {
         key='d';
       }
       else if(ldr.equals("ON"))
       {
         key='b';
       }
      
    if(key=='j' || key=='d' || key=='b')
    {
      if(key=='j')
      {
        jump();  
      }
      else if(key=='d')
      {
        duck();  
      }
      else if(key=='b')
      {  
        image(man[frameCount%10], 50, 160, 110, 180);
        if(55<obj3 && obj3<150)
        {
          obj3=-1000;
          score+=5;
          path = sketchPath(plussound);
          file4 = new SoundFile(this, path);
          file4.play();
        }
        else if(55<obj4 && obj4<170)
        { 
          obj4=-1000;
          score+=5;
          path = sketchPath(plussound);
          file5 = new SoundFile(this, path);
          file5.play();
        }
        else
        {
          path = sketchPath(errsound);
          file6 = new SoundFile(this, path);
          file6.play();
        }
        key='q';
      } 
    state1="RUN";
    }
    else
    {
      image(man[frameCount%10], 50, 160, 110, 180);
    }
    
    if(ctr>40)
    {
      key='q';
      ctr=0;
    }
    if(timer>=15000)
    {
      obstacle1();
    }
    if(timer>=30000)
    {
      obstacle2();
    }
    if(timer>=40000)
    {
      obstacle3();
    }
    if(timer>=50000)
    {
    obstacle4();
    }
    
    if(timer>60000.00)
    {
        image(end, 0, 0, 550, 400);
        text("Score:", 200, 350);
          
         // endscore=score;
        text(score+steps1, 300, 350);
        //text("Player2:", 300, 350);
        text("Keep it Green, Keep it Clean!", 170, 30);
        text("Save the Earth", 220, 50);
        if(key=='e')
        {
          exit();
        }
    }
  }
}
void serialEvent(Serial bt)
{
  String inString = bt.readStringUntil('\n');
  if(inString !=null)
  inString=trim(inString);
  
  if(inString.equals("RUN"))
  state1="RUN";
  
  else if(inString.equals("DUCK"))
  state1="DUCK";
    
  else if(inString.equals("JUMP"))
    state1="JUMP";
  
  else if(inString.equals("ON")) 
  {  
    ldr=inString;
  }
  else if(inString.equals("OFF"))
  {  
  }
  else
    steps1=int(inString);
}
