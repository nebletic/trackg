#include <WiFi.h>
#include <TinyGPS++.h>
#include <Wire.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <ESPAsyncWebServer.h>
#include <AsyncTCP.h>
#include <ArduinoJson.h>

// GPS setup
TinyGPSPlus gps;
HardwareSerial GPS_Serial(1); // Use UART1 for GPS

// IMU setup
Adafruit_MPU6050 mpu;

// Wi-Fi Access Point settings
const char *ssid = "TrackG_DEV";
const char *password = "12345678";

// Web server and WebSocket setup
AsyncWebServer server(80);
AsyncWebSocket ws("/ws");

// Telemetry data variables
float latitude = 0.0, longitude = 0.0, speed_kmh = 0.0;
float g_force_x = 0.0, g_force_y = 0.0, g_force_z = 0.0;
float pitch = 0.0, roll = 0.0;

// Function to setup GPS module
void setupGPS() {
  GPS_Serial.begin(9600, SERIAL_8N1, 16, 17); // RX=16, TX=17
}

// Function to setup IMU module
void setupIMU() {
  if (!mpu.begin()) {
    Serial.println("Failed to find MPU6050 chip");
    while (1) {
      delay(10);
    }
  }
  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);
}

// Function to process GPS data
void processGPS() {
  while (GPS_Serial.available() > 0) {
    if (gps.encode(GPS_Serial.read())) {
      if (gps.location.isUpdated()) {
        latitude = gps.location.lat();
        longitude = gps.location.lng();
        speed_kmh = gps.speed.kmph();
      }
    }
  }
}

// Function to process IMU data
void processIMU() {
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  g_force_x = a.acceleration.x;
  g_force_y = a.acceleration.y;
  g_force_z = a.acceleration.z;
  pitch = atan2(g_force_y, sqrt(g_force_x * g_force_x + g_force_z * g_force_z)) * 180 / PI;
  roll = atan2(-g_force_x, g_force_z) * 180 / PI;
}

// Function to generate telemetry JSON data
String getTelemetryJSON() {
  DynamicJsonDocument doc(256);

  doc["latitude"] = latitude;
  doc["longitude"] = longitude;
  doc["speed_kmh"] = speed_kmh;
  doc["g_force_x"] = g_force_x;
  doc["g_force_y"] = g_force_y;
  doc["g_force_z"] = g_force_z;
  doc["pitch"] = pitch;
  doc["roll"] = roll;

  String json;
  serializeJson(doc, json);
  return json;
}

// WebSocket message handler
void onWsEvent(AsyncWebSocket *server, AsyncWebSocketClient *client, AwsEventType type,
               void *arg, uint8_t *data, size_t len) {
  if (type == WS_EVT_CONNECT) {
    Serial.printf("WebSocket client #%u connected\n", client->id());
  } else if (type == WS_EVT_DISCONNECT) {
    Serial.printf("WebSocket client #%u disconnected\n", client->id());
  }
}

void setup() {
  Serial.begin(115200);

  // Initialize GPS and IMU
  setupGPS();
  setupIMU();

  // Start Wi-Fi hotspot
  WiFi.softAP(ssid, password);
  Serial.println("Wi-Fi hotspot started.");
  Serial.print("IP Address: ");
  Serial.println(WiFi.softAPIP());

  // Set up WebSocket server
  ws.onEvent(onWsEvent);
  server.addHandler(&ws);

  // HTTP telemetry endpoint
  server.on("/telemetry", HTTP_GET, [](AsyncWebServerRequest *request) {
    String telemetry = getTelemetryJSON();
    request->send(200, "application/json", telemetry);
  });

  // Start server
  server.begin();
}

void loop() {
  processGPS();
  processIMU();

  // Send telemetry data to all WebSocket clients
  String telemetry = getTelemetryJSON();
  ws.textAll(telemetry);

  delay(100); // Adjust as needed for update rate
}
