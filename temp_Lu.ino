void setup()
{
  Serial.begin(9600);
  pinMode(5, INPUT);
  pinMode(4,INPUT);
  pinMode(3,INPUT);
  pinMode(2,INPUT);
  pinMode(6,INPUT);
  
}
void loop()
{
  int switchStatus1 = digitalRead(6);
  int switchStatus2 = digitalRead(2);
  int switchStatus3 = digitalRead(3);
  int switchStatus4 = digitalRead(4);
  int switchStatus5 = digitalRead(5);
  if (switchStatus1 == HIGH) {
  Serial.write(1);
  //  Serial.print(1);
    delay(300);
  } else {
  if (switchStatus2 == HIGH) {
  Serial.write(2);
 // Serial.print(2);   
    delay(300);
  } else {
  if (switchStatus3 == HIGH) {
   Serial.write(3);
  //  Serial.print(3);  
    delay(300);
  }
 if (switchStatus4 == HIGH) {
   Serial.write(4);
  //  Serial.print(4);  
    delay(300);
  }
   if (switchStatus5 == HIGH) {
   Serial.write(5);
  //  Serial.print(5);  
    delay(300);
  }
}
}
}
