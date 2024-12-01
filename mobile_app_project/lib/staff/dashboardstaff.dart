import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final Color primaryColor =
    Color(0xFF1A237E); // Dark blue color matching the theme
final TextStyle headingStyle =
    TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor);
final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    textStyle: TextStyle(fontWeight: FontWeight.bold));

class Dashboard1 extends StatelessWidget {
  const Dashboard1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const DashboardPage(),
    );
  }
}

class Asset {
  final String label;
  final int value;
  final Color color;

  Asset({required this.label, required this.value, required this.color});

  factory Asset.fromJson(Map<String, dynamic> json) {
    Color color;
    switch (json['color']) {
      case 'blue':
        color = Colors.blue;
        break;
      case 'green':
        color = Colors.green;
        break;
      case 'red':
        color = Colors.red;
        break;
      case 'yellow':
        color = Colors.yellow;
        break;
      default:
        color = Colors.black;
    }

    return Asset(
      label: json['label'],
      value: json['value'],
      color: color,
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<Asset>> _assets;

  @override
  void initState() {
    super.initState();
    _assets = fetchAssets();
  }

  Future<List<Asset>> fetchAssets() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/dashboard'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Asset.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load assets');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Center(
          child: Text(
            'SPORT APP',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Arial',
              fontSize: 28,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Asset>>(
            future: _assets,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final assets = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    const Expanded(
                      child: AssetStatusChart(),
                    ),
                    const SizedBox(height: 100),
                    Text('Dashboard', style: headingStyle),
                    AssetLegend(assets: assets),
                    const Spacer(),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}

class AssetStatusChart extends StatelessWidget {
  const AssetStatusChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          sectionsSpace: 0,
          centerSpaceRadius: 80,
          sections: [
            PieChartSectionData(
              value: 10, // Available Assets
              color: Colors.green,
              showTitle: false,
            ),
            PieChartSectionData(
              value: 4, // Pending Assets
              color: Colors.yellow,
              showTitle: false,
            ),
            PieChartSectionData(
              value: 5, // Borrow Assets
              color: Colors.blue,
              showTitle: false,
            ),
            PieChartSectionData(
              value: 2, // Disabled Assets
              color: Colors.red,
              showTitle: false,
            ),
          ],
        ),
      ),
    );
  }
}

class AssetLegend extends StatelessWidget {
  final List<Asset> assets;

  const AssetLegend({super.key, required this.assets});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Item Borrow',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...assets.map((asset) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: LegendItem(
                  color: asset.color,
                  label: asset.label,
                  value: asset.value.toString(),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  LegendItem({
    super.key,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        const Text(
          ':',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
