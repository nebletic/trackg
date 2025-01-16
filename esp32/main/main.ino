#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <ArduinoJson.h>

// IMU setup
Adafruit_MPU6050 mpu;

// BLE setup
BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;
const char* serviceUUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
const char* characteristicUUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";

// Telemetry data variables
float g_force_x = 0.0, g_force_y = 0.0, g_force_z = 0.0;
float pitch = 0.0, roll = 0.0;
float slope = 0.0; // Slope calculation variable

// Function to setup IMU module
void setupIMU() {
    Serial.println("Initializing IMU...");
    if (!mpu.begin()) {
        Serial.println("Failed to find MPU6050 chip. Check wiring.");
        while (1); // Halt on failure
    }
    mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
    mpu.setGyroRange(MPU6050_RANGE_500_DEG);
    mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);
    Serial.println("IMU initialized.");
}

// BLE Server Callbacks
class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
    }
};

void setup() {
    // Start serial communication for debugging
    Serial.begin(115200);

    // Initialize IMU
    setupIMU();

    // Initialize BLE
    BLEDevice::init("ESP32_BLE");
    pServer = BLEDevice::createServer();
    pServer->setCallbacks(new MyServerCallbacks());

    BLEService *pService = pServer->createService(serviceUUID);
    pCharacteristic = pService->createCharacteristic(
                        characteristicUUID,
                        BLECharacteristic::PROPERTY_READ |
                        BLECharacteristic::PROPERTY_WRITE |
                        BLECharacteristic::PROPERTY_NOTIFY |
                        BLECharacteristic::PROPERTY_INDICATE
                      );
    pCharacteristic->addDescriptor(new BLE2902());

    pService->start();
    pServer->getAdvertising()->start();
    Serial.println("BLE device started, now you can pair it with your phone!");
}

void loop() {
    // Read IMU data
    sensors_event_t a, g, temp;
    mpu.getEvent(&a, &g, &temp);

    // Update telemetry data
    g_force_x = a.acceleration.x;
    g_force_y = a.acceleration.y;
    g_force_z = a.acceleration.z;
    pitch = atan2(g_force_y, g_force_z) * 180 / PI;
    roll = atan2(-g_force_x, sqrt(g_force_y * g_force_y + g_force_z * g_force_z)) * 180 / PI;

    // Calculate slope
    slope = atan2(g_force_x, sqrt(g_force_y * g_force_y + g_force_z * g_force_z)) * 180 / PI;


    // Create JSON object
    StaticJsonDocument<200> doc;
    doc["g_force_x"] = g_force_x;
    doc["g_force_y"] = g_force_y;
    doc["g_force_z"] = g_force_z;
    doc["pitch"] = pitch;
    doc["roll"] = roll;
    doc["slope"] = slope;

    // Serialize JSON to string
    String output;
    serializeJson(doc, output);

    // Send data over BLE if connected
    if (deviceConnected) {
        pCharacteristic->setValue(output.c_str());
        pCharacteristic->notify();
        Serial.println("Data sent over BLE: " + output);
    } else {
        Serial.println("No BLE clients connected.");
    }

    // Log the output for debugging
    //Serial.println("Telemetry data: " + output);

    // Handle reconnection
    if (!deviceConnected && oldDeviceConnected) {
        delay(500); // Give the BLE stack the chance to get things ready
        pServer->startAdvertising(); // Restart advertising
        Serial.println("Restart advertising");
        oldDeviceConnected = deviceConnected;
    }

    // Handle disconnection
    if (deviceConnected && !oldDeviceConnected) {
        oldDeviceConnected = deviceConnected;
    }

    // Delay for a while
    delay(250);
}