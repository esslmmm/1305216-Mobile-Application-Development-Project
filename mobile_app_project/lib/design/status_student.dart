import 'package:flutter/material.dart';

class StatusStudent extends StatefulWidget {
  const StatusStudent({super.key});

  @override
  State<StatusStudent> createState() => _StatusStudentState();
}

class _StatusStudentState extends State<StatusStudent> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const StatusPage(),
    );
  }
}

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  final List<Map<String, String>> sportRequests = [
    {
      'icon': '⚽',
      'sport': 'Football',
      'userId': '1244',
      'userName': 'Roman Hill',
      'dateRange': '8/10/2024 - 9/10/2024',
      'status': 'Pending'
    },
    {
      'icon': '🎾',
      'sport': 'Tennis',
      'userId': '6104',
      'userName': 'Tomas Jern',
      'dateRange': '6/10/2024 - 7/10/2024',
      'status': 'Approve'
    },
    {
      'icon': '🏀',
      'sport': 'Basketball',
      'userId': '7234',
      'userName': 'Victor Fan',
      'dateRange': '6/10/2024 - 7/10/2024',
      'status': 'Disapprove',
    },
  ];

  String searchQuery = '';
  String selectedStatus = 'All';

  void cancelRequest(int index) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Do you want to "Cancle" this item'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  sportRequests[index]['status'] = 'Cancle'; // Update status
                });
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.green),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final filteredRequests = sportRequests.where((request) {
    //   return request['sport']!
    //       .toLowerCase()
    //       .contains(searchQuery.toLowerCase());
    // }).toList();

    final filteredRequests = sportRequests.where((request) {
      bool matchesSearch =
          request['sport']!.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesStatus =
          selectedStatus == 'All' || request['status'] == selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SPORT APP',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedStatus,
                    items: <String>['All', 'Approve', 'Pending', 'Disapprove']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatus = newValue!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SearchBar(
                  leading: const Icon(Icons.menu),
                  hintText: 'Search',
                  trailing: const [Icon(Icons.search)],
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value; // Update search query
                    });
                  }),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredRequests.length,
                  itemBuilder: (context, index) {
                    final request = filteredRequests[index];
                    return SportRequestCard(
                        icon: request['icon']!,
                        sport: request['sport']!,
                        dateRange: request['dateRange']!,
                        status: request['status']!,
                        onCancle: () =>
                            cancelRequest(sportRequests.indexOf(request)));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SportRequestCard extends StatelessWidget {
  final String icon;
  final String sport;
  final String dateRange;
  final String status;
  final VoidCallback onCancle;

  const SportRequestCard({
    super.key,
    required this.icon,
    required this.sport,
    required this.dateRange,
    required this.status,
    required this.onCancle,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;

    // Set the color based on the status
    if (status == 'Approve') {
      statusColor = Colors.green;
    } else if (status == 'Pending') {
      statusColor = Colors.orange;
    } else if (status == 'Disapprove') {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.black; // Default color
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sport,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateRange,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (status == 'Pending') ...[
                        IconButton(
                          icon: Icon(Icons.delete_outline),
                          color: Colors.red,
                          onPressed: onCancle,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
