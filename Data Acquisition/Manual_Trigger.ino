//#include <digitalWriteFast.h>

int activate = 0;
int flag=0;
unsigned long h=0;
int TRIGGER = 12;
void setup()
{
 Serial.begin(115200); //-->>Current
}

unsigned long currentMillis_timer1 = 0;
unsigned long previousMillis_timer1 = 0;
//unsigned long interval_timer1 = 1000000; //(microsegundos)  1 segundo
unsigned long interval_timer1 = 1000; //(microsegundos)  1000Hz segundo
//long interval_timer1 = 100000000000000; //(microsegundos)  1 segundo

void loop()
{

  currentMillis_timer1 = micros(); 
  if ((currentMillis_timer1 - previousMillis_timer1)>=interval_timer1)
  {
    previousMillis_timer1 = currentMillis_timer1;
 
    //if (flag==0){
    
    //Serial.print(h);
    //Serial.print(" ");
    //Serial.println("0");
    h++;
    //}
    //else
    //Serial.print("1");
    //flag=0;
    }


    //while (activate!=32){ //Use space for (re)activation
    activate = Serial.read();// read command char
    if (activate==32)
    {
      Serial.println("1");
      digitalWrite (TRIGGER, HIGH);
      delay(20);
    } 

    digitalWrite (TRIGGER, LOW);

    //if (h>=1000){
    //  h=0;
    //}

}
//...........................................................................
//...........................................................................
