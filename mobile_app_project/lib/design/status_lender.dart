import 'package:flutter/material.dart';

class StatusLender extends StatelessWidget {
  const StatusLender({super.key});

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
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  final List<Map<String, String>> sportRequests = [
    {
      'icon': '⚽',
      'sport': 'Football',
      'userId': '1244',
      'userName': 'Roman Hill',
      'dateRange': '8/10/2024 - 9/10/2024',
      'status': ''
    },
    {
      'icon': '🎾',
      'sport': 'Tennis',
      'userId': '6104',
      'userName': 'Tomas Jern',
      'dateRange': '6/10/2024 - 7/10/2024',
      'status': ''
    },
    {
      'icon': '🏀',
      'sport': 'Basketball',
      'userId': '7234',
      'userName': 'Victor Fan',
      'dateRange': '6/10/2024 - 7/10/2024',
      'status': ''
    },
  ];

  String searchQuery = '';

  void approveRequest(int index) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Do you want to "Approve" this item'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  sportRequests[index]['status'] = 'Approve'; // Update status
                  sportRequests.removeAt(index); // Remove from the UI
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

  void disapproveRequest(int index) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Do you want to "Disapprove" this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  sportRequests[index]['status'] = 'Dispprove';
                  sportRequests.removeAt(index); // Remove from the UI
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
    final filteredRequests = sportRequests.where((request) {
      return request['sport']!
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          request['userName']!
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
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
                      userId: request['userId']!,
                      userName: request['userName']!,
                      dateRange: request['dateRange']!,
                      status: request['status']!,
                      onApprove: () =>
                          approveRequest(sportRequests.indexOf(request)),
                      onDisapprove: () =>
                          disapproveRequest(sportRequests.indexOf(request)),
                    );
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
  final String userId;
  final String userName;
  final String dateRange;
  final String status;
  final VoidCallback onApprove;
  final VoidCallback onDisapprove;

  SportRequestCard({
    super.key,
    required this.icon,
    required this.sport,
    required this.userId,
    required this.userName,
    required this.dateRange,
    required this.status,
    required this.onApprove,
    required this.onDisapprove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: status == 'Approve' || status == 'Disapprove'
              ? []
              : [
                  Text(
                    icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              sport,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check_circle_outline),
                                  color: Colors.green,
                                  onPressed: onApprove,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.cancel_outlined),
                                  color: Colors.red,
                                  onPressed: onDisapprove,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          'User ID: $userId',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Name: $userName',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dateRange,
                          style: const TextStyle(fontSize: 14),
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
