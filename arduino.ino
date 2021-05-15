#include <Wire.h>
// defines pins numbers
const int trigPin1 = 9;
const int echoPin1 = 10;

long duration;
int distance,sumD1=500,avgD1,D1[10],std1=30,checkJ1=0,checkD1=0;
String state1="RUN";

String ldr="OFF";
int ldrv[10],ldrS=0,ldravg=0,ldrstd=0;

const int MPU = 0x68; // MPU6050 I2C address
float AccX;
int i=0,start=0;
long long t=0;
float arrX1[10],sumX1=0,avgX1=0;
int up1=0,down1=0,steps1=0;

void ldrCheck(){
  if(ldravg<ldrstd-70)
    ldr="ON";
}
void ldrRead(){
  ldrS=0;
  ldrv[t%10]=analogRead(A0);
  for(i=0;i<10;i++){
    ldrS=ldrS+ldrv[i];
  }
  ldravg=ldrS/10;
    
}



void readD(int t,int e){  
  // Clears the trigPin1
  digitalWrite(t, LOW);
  delayMicroseconds(2);
  // Sets the trigPin on HIGH state for 10 micro seconds
  digitalWrite(t, HIGH);
  delayMicroseconds(10);
  digitalWrite(t, LOW);
  // Reads the echoPin, returns the sound wave travel time in microseconds
  duration = pulseIn(e, HIGH);
  // Calculating the distance
  distance= duration*0.034/2;
}


void readAcc(){
    // === Read acceleromter data === //
  Wire.beginTransmission(MPU);
  Wire.write(0x3B); // Start with register 0x3B (ACCEL_XOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(MPU, 6, true); // Read 6 registers total, each axis value is stored in 2 registers
  //For a range of +-2g, we need to divide the raw values by 16384, according to the datasheet
  
  AccX = (Wire.read() << 8 | Wire.read()) / 16384.0; // X-axis value
  //Zero Error(self written)
  AccX = AccX + 0.90;  
  
}

void c1(){
  arrX1[t%10]=AccX;
  if(t%10==0){
    sumX1=0;
    for(i=0;i<10;i++)
      sumX1=sumX1+arrX1[i];
    avgX1=(sumX1/10);
    //for debugging
    //Serial.println(avgX1);
    if(avgX1>0.4){
      if(up1==0 | up1==1){
        up1++;
      }  
    }
    else if(avgX1<-0.4 && up1==2){
      if(down1==0){
        down1++;
      }
      else if(down1==1){
         steps1++;
         up1=0;
          down1=0;
         //Serial.println("");
         //Serial.print("Steps : ");
         
         //Serial.println("");

      }
    }
  }        
}



void setup() {

  pinMode(A0, INPUT);
  pinMode(trigPin1, OUTPUT); // Sets the trigPin as an Output
  pinMode(echoPin1, INPUT); // Sets the echoPin as an Input
  
  pinMode(12, OUTPUT);
  digitalWrite(12,HIGH);
    
  Serial.begin(9600);
  Wire.begin();                      // Initialize comunication
  Wire.beginTransmission(MPU);       // Start communication with MPU6050 // MPU=0x68
  Wire.write(0x6B);                  // Talk to the register 6B
  Wire.write(0x00);                  // Make reset - place a 0 into the 6B register
  Wire.endTransmission(true);        //end the transmission
  delay(20);
  //Serial.println("START");
  //Serial.print("Steps : ");
  Serial.println("STAND STILL");
  //Serial.println("");


}

void loop() {

  if(t==500)
  {
    std1=avgD1;
    start=1;
    ldrstd=ldravg;
    Serial.print("START\n");
  }
  ldrRead();
  ldrCheck();

  readD(trigPin1,echoPin1);
  D1[t%10]=distance;
  sumD1=0;
  for(i=0;i<10;i++)
  {
    sumD1=sumD1+D1[i];
  }
  avgD1=(sumD1/10);
  if(start==1){  
    if(avgD1<std1-10 and checkJ1==0)
      checkJ1=1;
    if(avgD1>std1-10 and checkJ1==1){
      state1="JUMP";
      checkJ1=0;
    }
    if(avgD1>std1+20 and checkD1==0) 
      checkD1=1;
    if(avgD1<std1+20 and checkD1==1){
      state1="DUCK";
      checkD1=0;
    }
  }
  
  readAcc();
  c1();
  
  
  if(start==1){
    if(t%30==0){
      //Serial.println(t);
      Serial.println(steps1);
      Serial.println(state1);
      Serial.println(ldr);
      //Serial.println(ldravg);
      //Serial.print(state2);
      //Serial.print("  ");
      //Serial.println(steps2);
      state1="RUN";
      ldr="OFF";
    }
  }
  t=t+1;
}
