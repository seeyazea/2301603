#define TRIG_PIN 7
#define ECHO_PIN 8
#define ANG_PIN 9
#define BUZ_PIN 5
void setup() {
Serial.begin(9600);
pinMode(TRIG_PIN, OUTPUT);
pinMode(ECHO_PIN, INPUT);
pinMode(BUZ_PIN, OUTPUT);
}
void loop()
{
int distance = 0, duration, led_light;
digitalWrite(TRIG_PIN, HIGH);
delayMicroseconds(10);
digitalWrite(TRIG_PIN, LOW);
duration = pulseIn(ECHO_PIN, HIGH);
distance = duration/58; /* 센치미터(cm) */
if(distance > 5 && distance <30){
led_light = 10*(30-distance);
analogWrite(ANG_PIN, led_light);
Serial.println(led_light);
tone(BUZ_PIN,500,distance);
delay(100);
delay(distance);
}
else{
analogWrite(ANG_PIN, 0);
}
}