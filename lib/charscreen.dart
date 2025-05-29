import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AppColors {
  static const Color color1 = Color(0xFFFFE1FF);
  static const Color color2 = Color(0xFFE4B1F0);
  static const Color color3 = Color(0xFF7E60BF);
}

class DataAnalysisScreen extends StatefulWidget {
  const DataAnalysisScreen({super.key});

  @override
  _DataAnalysisScreenState createState() => _DataAnalysisScreenState();
}

class _DataAnalysisScreenState extends State<DataAnalysisScreen> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  late DatabaseReference deviceCodeRef;
  late Timer _refreshTimer;

  final List<double> coData = List.filled(20, 0);
  final List<double> airQualityData = List.filled(20, 0);
  final List<double> rainData = List.filled(20, 0);
  final List<double> tempData = List.filled(20, 0);
  final List<double> humidityData = List.filled(20, 0);

  @override
  void initState() {
    super.initState();
    deviceCodeRef = database.ref().child('Serial').child('Chart');
    retrieveData();
    
    // Set up a timer to refresh data every 5 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      retrieveData();
    });
  }

  @override
  void dispose() {
    _refreshTimer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void retrieveData() {
    for (int i = 0; i < 20; i++) {
      final fields = ['MQ7_$i', 'MQ135_$i', 'Rain_$i', 'Temp_$i', 'Humidity_$i'];
      for (var field in fields) {
        deviceCodeRef.child(field).once().then((event) {
          if (mounted) { // Check if widget is still mounted
            setState(() {
              if (field.contains('MQ7')) {
                coData[i] = double.tryParse(event.snapshot.value.toString()) ?? 0;
              } else if (field.contains('MQ135')) {
                airQualityData[i] = double.tryParse(event.snapshot.value.toString()) ?? 0;
              } else if (field.contains('Rain')) {
                rainData[i] = double.tryParse(event.snapshot.value.toString()) ?? 0;
              } else if (field.contains('Temp')) {
                tempData[i] = double.tryParse(event.snapshot.value.toString()) ?? 0;
              } else if (field.contains('Humidity')) {
                humidityData[i] = double.tryParse(event.snapshot.value.toString()) ?? 0;
              }
            });
          }
        }).catchError((error) => debugPrint("Error retrieving $field: $error"));
      }
    }
  }

  Widget _buildChart(String title, List<double> data, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.color3,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: SfCartesianChart(
              primaryXAxis: NumericAxis(),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries>[
                LineSeries<double, int>(
                  dataSource: data,
                  xValueMapper: (_, index) => index,
                  yValueMapper: (value, _) => value,
                  color: color,
                  markerSettings: const MarkerSettings(isVisible: true),
                ),
              ],
            ),
          ),
          _getTrendAnalysis(title, data),
        ],
      ),
    );
  }

  Widget _getTrendAnalysis(String title, List<double> data) {
    final avg = data.reduce((a, b) => a + b) / data.length;
    final max = data.reduce((curr, next) => curr > next ? curr : next);
    final min = data.reduce((curr, next) => curr < next ? curr : next);
    final increasing = data.last > data.first;

    String trend;
    Color trendColor = Colors.grey;
    String advice;
    String phenomenaImpact = "";

    if (title == "CO Levels") {
      if (avg > 30) {
        trend = "Dangerously High";
        trendColor = Colors.red;
        advice = "Immediate ventilation needed. Evacuate if levels persist. CO can cause poisoning and death.";
        phenomenaImpact = "High CO levels may indicate volcanic activity or combustion. Can be lethal in enclosed spaces.";
      } else if (avg > 15) {
        trend = "Elevated";
        trendColor = Colors.orange;
        advice = "Check for combustion sources. Improve ventilation. Monitor for symptoms like dizziness.";
        phenomenaImpact = "Elevated CO often precedes volcanic eruptions. May indicate nearby fires.";
      } else {
        trend = "Normal";
        trendColor = Colors.green;
        advice = "Levels are safe. Maintain regular ventilation checks.";
        phenomenaImpact = "Normal background levels. No immediate volcanic or fire risk detected.";
      }
    } 
    else if (title == "Air Quality") {
      if (avg > 5) {
        trend = "Hazardous";
        trendColor = Colors.red;
        advice = "Wear N95 masks. Limit outdoor exposure. Sensitive groups should stay indoors.";
        phenomenaImpact = "Poor air quality often accompanies volcanic ash, wildfires, or industrial accidents.";
      } else if (avg > 3) {
        trend = "Unhealthy";
        trendColor = Colors.orange;
        advice = "Reduce outdoor activities. Close windows if ash or smoke is present.";
        phenomenaImpact = "May indicate approaching dust storms, volcanic plumes, or pollution buildup.";
      } else {
        trend = "Good";
        trendColor = Colors.green;
        advice = "Air quality is satisfactory. Continue normal activities.";
        phenomenaImpact = "Clean air conditions. No significant particulate threats detected.";
      }
    }
    else if (title == "Rain Intensity") {
      if (avg > 70) {
        trend = "Torrential";
        trendColor = Colors.indigo;
        advice = "Prepare for possible flooding. Avoid low-lying areas. Check drainage systems.";
        phenomenaImpact = "Heavy rainfall can trigger floods, landslides, and volcanic mudflows (lahars).";
      } else if (avg > 40) {
        trend = "Heavy";
        trendColor = Colors.blue;
        advice = "Use caution outdoors. Watch for flash flood warnings.";
        phenomenaImpact = "Sustained heavy rain may saturate soils, increasing landslide risk.";
      } else {
        trend = "Normal";
        trendColor = Colors.green;
        advice = "Normal precipitation levels. Maintain regular drainage checks.";
        phenomenaImpact = "Typical rainfall patterns. No immediate flood risks detected.";
      }
    }
    else if (title == "Temperature") {
      if (avg > 35) {
        trend = "Extreme Heat";
        trendColor = Colors.red;
        advice = "Stay hydrated. Avoid sun exposure. Watch for heat stroke symptoms.";
        phenomenaImpact = "Heat waves may precede volcanic activity. Can indicate climate anomalies.";
      } else if (avg > 28) {
        trend = "Hot";
        trendColor = Colors.orange;
        advice = "Use cooling systems if available. Limit strenuous outdoor work.";
        phenomenaImpact = "Elevated temperatures can dry vegetation, increasing fire risks.";
      } else if (avg < 10) {
        trend = "Cold";
        trendColor = Colors.blue;
        advice = "Dress warmly. Watch for hypothermia in exposed individuals.";
        phenomenaImpact = "Sudden temperature drops may signal approaching storms or volcanic winter effects.";
      } else {
        trend = "Comfortable";
        trendColor = Colors.green;
        advice = "Enjoy the pleasant weather. Maintain normal activities.";
        phenomenaImpact = "Stable temperature range. No extreme weather patterns detected.";
      }
    }
    else if (title == "Humidity") {
      if (avg > 80) {
        trend = "High Humidity";
        trendColor = Colors.teal;
        advice = "Use dehumidifiers. Watch for mold growth. Ensure proper ventilation.";
        phenomenaImpact = "High humidity often precedes heavy rainfall or tropical storms.";
      } else if (avg < 30) {
        trend = "Low Humidity";
        trendColor = Colors.yellow;
        advice = "Stay hydrated. Use humidifiers if needed. Watch for static electricity buildup.";
        phenomenaImpact = "Dry conditions increase fire risks and may indicate approaching heat waves.";
      } else {
        trend = "Comfortable";
        trendColor = Colors.green;
        advice = "Ideal humidity levels. Maintain current environmental controls.";
        phenomenaImpact = "Balanced humidity. No extreme weather correlations detected.";
      }
    }
    else {
      trend = "Stable";
      advice = "No significant changes detected. Continue monitoring.";
      phenomenaImpact = "Normal baseline readings for this parameter.";
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: trendColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: trendColor),
              const SizedBox(width: 5),
              Text("Trend: $trend", 
                  style: TextStyle(color: trendColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 5),
          Text("Avg: ${avg.toStringAsFixed(1)} | Max: ${max.toStringAsFixed(1)} | Min: ${min.toStringAsFixed(1)}"),
          const SizedBox(height: 8),
          Text("Natural Phenomena Impact:", 
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(phenomenaImpact),
          const SizedBox(height: 8),
          Text("Safety Advice:", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(advice),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Environmental Analysis'),
        backgroundColor: AppColors.color3,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: retrieveData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildChart("CO Levels", coData, Colors.red),
              _buildChart("Air Quality", airQualityData, Colors.orange),
              _buildChart("Rain Intensity", rainData, Colors.blue),
              _buildChart("Temperature", tempData, Colors.deepOrange),
              _buildChart("Humidity", humidityData, Colors.teal),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.color2.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  "Natural Phenomena Correlation Guide:\n\n"
                  "• Rising CO + Temperature: Possible volcanic activity\n"
                  "• High Rain : Potential for flooding/landslides\n"
                  "• Low Humidity + High Temp: Increased fire danger\n"
                  "• Poor Air Quality : Ash/dust dispersion risk",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}