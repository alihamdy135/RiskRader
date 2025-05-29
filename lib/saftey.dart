import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AppColors {
  static const Color color1 = Color(0xFFFFE1FF);
  static const Color color2 = Color(0xFFE4B1F0);
  static const Color color3 = Color(0xFF7E60BF);
}

class SafetyMonitorScreen extends StatefulWidget {
  const SafetyMonitorScreen({super.key});

  @override
  _SafetyMonitorScreenState createState() => _SafetyMonitorScreenState();
}

class _SafetyMonitorScreenState extends State<SafetyMonitorScreen> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  late DatabaseReference deviceCodeRef;

  double coLevel = 0.0;
  double airQuality = 0.0;
  double rainIntensity = 0.0;
  double temperature = 0.0;
  double humidity = 0.0;

  late StreamSubscription<DatabaseEvent> _coSubscription;
  late StreamSubscription<DatabaseEvent> _airQualitySubscription;
  late StreamSubscription<DatabaseEvent> _rainSubscription;
  late StreamSubscription<DatabaseEvent> _tempSubscription;
  late StreamSubscription<DatabaseEvent> _humiditySubscription;

  @override
  void initState() {
    super.initState();
    deviceCodeRef = database.ref().child('Serial').child('real');
    _setupRealtimeListeners();
  }

  void _setupRealtimeListeners() {
    _coSubscription = deviceCodeRef.child('MQ7').onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null && mounted) {
        setState(() {
          coLevel = double.tryParse(event.snapshot.value.toString()) ?? 0.0;
        });
      }
    });

    _airQualitySubscription = deviceCodeRef.child('MQ135').onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null && mounted) {
        setState(() {
          airQuality = double.tryParse(event.snapshot.value.toString()) ?? 0.0;
        });
      }
    });

    _rainSubscription = deviceCodeRef.child('Rain').onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null && mounted) {
        setState(() {
          rainIntensity = double.tryParse(event.snapshot.value.toString()) ?? 0.0;
        });
      }
    });

    _tempSubscription = deviceCodeRef.child('Temperature').onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null && mounted) {
        setState(() {
          temperature = double.tryParse(event.snapshot.value.toString()) ?? 0.0;
        });
      }
    });

    _humiditySubscription = deviceCodeRef.child('Humidity').onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null && mounted) {
        setState(() {
          humidity = double.tryParse(event.snapshot.value.toString()) ?? 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _coSubscription.cancel();
    _airQualitySubscription.cancel();
    _rainSubscription.cancel();
    _tempSubscription.cancel();
    _humiditySubscription.cancel();
    super.dispose();
  }
  String getSafetyLevel(String title, double value) {
    if (title == "CO Level") {
      if (value > 50) return "Dangerous";
      if (value > 30) return "High";
      if (value > 10) return "Moderate";
      return "Safe";
    } else if (title == "Air Quality") {
      if (value > 5) return "Hazardous";
      if (value > 3) return "Unhealthy";
      if (value > 1) return "Moderate";
      return "Good";
    } else if (title == "Rain Intensity") {
      if (value > 70) return "Heavy Rain";
      if (value > 40) return "Moderate Rain";
      return "Light Rain";
    } else if (title == "Temperature") {
      if (value > 35) return "Extreme Heat";
      if (value > 28) return "Hot";
      if (value < 10) return "Cold";
      return "Comfortable";
    } else if (title == "Humidity") {
      if (value > 80) return "High Humidity";
      if (value < 30) return "Low Humidity";
      return "Comfortable";
    }
    return "Normal";
  }

  String getSafetyAdvice(String title, String level) {
    if (title == "CO Level") {
      if (level == "Dangerous") return "Evacuate area immediately! High CO levels detected.";
      if (level == "High") return "Increase ventilation and limit exposure time.";
      return "CO levels are within safe limits.";
    } else if (title == "Air Quality") {
      if (level == "Hazardous") return "Wear protective masks. Avoid outdoor activities.";
      if (level == "Unhealthy") return "Sensitive groups should reduce exposure.";
      return "Air quality is good.";
    } else if (title == "Rain Intensity") {
      if (level == "Heavy Rain") return "Potential flooding risk. Secure outdoor items.";
      if (level == "Moderate Rain") return "Be cautious of slippery surfaces.";
      return "Normal rainfall conditions.";
    } else if (title == "Temperature") {
      if (level == "Extreme Heat") return "Stay hydrated. Avoid direct sun exposure.";
      if (level == "Hot") return "Use cooling systems if available.";
      if (level == "Cold") return "Wear warm clothing. Watch for hypothermia signs.";
      return "Comfortable temperature range.";
    } else if (title == "Humidity") {
      if (level == "High Humidity") return "Use dehumidifiers. Watch for mold growth.";
      if (level == "Low Humidity") return "Use humidifiers to prevent dryness.";
      return "Comfortable humidity level.";
    }
    return "No specific recommendations needed.";
  }

  Widget buildSafetyIndicator(
      String title, double value, double min, double max, List<GaugeRange> ranges) {
    final level = getSafetyLevel(title, value);
    final advice = getSafetyAdvice(title, level);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: AppColors.color3,
            ),
          ),
          const SizedBox(height: 10),
          SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: min,
                maximum: max,
                interval: (max - min) / 5,
                radiusFactor: 0.8,
                ranges: ranges,
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: value,
                    needleLength: 0.7,
                    needleStartWidth: 3,
                    needleEndWidth: 8,
                    needleColor: AppColors.color3,
                  ),
                ],
              )
            ],
          ),
          Text(
            level,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: level.contains("Dangerous") || level.contains("Hazardous")
                  ? Colors.red
                  : level.contains("High") || level.contains("Unhealthy")
                      ? Colors.orange
                      : AppColors.color3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            advice,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Safety Monitor"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 20),
            child: Column(
              children: [
                buildSafetyIndicator("CO Level", coLevel, 0, 100, [
                  GaugeRange(startValue: 0, endValue: 10, color: Colors.green),
                  GaugeRange(startValue: 10, endValue: 30, color: Colors.yellow),
                  GaugeRange(startValue: 30, endValue: 50, color: Colors.orange),
                  GaugeRange(startValue: 50, endValue: 100, color: Colors.red),
                ]),
                buildSafetyIndicator("Air Quality", airQuality, 0, 10, [
                  GaugeRange(startValue: 0, endValue: 1, color: Colors.green),
                  GaugeRange(startValue: 1, endValue: 3, color: Colors.yellow),
                  GaugeRange(startValue: 3, endValue: 5, color: Colors.orange),
                  GaugeRange(startValue: 5, endValue: 10, color: Colors.red),
                ]),
                buildSafetyIndicator("Rain Intensity", rainIntensity, 0, 100, [
                  GaugeRange(startValue: 0, endValue: 40, color: Colors.blue),
                  GaugeRange(startValue: 40, endValue: 70, color: Colors.blueAccent),
                  GaugeRange(startValue: 70, endValue: 100, color: Colors.indigo),
                ]),
                buildSafetyIndicator("Temperature", temperature, -10, 50, [
                  GaugeRange(startValue: -10, endValue: 10, color: Colors.blue),
                  GaugeRange(startValue: 10, endValue: 28, color: Colors.green),
                  GaugeRange(startValue: 28, endValue: 35, color: Colors.orange),
                  GaugeRange(startValue: 35, endValue: 50, color: Colors.red),
                ]),
                buildSafetyIndicator("Humidity", humidity, 0, 100, [
                  GaugeRange(startValue: 0, endValue: 30, color: Colors.yellow),
                  GaugeRange(startValue: 30, endValue: 80, color: Colors.green),
                  GaugeRange(startValue: 80, endValue: 100, color: Colors.blue),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}