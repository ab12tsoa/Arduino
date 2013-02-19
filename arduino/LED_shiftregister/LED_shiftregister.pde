
//String[] sq = {"00", "80", "D0", "60", "30", "A8", "DD", "66", "33", "1A", "0D", "06", "03", "01", "00" }
//Arduino arduino;

#define  PIN_SER  2
#define  PIN_RCLK  3
#define  PIN_SERCLK  4

void setup(){
  
  pinMode(PIN_SER, OUTPUT);
  pinMode(PIN_RCLK, OUTPUT);
  pinMode(PIN_SERCLK, OUTPUT);
  digitalWrite(PIN_SER, LOW);
  digitalWrite(PIN_RCLK, LOW);
  digitalWrite(PIN_SERCLK, LOW);
  
}

//toggleRCLK to shift bits from shift register to output
//we delay in between to meet the minimum settling time
//delay before and after to meet minimum hold time for SERCLK
void toggleRCLK(){ 
  
  delayMicroseconds(1);
  digitalWrite(PIN_RCLK, HIGH);
  delayMicroseconds(1);
  digitalWrite(PIN_RCLK, LOW);
  delayMicroseconds(1);
  
}

//shiftBit
//char is 8 bits - but we only use the first bit (bit 0)
void shiftBit(char data){
  //delay
   delayMicroseconds(1);
  //write to SER = data
  //check bit 0 by ANDing it with hex 00000001
  if (data & 0x01){
     digitalWrite(PIN_SER, LOW);  //pin low allows current flow, LED on 
  }  else {
     digitalWrite(PIN_SER, HIGH); //pin high blocks current flow, LED off
  }
  //delay
   delayMicroseconds(1);
  //write to SERCLK = High - shifts entire register right, so bit 1 is now bit 0
  //so SERCLK High means QA (first pin on shift register) gets set to 1
  //then QA set to 0 and QB set to 1 - this is the cascading shift
   digitalWrite(PIN_SERCLK, HIGH);
  //delay
   delayMicroseconds(1);
  //SERCLK Low
   digitalWrite(PIN_SERCLK, LOW);
  //delay (so SERCLK is ready to record again on its upleg)
   delayMicroseconds(1);
  //only toggle rclk when we've written all the bits
  
}

void writeByte(char data){ 
  for(int i = 0; i < 8; i++){
    shiftBit(data & 0x01); //only shifts bit 0 of data
    data = data >> 1; //shifts active bit to the right 1 
    //by writing an extra 0 to the end of the char (bit 7 = 128)
  }
  
}

void loop() {
  
  for(int i = 0; i < 8; i++){
    writeByte(1 << i);
    toggleRCLK();
    delay(100);
  }
   for(int i = 6; i >0; i--){ //starting at 7 means the bit at 7 gets called twice (567765)
    writeByte(1 << i);
    toggleRCLK();
    delay(100);
  }
  
//  Animate(sq);
  
//  shifty eyes!
//  writeByte(0xaa); //striped 1010
//  toggleRCLK();
//  delay(1000);
//  writeByte(0x55); //striped 0101
//  toggleRCLK();
//  delay(1000);

}


