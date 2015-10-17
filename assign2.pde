//You should implement your assign2 here.
PImage Ibg1,Ibg2,Ienemy,Ifighter,Ihp,Itreasure,Istart1,Istart2,Iend1,Iend2,Ienemy1,Ibomb;
int bgx,hp,fx,fy,tx,ty,bx,by,state,score,hiscore,cf;
float ex,ey,evx,evy;
boolean fl,fr,fu,fd,fm,fb;

void setup () {
  size(640, 480) ;
  Ibg1=loadImage("img/bg1.png");
  Ibg2=loadImage("img/bg2.png");
  Ienemy=loadImage("img/enemy.png");
  Ifighter=loadImage("img/fighter.png");
  Ihp=loadImage("img/hp.png");
  Itreasure=loadImage("img/treasure.png");
  Istart1=loadImage("img/start1.png");
  Istart2=loadImage("img/start2.png");
  Iend1=loadImage("img/end1.png");
  Iend2=loadImage("img/end2.png");
  Ienemy1=loadImage("img/Moocs-element-enemy1.png");
  Ibomb=loadImage("img/Moocs-element-gainbomb.png");
  
  init();
  
  fl=false;
  fr=false;
  fu=false;
  fd=false;
  fm=false;
  fb=false;
  state=0;
  hiscore=0;
  textSize(24);
}

void init(){
  score=0;
  bgx=0;
  hp=40;
  fx=550;
  fy=240;
  ex=-61;
  ey=240;
  evx=1;
  evy=0;
  tx=(int)random(0,600);
  ty=(int)random(0,440);
}
void newenemy(){
  cf=-1;
  ex=-61;
  ey=(int)random(0,420);
  float dx=fx-ex,dy=fy-ey;
  evx=dx/sqrt(dx*dx+dy*dy);
  evy=dy/sqrt(dx*dx+dy*dy);
}

void draw() {
  // your code
  switch(state){
  case 0:
    if(fm)image(Istart1,0,0);
    else image(Istart2,0,0);
    break;
  case 1:
    if(hp<=0){
      state=2;
      hiscore=max(hiscore,score);
      return;
    }
    
    //bg
    bgx++;
    if(bgx>=640){
      bgx=0;
      PImage tmp=Ibg1;
      Ibg1=Ibg2;
      Ibg2=tmp;
    }
    image(Ibg1,bgx,0);
    image(Ibg2,bgx-640,0);
    
    //bullet
    fill(255,255,0);
    bx-=15;
    if(bx<0)fb=false;
    if(fb)rect(bx,by-1,10,3);
    
    //enemy
    float spd=(ex+62)/30;
    if(spd<4)spd=4;
    ex+=spd*evx;
    ey+=spd*evy;
    if(ex>=640||ey>=480||ey<=-61){
      newenemy();
    }
    if(cf<0){
      if(fb&&bx-ex>=0&&bx-ex<=61&&by-ey>=0&&by-ey<=61){
        fb=false;
        score+=100;
        cf=5;
      }
      if(fx-ex<=61&&fy-ey<=61&&ex-fx<=51&&ey-fy<=51){
        hp-=40;
        if(hp<0)hp=0;
        cf=5;
      }
      image(Ienemy,ex,ey);
    }
    else{
      cf--;
      image(Ienemy1,ex,ey);
      if(cf<0)newenemy();
    }
    
    
    //treasure
    if(fx-tx<=41&&fy-ty<=41&&tx-fx<=51&&ty-fy<=51){
      hp+=20;
      score+=50;
      if(hp>200)hp=200;
      tx=(int)random(0,600);
      ty=(int)random(0,440);
    }
    image(Itreasure,tx,ty);
    
    //fighter
    if(fl)fx-=6;
    if(fr)fx+=6;
    if(fu)fy-=6;
    if(fd)fy+=6;
    if(fx<0)fx=0;
    if(fx>590)fx=590;
    if(fy<0)fy=0;
    if(fy>430)fy=430;
    image(Ifighter,fx,fy);
    
    //hp
    fill(255,0,0);
    rect(15,11,hp,20);
    image(Ihp,10,10);
    
    //score
    text("score:"+score,440,35);
    break;
  case 2:
    if(fm)image(Iend1,0,0);
    else image(Iend2,0,0);
    text("hi-score:"+hiscore,205,300);
    break;
  }
}
void keyPressed(){
  if(key==CODED){
    switch(keyCode){
    case UP:
      fu=true;
      fd=false;
      break;
    case DOWN:
      fd=true;
      fu=false;
      break;
    case LEFT:
      fl=true;
      fr=false;
      break;
    case RIGHT:
      fr=true;
      fl=false;
      break;
    }
  }
  else{
    if(state!=1){
      if(fm){
        state=1;
        fm=false;
        init();
        return;
      }
      else{
        fm=true;
      }
    }
    else if(!fb){
      fb=true;
      bx=fx-1;
      by=fy+25;
    }
  }
}
void keyReleased(){
  if(key==CODED){
    if(keyCode==UP)fu=false;
    if(keyCode==DOWN)fd=false;
    if(keyCode==LEFT)fl=false;
    if(keyCode==RIGHT)fr=false;
  }
}

void mouseMoved(){
  switch(state){
  case 0:
    if(mouseX>=207&&mouseX<=452&&mouseY>=378&&mouseY<=411)fm=true;
    else fm=false;
    break;
  case 2:
    if(mouseX>=210&&mouseX<=434&&mouseY>=312&&mouseY<=346)fm=true;
    else fm=false;
    break;
  }
}
void mouseClicked(){
  switch(state){
  case 0:
    if(mouseX>=207&&mouseX<=452&&mouseY>=378&&mouseY<=411)fm=true;
    else fm=false;
    break;
  case 2:
    if(mouseX>=210&&mouseX<=434&&mouseY>=312&&mouseY<=346)fm=true;
    else fm=false;
    break;
  }
  switch(state){
  case 0:
  case 2:
    if(fm)state=1;
    fm=false;
    init();
    return;
  default:
    return;
  }
}
