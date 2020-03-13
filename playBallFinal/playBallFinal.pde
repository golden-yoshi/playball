import de.voidplus.leapmotion.*;
import arb.soundcipher.*;
LeapMotion leap;
SoundCipher sc;
ArrayList<Circle> cyc = new ArrayList<Circle>();
float[] instruments = {sc.TIMPANI,sc.CRYSTAL,sc.SHAMISEN,
sc.PIANO,sc.TAIKO,sc.WOODBLOCKS};
String[] instruName = {"TIMPANI","CRYSTAL","SHAMISEN",
"PIANO","TAIKO","WOODBLOCKS"};
PImage bg;

float xOffset = 0; 
float yOffset = 0;

void setup(){
  size(1200,800);
  textAlign(CENTER,CENTER);
  leap = new LeapMotion(this);
  sc = new SoundCipher(this);
  bg = loadImage("sky-4.jpg");
  for(int i=0; i<6; i++){
    cyc.add(new Circle(i));
  }
}

void draw(){
  background(bg);
  text("Click buttons to add balls for different instruments",150,40 );
  text("Mouse left click to drag balls",150,60 );
  text("Right click to delete balls",150,80 );
  
  for(int i=0; i<cyc.size(); i++){
    if(cyc.get(i).removeIt()==true){
      cyc.remove(i);
    }else{
      cyc.get(i).update();
      cyc.get(i).checkFinger();
      cyc.get(i).show();
    }
  }
  
  fill(50,255,180);
  PVector f = new PVector(0,0);
    for(Hand hand : leap.getHands()){
      f = hand.getThumb().getPosition();
      ellipse(f.x,f.y,30,30);
      f = hand.getIndexFinger().getPosition();
      ellipse(f.x,f.y,30,30);
      f = hand.getMiddleFinger().getPosition();
      ellipse(f.x,f.y,30,30);
      f = hand.getRingFinger().getPosition();
      ellipse(f.x,f.y,30,30);
      f = hand.getPinkyFinger().getPosition();
      ellipse(f.x,f.y,30,30);
    } 
    
    for(int i=0; i<6; i++){
      fill(125,50);
      rect(width*0.065+width*0.15*i,height*0.9,width*0.12,height*0.06,8);
      if(mouseX>width*0.065+width*0.15*i & mouseX < width*0.185+width*0.15*i & mouseY>height*0.85 & mouseY< height){
        fill(15,165,230,80);
        rect(width*0.065+width*0.15*i,height*0.9,width*0.12,height*0.06,8);
      }
      
      fill(200);
      textSize(12);
      text(instruName[i],width*0.125+width*0.15*i,height*0.93);
    }
}

void mousePressed(){
  for(int i=0; i<6; i++){
      if(mouseX>width*0.065+width*0.15*i & mouseX < width*0.185+width*0.15*i & mouseY>height*0.85 & mouseY< height){
        cyc.add(new Circle(i));
      }
  }
}

class Circle{
  float x,y;
  float d = 60;
  color c = color(random(120,255),random(120,255),random(120,255));
  float type;
  String name;
  long lastTime;
  
  Circle(int id){
    x = width*0.1+0.15*id*width;
    y = random(0.1,0.8)*height;
    type = instruments[id];
    name = instruName[id];
  }
  
  void update(){
    if(mousePressed & mouseButton == LEFT & dist(mouseX,mouseY,x,y)<d/2){
      x += (mouseX-pmouseX);
      y += (mouseY-pmouseY);
    }
  }
  
  boolean removeIt(){
    if(mousePressed & mouseButton == RIGHT & dist(mouseX,mouseY,x,y)<d/2){
      return true;
    }else{
      return false;
    }
  }
  
  void checkFinger(){
    PVector f = new PVector(0,0);
    for(Hand hand : leap.getHands()){
      f = hand.getThumb().getPosition();
      checkCross(f);
      f = hand.getIndexFinger().getPosition();
      checkCross(f);
      f = hand.getMiddleFinger().getPosition();
      checkCross(f);
      f = hand.getRingFinger().getPosition();
      checkCross(f);
      f = hand.getPinkyFinger().getPosition();
      checkCross(f);
    } 
    
    
  }
  
  void checkCross(PVector p){
    if(dist(p.x,p.y,x,y)<d/2 & millis()-lastTime>500){
      c = color(random(100,255),random(100,255),random(100,255));
      sc.instrument(type);
      float note = map(y,0,height*0.8,90,60);
      sc.playNote(note,50,1000);
      lastTime=millis();
    }
  }
  
  void show(){
    noStroke();
    fill(c);
    if(millis()-lastTime<1000){
      ellipse(x,y,d*1.5,d*1.5);
      fill(0,200);
      textSize(d/5);
      text(name,x,y);
    }else{
      ellipse(x,y,d,d);
      fill(0,200);
      textSize(d/8);
      text(name,x,y);
    }
    
  }
}

//Code takes reference from the following sources:
//REFERENCE LIST:
//Processing, n.d., ArrayListClass \ Examples \ Processing.org, viewed 23 October 2017, <https://processing.org/examples/arraylistclass.html>.
//Processing, n.d., Buttons \ Examples \ Processing.org, viewed 24 September 2017, <https://processing.org/examples/button.html>. 
//Processing, n.d., Handles \ Examples \ Processing.org, viewed 27 September 2017, <https://processing.org/examples/handles.html>.
//The processing website was used to source code on how to make interactive buttons and moveable shapes by mouse dragging
//All audio for the project was sourced from the SoundCipher library, downloaded from:
//SoundCipher - Music and Sound for Processing, viewed 23 October 2017, <http://explodingart.com/soundcipher/>.