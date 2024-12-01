import 'package:flutter/material.dart';



class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController(text: "Football");
  final TextEditingController _infoController = TextEditingController(
    text: "This ADIDAS Fussballliebe League soccer ball combines a seamless TSBE construction with a flexible butyl inner liner. For reliable performance in the field. The colorful graphics stand out from the outside, inspired by the official balls of Europe's top international tournaments.",
  );

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _nameController.dispose();
    _infoController.dispose();
    super.dispose();
  }

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
            // Navigate back
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/football.png',
                            fit: BoxFit.cover,
                          ),
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
                _buildTextFieldRow("Name  :", _nameController, false),
                SizedBox(height: 20), // เพิ่มระยะห่างที่นี่

                // Info Field Row
                _buildTextFieldRow("Info      :", _infoController, true),
                SizedBox(height: 20),
              ],
            ),
          ),

          // Positioned "Edit" button in the bottom right corner above the nav bar
          Positioned(
            bottom: 20, // Distance from the bottom to provide space above the nav bar
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
                'Edit',
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

  Widget _buildTextFieldRow(String label, TextEditingController controller, bool isInfo) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Align the text fields to the start
      children: [
        Expanded(
          flex: 1,
          child: Text(label),
        ),
        Expanded(
          flex: 6,
          child: TextField(
            controller: controller,
            maxLines: isInfo ? 5 : 1, // ขยายช่อง Info ขึ้นเป็น 5 บรรทัด
            minLines: isInfo ? 3 : 1, // ขนาดขั้นต่ำของช่อง Info
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
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
              'Do you want to edit this item?',
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
                      Navigator.of(context).pop(); // Close dialog
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red, // No button color
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
                  height: 40, // Height of the divider
                  width: 1, // Width of the divider
                  color: Colors.grey, // Color of the divider
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                     Navigator.pop(context);

                      Navigator.of(context).pop();  // Close dialog
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green, // Yes button color
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
