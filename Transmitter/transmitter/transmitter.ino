void setup()
{
  Serial.begin(4800);
}
void loop()
{
    int out = 5;
    Serial.print(out);
    delay(10);

}
