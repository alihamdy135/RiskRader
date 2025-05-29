#include <Firebase.h>
#include <FirebaseArduino.h>
#include <FirebaseCloudMessaging.h>
#include <FirebaseError.h>
#include <FirebaseHttpClient.h>
#include <FirebaseObject.h>

#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>
#include <DHT.h>

#define WIFI_SSID "realme 9i"
#define WIFI_PASSWORD "123456789"
#define FIREBASE_HOST "project1112-b8396-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "bSYyWM0hkWTrqD3OyxLKy9fB2ddnAugHglYuuz3j"

// Sensor Pins
#define MQ7_SELECT_PIN D7  // Digital pin to select MQ-7
#define MQ135_SELECT_PIN D6 // Digital pin to select MQ-135
#define RAIN_SELECT_PIN D5  // Digital pin to select rain sensor
#define ANALOG_PIN A0      // Shared analog input

// DHT11 Sensor
#define DHTPIN D3
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

// Buzzer Pins
#define BUZZER1 D0
#define BUZZER2 D1
#define BUZZER3 D2

void setup() {
  Serial.begin(115200);
  delay(2000);
  
  // Initialize pins

  pinMode(BUZZER1, OUTPUT);
  pinMode(BUZZER2, OUTPUT);
  pinMode(BUZZER3, OUTPUT);
  pinMode(MQ7_SELECT_PIN, OUTPUT);
  pinMode(MQ135_SELECT_PIN, OUTPUT);
  pinMode(RAIN_SELECT_PIN, OUTPUT);
  
  // Initialize DHT sensor
  dht.begin();
  
  // Start WiFi connection
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);    
  Serial.print("Connecting to ");
  Serial.print(WIFI_SSID);
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }

  Serial.println();
  Serial.print("Connected to ");
  Serial.println(WIFI_SSID);
  Serial.print("IP Address is : ");
  Serial.println(WiFi.localIP());
  
  // Connect to Firebase
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}

// Function to read selected analog sensor
int readSelectedSensor(int sensorSelectPin, int otherSelectPin1, int otherSelectPin2) {
  // Activate the selected sensor
  digitalWrite(sensorSelectPin, HIGH);
  digitalWrite(otherSelectPin1, LOW);
  digitalWrite(otherSelectPin2, LOW);
  
  delay(100); // Allow settling time
  return analogRead(ANALOG_PIN);
}

void loop() {
  // Initialize chart data in Firebase
  for(int i = 0; i < 20; i++) {
    String chartMQ7 = "/Serial/Chart/MQ7_" + String(i);
    String chartMQ135 = "/Serial/Chart/MQ135_" + String(i);
    String chartRain = "/Serial/Chart/Rain_" + String(i);
    String chartTemp = "/Serial/Chart/Temp_" + String(i);
    String chartHumidity = "/Serial/Chart/Humidity_" + String(i);
    
    Firebase.setInt(chartMQ7, 0);
    Firebase.setInt(chartMQ135, 0);
    Firebase.setInt(chartRain, 0);
    Firebase.setInt(chartTemp, 0);
    Firebase.setInt(chartHumidity, 0);
  }

  for(int i = 0; i < 20; i++) {
    // Read MQ-7 sensor
    int mq7Value = readSelectedSensor(MQ7_SELECT_PIN, MQ135_SELECT_PIN, RAIN_SELECT_PIN);
    // Convert to PPM (example conversion - adjust based on your sensor)
    float mq7PPM = map(mq7Value, 0, 1023, 0, 1000) / 100.0;
    
    // Read MQ-135 sensor
    int mq135Value = readSelectedSensor(MQ135_SELECT_PIN, MQ7_SELECT_PIN, RAIN_SELECT_PIN);
    // Convert to PPM (example conversion - adjust based on your sensor)
    float mq135PPM = map(mq135Value, 0, 1023, 0, 500) / 100.0;
    
    // Read rain sensor
    int rainValue = readSelectedSensor(RAIN_SELECT_PIN, MQ7_SELECT_PIN, MQ135_SELECT_PIN);
    // Convert to percentage (0-100%)
    int rainPercentage = map(rainValue, 0, 1023, 0, 100);
    
    // Read DHT11 sensor
    float temperature = dht.readTemperature();
    float humidity = dht.readHumidity();
    
    // Print values to serial monitor
    Serial.print("MQ-7: "); Serial.print(mq7PPM); Serial.println(" ppm");
    Serial.print("MQ-135: "); Serial.print(mq135PPM); Serial.println(" ppm");
    Serial.print("Rain: "); Serial.print(rainPercentage); Serial.println("%");
    Serial.print("Temperature: "); Serial.print(temperature); Serial.println("°C");
    Serial.print("Humidity: "); Serial.print(humidity); Serial.println("%");
    
    // Send real-time data to Firebase
    Firebase.setFloat("/Serial/real/MQ7", mq7PPM);
    Firebase.setFloat("/Serial/real/MQ135", mq135PPM);
    Firebase.setInt("/Serial/real/Rain", rainPercentage);
    Firebase.setFloat("/Serial/real/Temperature", temperature);
    Firebase.setFloat("/Serial/real/Humidity", humidity);
    
    // Push historical data to Firebase
    Firebase.pushFloat("/Serial/History/MQ7", mq7PPM);
    Firebase.pushFloat("/Serial/History/MQ135", mq135PPM);
    Firebase.pushInt("/Serial/History/Rain", rainPercentage);
    Firebase.pushFloat("/Serial/History/Temperature", temperature);
    Firebase.pushFloat("/Serial/History/Humidity", humidity);
    
    // Update chart data
    String chartMQ7 = "/Serial/Chart/MQ7_" + String(i);
    String chartMQ135 = "/Serial/Chart/MQ135_" + String(i);
    String chartRain = "/Serial/Chart/Rain_" + String(i);
    String chartTemp = "/Serial/Chart/Temp_" + String(i);
    String chartHumidity = "/Serial/Chart/Humidity_" + String(i);
    
    Firebase.setFloat(chartMQ7, mq7PPM);
    Firebase.setFloat(chartMQ135, mq135PPM);
    Firebase.setInt(chartRain, rainPercentage);
    Firebase.setFloat(chartTemp, temperature);
    Firebase.setFloat(chartHumidity, humidity);
    
    // Check conditions and activate buzzers
    if (mq7PPM > 50) {  // High CO level
      digitalWrite(BUZZER1, HIGH);
      delay(500);
      digitalWrite(BUZZER1, LOW);
    }
    
    if (mq135PPM > 30) {  // High air pollution
      digitalWrite(BUZZER2, HIGH);
      delay(500);
      digitalWrite(BUZZER2, LOW);
    }
    
    if (rainPercentage > 70) {  // Heavy rain
      digitalWrite(BUZZER3, HIGH);
      delay(500);
      digitalWrite(BUZZER3, LOW);
    }

    digitalWrite(BUZZER3, HIGH);
      delay(500);
      digitalWrite(BUZZER3, LOW);
      
     digitalWrite(BUZZER1, HIGH);
      delay(500);
      digitalWrite(BUZZER1, LOW);
    
  }
}