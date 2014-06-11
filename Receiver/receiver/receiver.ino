int inc;
void setup()
{
  Serial.begin(4800);
}
void loop()
{
  
 if(Serial.available()>0){
   inc = Serial.read();
   if(inc!=0)
  Serial.println(inc);
 }
 
}
