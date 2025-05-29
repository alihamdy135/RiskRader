import 'package:flutter/material.dart';

class AppColors {
  static const Color color1 = Color(0xFFFFE1FF);
  static const Color color2 = Color(0xFFE4B1F0);
  static const Color color3 = Color(0xFF7E60BF);
}

class AboutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('System Architecture'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSystemOverview(),
                const SizedBox(height: 30),
                _buildArduinoSection(),
                const SizedBox(height: 30),
                _buildFirebaseSection(),
                const SizedBox(height: 30),
                _buildFlutterSection(),
                const SizedBox(height: 30),
                _buildDataFlowDiagram(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSystemOverview() {
    return _buildSectionCard(
      title: "Complete System Overview",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeatureItem("1. Hardware Layer", "ESP8266 microcontroller with environmental sensors"),
          _buildFeatureItem("2. Data Collection", "Arduino IDE code for sensor reading and preprocessing"),
          _buildFeatureItem("3. Cloud Integration", "Firebase Realtime Database for data storage and synchronization"),
          _buildFeatureItem("4. Mobile Application", "Flutter frontend for real-time monitoring and analysis"),
          _buildFeatureItem("5. Safety Logic", "Automated alerts and advisory system based on sensor data"),
        ],
      ),
    );
  }

  Widget _buildArduinoSection() {
    return _buildSectionCard(
      title: "Arduino Hardware Implementation",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Sensor Configuration:", style: _boldStyle),
          _buildFeatureItem("MQ-7 Sensor", "Measures CO levels (0-1000ppm range) with analog output"),
          _buildFeatureItem("MQ-135 Sensor", "Detects air quality (NH3, NOx, CO2) with analog output"),
          _buildFeatureItem("Rain Sensor", "Measures precipitation intensity (0-100% scale)"),
          _buildFeatureItem("DHT11 Sensor", "Tracks temperature (-20°C to 60°C) and humidity (20-90% RH)"),
          
          const SizedBox(height: 15),
          const Text("Microcontroller Code:", style: _boldStyle),
          _buildCodeSnippet("""
void setup() {
  Serial.begin(115200);
  pinMode(MQ7_SELECT_PIN, OUTPUT);
  pinMode(MQ135_SELECT_PIN, OUTPUT);
  dht.begin();
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}
          """),
          
          const SizedBox(height: 15),
          _buildFeatureItem("Data Transmission", "Sends sensor readings to Firebase every 2 seconds"),
          _buildFeatureItem("Alert Thresholds", "Triggers buzzer alarms when values exceed safety limits"),
        ],
      ),
    );
  }

  Widget _buildFirebaseSection() {
    return _buildSectionCard(
      title: "Firebase Realtime Database",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeatureItem("Database Structure", """
- /Serial/real (current sensor values)
  - MQ7: CO levels
  - MQ135: Air quality
  - Rain: Precipitation
  - Temperature
  - Humidity
- /Serial/Chart (historical data)
  - MQ7_0..19
  - Temperature_0..19
          """),
          
          const SizedBox(height: 15),
          _buildFeatureItem("Security Rules", """
{
  "rules": {
    "Serial": {
      ".read": "auth != null",
      ".write": "auth != null"
    }
  }
}
          """),
          
          const SizedBox(height: 15),
          _buildFeatureItem("Data Flow", """
1. ESP8266 pushes data to Firebase
2. Flutter app listens for changes
3. Real-time updates propagate to all clients
4. Historical data stored for analysis
          """),
        ],
      ),
    );
  }

  Widget _buildFlutterSection() {
    return _buildSectionCard(
      title: "Flutter Application Architecture",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeatureItem("Core Components", """
- SafetyMonitorScreen: Real-time gauges
- DataAnalysisScreen: Historical charts
- SafetyAdvisorScreen: Emergency guidance
- Firebase integration
          """),
          
          const SizedBox(height: 15),
          const Text("Key Functions:", style: _boldStyle),
          _buildFeatureItem("Firebase Initialization", """
final database = FirebaseDatabase.instance;
DatabaseReference ref = database.ref('Serial/real');
ref.onValue.listen((event) {
  // Update UI with new data
});
          """),
          
          const SizedBox(height: 15),
          _buildFeatureItem("Data Processing", """
- Converts raw sensor values to meaningful units
- Implements safety thresholds
- Generates visualizations
- Provides natural disaster correlations
          """),
        ],
      ),
    );
  }

  Widget _buildDataFlowDiagram() {
    return _buildSectionCard(
      title: "End-to-End Data Flow",
      content: Column(
        children: [
          _buildDiagramStep("1. Sensors", Icons.sensors, "Collect environmental data"),
          _buildDiagramArrow(),
          _buildDiagramStep("2. ESP8266", Icons.memory, "Process and transmit via WiFi"),
          _buildDiagramArrow(),
          _buildDiagramStep("3. Firebase", Icons.cloud, "Store and synchronize data"),
          _buildDiagramArrow(),
          _buildDiagramStep("4. Flutter App", Icons.phone_iphone, "Visualize and analyze"),
          _buildDiagramArrow(),
          _buildDiagramStep("5. User Alerts", Icons.notifications, "Safety notifications"),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.color3.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeSnippet(String code) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        code,
        style: const TextStyle(
          color: Colors.lightGreen,
          fontFamily: 'monospace',
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildDiagramStep(String title, IconData icon, String description) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.color2.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _boldStyle),
                Text(description, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagramArrow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: const Icon(Icons.arrow_downward, color: Colors.white),
    );
  }

  static const TextStyle _boldStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
}