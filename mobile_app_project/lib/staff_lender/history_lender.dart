// Lender History Page (history_lender.dart)
import 'package:flutter/material.dart';

final Color primaryColor = Color(0xFF1A237E);
final TextStyle headingStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor);

class HistoryLenderPage extends StatefulWidget {
  @override
  _HistoryLenderPageState createState() => _HistoryLenderPageState();
}

class _HistoryLenderPageState extends State<HistoryLenderPage> {
  String searchQuery = '';
  String selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredHistoryData = lenderHistoryData.where((data) {
      bool matchesSearch = data['name']!.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesStatus = selectedStatus == 'All' || (selectedStatus == 'Approved' && data['isApproved']) || (selectedStatus == 'Disapproved' && !data['isApproved']);
      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        title: Center(
          child: Text(
            'SPORT APP',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Arial', fontSize: 28),
          ),
        ),
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
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedStatus,
                  icon: Icon(Icons.arrow_drop_down),
                  underline: SizedBox(),
                  items: <String>['All', 'Approved', 'Disapproved']
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
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(right: 8.0),
                itemCount: filteredHistoryData.length,
                itemBuilder: (context, index) {
                  final data = filteredHistoryData[index];
                  return _buildLenderHistoryCard(
                    data['name'] ?? '',
                    data['borrower'] ?? '',
                    data['borrowedDate'] ?? '',
                    data['returnedDate'],
                    data['isApproved'] ?? false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLenderHistoryCard(String name, String borrower, String borrowedDate, String? returnedDate, bool isApproved) {
    return Card(
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: Image.asset(
          'assets/images/${name.toLowerCase().replaceAll(' ', '-')}.png',
          width: 40,
          height: 40,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.image, size: 40),
        ),
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
        ),
        subtitle: Text(
          'Borrower: $borrower\nBorrowed: $borrowedDate${(returnedDate != null && returnedDate.isNotEmpty) ? '\nReturned: $returnedDate' : ''}',
          style: TextStyle(color: Colors.black),
        ),
        trailing: Text(
          isApproved ? 'Approved' : 'Disapproved',
          style: TextStyle(color: isApproved ? Colors.green : Colors.red),
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> lenderHistoryData = [
  {
    'name': 'Volleyball',
    'borrower': 'Mr. Jane Lee',
    'borrowedDate': '03/09/2024',
    'returnedDate': '05/09/2024',
    'isApproved': true,
  },
  {
    'name': 'Basketball',
    'borrower': 'Mr. Jane Lee',
    'borrowedDate': '09/09/2024',
    'returnedDate': '11/09/2024',
    'isApproved': true,
  },
  {
    'name': 'Tennis Racket',
    'borrower': 'Mr. Jane Lee',
    'borrowedDate': '08/10/2024',
    'returnedDate': null,
    'isApproved': false,
  },
  {
    'name': 'Volleyball',
    'borrower': 'Ms. Kristine',
    'borrowedDate': '09/10/2024',
    'returnedDate': null,
    'isApproved': false,
  }
];
