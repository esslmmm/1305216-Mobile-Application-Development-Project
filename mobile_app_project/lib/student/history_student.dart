// Student History Page (history_student.dart)
import 'package:flutter/material.dart';

final Color primaryColor = Color(0xFF1A237E); // Dark blue color matching the theme
final TextStyle headingStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor);
final ButtonStyle buttonStyle = ElevatedButton.styleFrom(backgroundColor: primaryColor, textStyle: TextStyle(fontWeight: FontWeight.bold));

class HistoryStudentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Center(child: Text('SPORT APP', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Arial', fontSize: 28))),
        automaticallyImplyLeading: false
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('History', style: headingStyle),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: 'Last',
                  icon: Icon(Icons.arrow_drop_down),
                  underline: SizedBox(),
                  items: <String>['Last', 'First']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {},
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(right: 8.0),
                itemCount: historyData.length,
                itemBuilder: (context, index) {
                  final data = historyData[index];
                  return _buildHistoryCard(data['name'] ?? '', data['coach'] ?? '', data['borrowedDate'] ?? '', data['returnedDate'], data['status'] ?? '', data['pendingStatus'] ?? '', data['imageUrl'] ?? '');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(String name, String coach, String borrowedDate, String? returnedDate, String status, String pendingStatus, String imageUrl) {
    return Card(
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: Image.asset(imageUrl, width: 40, height: 40),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
        subtitle: Text(
  '$coach\nBorrowed: $borrowedDate${(returnedDate != null && returnedDate.isNotEmpty) ? '\nReturned: $returnedDate' : ''}', 
  style: TextStyle(color: Colors.black)
),

        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(status, style: TextStyle(color: status == 'Disapproved' ? Colors.red : (status == 'Borrowed' ? Colors.orange : Colors.grey))),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> historyData = [
  {
    'name': 'Tennis Racket',
    'coach': 'Steve',
    'borrowedDate': '08/10/2024',
    'returnedDate': null,
    'status': 'Borrowed',
    'pendingStatus': '',
    'imageUrl': 'assets/images/tennis-racket.png'
  },
  {
    'name': 'Football',
    'coach': 'Adams',
    'borrowedDate': '05/10/2024',
    'returnedDate': '07/10/2024',
    'status': 'Returned',
    'pendingStatus': '',
    'imageUrl': 'assets/images/football.png'
  },
  {
    'name': 'Basketball',
    'coach': 'Steve',
    'borrowedDate': '09/09/2024',
    'returnedDate': '11/09/2024',
    'status': 'Returned',
    'pendingStatus': '',
    'imageUrl': 'assets/images/basketball.png'
  },
  {
    'name': 'Volleyball',
    'coach': 'Steve',
    'borrowedDate': '03/09/2024',
    'returnedDate': '05/09/2024',
    'status': 'Disapproved',
    'pendingStatus': '',
    'imageUrl': 'assets/images/volleyball.png'
  }
];
