import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
              Row(
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
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the title
                ],
              ),
              const SizedBox(height: 40),
              const Expanded(
                child: AssetStatusChart(),
              ),
              const SizedBox(height: 50),
              const AssetLegend(),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const NavBarItem(
                      icon: Icons.home,
                      label: 'Home',
                      isSelected: false,
                    ),
                    const NavBarItem(
                      icon: Icons.edit_note,
                      label: 'Edit',
                      isSelected: false,
                    ),
                    const NavBarItem(
                      icon: Icons.history,
                      label: 'History',
                      isSelected: false,
                    ),
                    NavBarItem(
                      icon: Icons.pie_chart,
                      label: 'Dashboard',
                      isSelected: true,
                      selectedColor: Colors.blue[300]!,
                    ),
                    const NavBarItem(
                      icon: Icons.person_outline,
                      label: 'Account',
                      isSelected: false,
                    ),
                  ],
                ),
              ),
            ],
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
  const AssetLegend({super.key});

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
            LegendItem(
              color: Colors.blue,
              label: 'Borrow Assets',
              value: '5',
            ),
            const SizedBox(height: 8),
            LegendItem(
              color: Colors.green,
              label: 'Available Assets',
              value: '10',
            ),
            const SizedBox(height: 8),
            LegendItem(
              color: Colors.red,
              label: 'Disabled Assets',
              value: '2',
            ),
            const SizedBox(height: 8),
            LegendItem(
              color: Colors.yellow,
              label: 'Pending Assets',
              value: '4',
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

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color selectedColor;

  const NavBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    this.selectedColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? selectedColor : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? selectedColor : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
