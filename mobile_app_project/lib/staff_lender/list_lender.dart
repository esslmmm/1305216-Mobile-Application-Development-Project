import 'package:flutter/material.dart';
import 'package:mobile_app_project/staff_lender/all_lender.dart';

class ListLender extends StatefulWidget {
  const ListLender({super.key});

  @override
  State<ListLender> createState() => _ListLenderState();
}

class _ListLenderState extends State<ListLender> {
  // Combined list of items
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            'Sports Equipment',
            style: TextStyle(
              color: Color(0xFF78A3D4),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF78A3D4)),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Sports Equipment',
              style: TextStyle(
                color: Color(0xFF78A3D4),
                fontWeight: FontWeight.bold,
              ),
            ),
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
                      // handle search logic here
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // ElevatedButton(
                //   onPressed: () {},
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.green,
                //   ),
                //   child: Text('Add', style: TextStyle(color: Colors.white)),
                // ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllLender()),
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
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  var item = items[index];

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
                          const SizedBox(height: 60),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     ElevatedButton(
                          //       onPressed: () {
                          //         print('Edit pressed for ${item["name"]}');
                          //       },
                          //       style: ElevatedButton.styleFrom(
                          //         backgroundColor: const Color(0xFF1B305B),
                          //         minimumSize: const Size(80, 40),
                          //       ),
                          //       child: const Text(
                          //         'Edit',
                          //         style: TextStyle(color: Colors.white),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 5),
                          //     ElevatedButton(
                          //       onPressed: (item["status"] == "Pending" ||
                          //               item["status"] == "Borrowed")
                          //           ? null
                          //           : () {
                          //               setState(() {
                          //                 if (item["status"] == "Available") {
                          //                   item["status"] = "Disable";
                          //                   item["color"] = Color(0xFFFF0000);
                          //                 } else {
                          //                   item["status"] = "Available";
                          //                   item["color"] = Color(0xFF2EA64E);
                          //                 }
                          //               });
                          //             },
                          //       style: ElevatedButton.styleFrom(
                          //         backgroundColor: item["status"] == "Disable"
                          //             ? Colors.yellow
                          //             : Colors.red,
                          //         padding: const EdgeInsets.symmetric(
                          //             horizontal: 12, vertical: 8),
                          //         minimumSize: const Size(80, 40),
                          //       ),
                          //       child: Text(
                          //         item["status"] == "Disable"
                          //             ? 'Activate'
                          //             : 'Disable',
                          //         style: const TextStyle(color: Colors.white),
                          //       ),
                          //     ),
                          //   ],
                          // ),
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
