import 'package:flutter/material.dart';

class AddStaffPage extends StatefulWidget {
  @override
  _AddStaffPageState createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  String? statusValue = 'Available';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SPORT APP',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Placeholder with Upload and Bin Icons Below
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300],
                        ),
                        child: Icon(
                          Icons.image,
                          size: 80,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Upload Image Button
                          IconButton(
                            icon: Image.asset(
                              'assets/images/upload.png', // Path ของรูป upload.png
                              width: 30, // ขนาดของรูปภาพ
                              height: 30,
                            ),
                            onPressed: () {
                              // Handle image upload
                            },
                          ),
                          SizedBox(width: 16), // Space between the icons
                          // Bin Image Button
                          IconButton(
                            icon: Image.asset(
                              'assets/images/bin.png', // Path ของรูป bin.png
                              width: 24, // ขนาดของรูปภาพ
                              height: 24,
                            ),
                            onPressed: () {
                              // Handle image deletion
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Name Field Row
                _buildTextFieldRow("Name  :", false),
                SizedBox(height: 16),

                // Status Dropdown Row with Conditional Color
                _buildDropdownRow("Status :", statusValue),
                SizedBox(height: 16),

                // Info Field Row
                _buildTextFieldRow("Info      :", false),
                SizedBox(height: 20),
              ],
            ),
          ),

          // Positioned "Add" button in the bottom right corner above the nav bar
          Positioned(
            bottom:
                20, // Distance from the bottom to provide space above the nav bar
            right: 16, // Right margin
            child: ElevatedButton(
              onPressed: () {
                _showConfirmationDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              child: Text(
                'Add',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      // // Bottom Navigation Bar
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 1, // Set the current index to highlight the "Edit" icon
      //   onTap: (index) {
      //     // Handle navigation
      //   },
      //   selectedItemColor: Colors.blue,
      //   unselectedItemColor: Colors.grey,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.edit),
      //       label: 'Edit',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.history),
      //       label: 'History',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.dashboard),
      //       label: 'Dashboard',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_circle),
      //       label: 'Account',
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildTextFieldRow(String label, bool isDropdown) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(label),
        ),
        Expanded(
          flex: 6,
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownRow(String label, String? value) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(label),
        ),
        Expanded(
          flex: 6,
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(
                child: Text(
                  'Available',
                  style: TextStyle(color: Colors.green),
                ),
                value: 'Available',
              ),
              DropdownMenuItem(
                child: Text(
                  'Disabled',
                  style: TextStyle(color: Colors.grey),
                ),
                value: 'Disabled',
              ),
            ],
            onChanged: (newValue) {
              setState(() {
                statusValue = newValue;
              });
            },
          ),
        ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Do you want to add this item',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // ปิด dialog
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red, // สีของปุ่ม No เป็นสีแดง
                    ),
                    child: Center(
                      child: Text(
                        'No',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 40, // ความสูงของเส้นขีดคั่น
                  width: 1, // ความกว้างของเส้นขีดคั่น
                  color: Colors.grey, // สีของเส้นขีดคั่น
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // จัดการการเพิ่มข้อมูลที่นี่
                      //  i add this line when click yes come back to seeall
                      Navigator.pop(context);

                      Navigator.of(context).pop(); // ปิด dialog
                    },
                    style: TextButton.styleFrom(
                      foregroundColor:
                          Colors.green, // สีของปุ่ม Yes เป็นสีเขียว
                    ),
                    child: Center(
                      child: Text(
                        'Yes',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
