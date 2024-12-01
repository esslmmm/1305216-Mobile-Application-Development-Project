import 'package:flutter/material.dart';
import 'package:mobile_app_project/student/all_student.dart';
import 'package:mobile_app_project/student/borrow.dart';

class ListStudent extends StatefulWidget {
  const ListStudent({super.key});

  @override
  State<ListStudent> createState() => _ListStudentState();
}

class _ListStudentState extends State<ListStudent> {
  final List<Map<String, dynamic>> items = [
    {
      "id": "Distinct ID : 001",
      "name": "Football",
      "imagePath": 'assets/images/football.png',
      "status": "Available",
      "color": Color(0xFF2EA64E),
    },
    {
      "id": "Distinct ID : 002",
      "name": "Volleyball",
      "imagePath": 'assets/images/ball2.jpg',
      "status": "Disable",
      "color": Color(0xFFFF0000),
    },
    {
      "id": "Distinct ID : 003",
      "name": "Basketball",
      "imagePath": 'assets/images/ball3.jpg',
      "status": "Borrowed",
      "color": Color(0xFFE7C413),
    },
    {
      "id": "Distinct ID : 004",
      "name": "Badminton",
      "imagePath": 'assets/images/dd.jpg',
      "status": "Pending",
      "color": Color(0xFF007AFF),
    },
  ];

  // Variable to hold the search text
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Filter items based on the search query
    final filteredItems = items.where((item) {
      return item["name"].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sports Equipment',
          style: TextStyle(
            color: Color(0xFF78A3D4),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF78A3D4)),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Row(
              children: [
                Flexible(
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Color(0xFF8F8F8F)),
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Color(0xFF8F8F8F)),
                      filled: true,
                      fillColor: Color(0xFFECECEC),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value; // Update search query
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // See All Students Link
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllStudent()),
                    );
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: Color(0xFFD01D1D),
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Grid View for Items
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  var item = filteredItems[index];

                  return Card(
                    color: const Color(0xFFF2F2F2),
                    margin: const EdgeInsets.all(5),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.asset(
                                item["imagePath"],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                      child: Text('Image not found'));
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            item["name"],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            item["id"],
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Status: ',
                                  style: TextStyle(color: Colors.black)),
                              Text(
                                item["status"],
                                style: TextStyle(color: item["color"]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          // Borrow Button
                          SizedBox(
                            height: 40, // Fixed height to keep alignment
                            child: item["status"] == "Available"
                                ? ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Borrow(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromRGBO(46, 166, 78, 1),
                                    ),
                                    child: const Text(
                                      'Borrow',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : const SizedBox
                                    .shrink(), // Placeholder for non-available items
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
