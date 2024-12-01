import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobile_app_project/login/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

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

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(context),
              const SizedBox(height: 40),
              const Expanded(child: AssetStatusChart()),
              const SizedBox(height: 50),
              const AssetLegend(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        const Expanded(
          child: Text(
            'SPORT APP',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 48), // Balance the title
      ],
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
          sections: _buildPieChartSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return [
      PieChartSectionData(value: 10, color: Colors.green, showTitle: false),
      PieChartSectionData(value: 4, color: Colors.yellow, showTitle: false),
      PieChartSectionData(value: 5, color: Colors.blue, showTitle: false),
      PieChartSectionData(value: 2, color: Colors.red, showTitle: false),
    ];
  }
}

class AssetLegend extends StatefulWidget {
  const AssetLegend({super.key});

  @override
  State<AssetLegend> createState() => _AssetLegendState();
}

class _AssetLegendState extends State<AssetLegend> {
  final String url = 'http://localhost:3000';
  bool isWaiting = false;
  String username = '';
  List? items;

  // Store the asset counts from the API response
  int availableAssets = 0;
  int pendingAssets = 0;
  int borrowedAssets = 0;
  int disabledAssets = 0;

  void popDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
          );
        });
  }

  void getItem() async {
    setState(() {
      isWaiting = true;
    });
    try {
      // get JWT token from local storage
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        // no token, jump to login page
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }

      // token found
      // decode JWT to get username and role
      final jwt = JWT.decode(token!);
      Map payload = jwt.payload;

      // get expenses
      Uri uri = Uri.http(url, '/api/dashboard');
      http.Response response =
          await http.get(uri, headers: {'authorization': token}).timeout(
        const Duration(seconds: 10),
      );
      // check server's response
      if (response.statusCode == 200) {
        // update username and asset counts from the response
        setState(() {
          username = payload['username'];
          Map<String, dynamic> data = jsonDecode(response.body);
          availableAssets = int.parse(data['available_assets']);
          pendingAssets = int.parse(data['pending_assets']);
          borrowedAssets = int.parse(data['borrowed_assets']);
          disabledAssets = int.parse(data['disabled_assets']);
        });
      } else {
        popDialog('Error', response.body);
      }
    } on TimeoutException catch (e) {
      debugPrint(e.message);
      popDialog('Error', 'Timeout error, try again!');
    } catch (e) {
      debugPrint(e.toString());
      popDialog('Error', 'Unknown error, try again!');
    } finally {
      setState(() {
        isWaiting = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getItem();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isWaiting
                ? const CircularProgressIndicator()
                : Text(
                    'Item Borrow',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
            SizedBox(height: 16),
            LegendItem(
              color: Colors.blue,
              label: 'Borrow Assets',
              value: borrowedAssets.toString(),
            ),
            SizedBox(height: 8),
            LegendItem(
              color: Colors.green,
              label: 'Available Assets',
              value: availableAssets.toString(),
            ),
            SizedBox(height: 8),
            LegendItem(
              color: Colors.red,
              label: 'Disabled Assets',
              value: disabledAssets.toString(),
            ),
            SizedBox(height: 8),
            LegendItem(
              color: Colors.yellow,
              label: 'Pending Assets',
              value: pendingAssets.toString(),
            ),
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

  const LegendItem({
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
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const Text(':', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
