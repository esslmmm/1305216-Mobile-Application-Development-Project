import 'package:flutter/material.dart';
import 'package:mobile_app_project/login/project.dart';

class AccountLender extends StatelessWidget {
  final Color primaryColor =
      Color(0xFF1A237E); // Dark blue color matching the theme

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log out now?'),
          content: Text(
              'Logging out will end your current session. You can log in again anytime.'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const FirstPage()), // Ensure FirstPage is defined
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryColor,
          title: Center(
              child: Text('SPORT APP',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Arial',
                      fontSize: 28))),
          automaticallyImplyLeading: false), // Background color
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Profile Picture
                Container(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Color.fromARGB(255, 104, 117, 180),
                    child: Icon(Icons.account_circle_outlined,
                        size: 80, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),

                // Username
                Text(
                  'AKA',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF01082D),
                  ),
                ),
                SizedBox(height: 10),

                // "About Me" section
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About Me',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF01082D),
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildInfoRow('User Name:', 'khao tum kai'),
                        _buildInfoRow('User ID:', 'XXXXXXXXXX'),
                        _buildInfoRow('Email:', 'ASG@gmail.com'),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Log Out Button
                ElevatedButton(
                  onPressed: () => _showLogoutDialog(context),
                  child: Text('Log Out',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF01082D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build each row in the About Me section
  Widget _buildInfoRow(String title, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              info,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
