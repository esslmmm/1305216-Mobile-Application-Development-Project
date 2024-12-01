import 'package:flutter/material.dart';

final Color primaryColor =
    Color(0xFF1A237E); // Dark blue color matching the theme
final TextStyle headingStyle =
    TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor);
final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: primaryColor,
  textStyle: TextStyle(fontWeight: FontWeight.bold),
);

class HistoryStaffPage extends StatefulWidget {
  @override
  _HistoryStaffPageState createState() => _HistoryStaffPageState();
}

class _HistoryStaffPageState extends State<HistoryStaffPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String dropdownValue = 'Last';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_drop_down),
                  underline: SizedBox(),
                  items: <String>['Last', 'First']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'History'),
                Tab(text: 'Returning Assets'),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildHistoryTab(),
                  _buildReturningAssetsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        padding: EdgeInsets.only(right: 8.0),
        itemCount: staffHistoryData.length,
        itemBuilder: (context, index) {
          final data = staffHistoryData[index];
          return _buildStaffHistoryCard(
            data['name'] ?? '',
            data['borrower'] ?? '',
            data['borrowedDate'] ?? '',
            data['returnedDate'] ?? '',
            data['approvedBy'] ?? '',
            data['returningTo'] ?? '',
          );
        },
      ),
    );
  }

  Widget _buildReturningAssetsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        padding: EdgeInsets.only(right: 8.0),
        itemCount: returningAssetsData.length,
        itemBuilder: (context, index) {
          final data = returningAssetsData[index];
          return _buildReturningAssetCard(
            data['name'] ?? '',
            data['borrower'] ?? '',
            data['borrowedDate'] ?? '',
            data['approvedBy'] ?? '',
            data['returningTo'] ?? '',
            index,
          );
        },
      ),
    );
  }

  Widget _buildStaffHistoryCard(
      String name,
      String borrower,
      String borrowedDate,
      String returnedDate,
      String approvedBy,
      String returningTo) {
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
        ),
        title: Text(name,
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
        subtitle: Text(
          'Borrower: $borrower\nBorrowed: $borrowedDate${(returnedDate.isNotEmpty) ? '\nReturned: $returnedDate' : ''}\nApproved by: $approvedBy\nReturning asset to: $returningTo',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildReturningAssetCard(String name, String borrower,
      String borrowedDate, String approvedBy, String returningTo, int index) {
    bool isReturned = returningAssetsData[index]['returned'] == true;
    return Card(
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Image.asset(
              'assets/images/${name.toLowerCase().replaceAll(' ', '-')}.png',
              width: 40,
              height: 40,
            ),
            title: Text(name,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: primaryColor)),
            subtitle: Text(
              'Borrower: $borrower\nBorrowed: $borrowedDate\nApproved by: $approvedBy\nReturning asset to: $returningTo',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
              child: ElevatedButton(
                onPressed: isReturned
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              title: Text('Confirmation',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor)),
                              content: Text(
                                  'Do you want to mark this item as returned?',
                                  style: TextStyle(color: Colors.black)),
                              actions: [
                                TextButton(
                                  child: Text('Cancel',
                                      style: TextStyle(color: primaryColor)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Yes',
                                      style: TextStyle(color: primaryColor)),
                                  onPressed: () {
                                    setState(() {
                                      returningAssetsData[index]['returned'] =
                                          true;
                                      staffHistoryData.add({
                                        'name': name,
                                        'borrower': borrower,
                                        'borrowedDate': borrowedDate,
                                        'returnedDate': DateTime.now()
                                            .toString()
                                            .split(' ')[0],
                                        'approvedBy': approvedBy,
                                        'returningTo': returningTo,
                                        'status': 'Returned',
                                      });
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                child: Text(isReturned ? 'Returned' : 'Mark as returned'),
                style: isReturned
                    ? ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      )
                    : buttonStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Sample data
final List<Map<String, dynamic>> staffHistoryData = [
  {
    'name': 'Volleyball',
    'borrower': 'Ms. Kristine',
    'borrowedDate': '09/10/2024',
    'returnedDate': '',
    'approvedBy': 'Coach Steve',
    'returningTo': 'staff Gojo',
  },
  {
    'name': 'Tennis Racket',
    'borrower': 'Mr. Jane Lee',
    'borrowedDate': '08/10/2024',
    'returnedDate': '',
    'approvedBy': 'Coach Steve',
    'returningTo': 'staff Mary',
  },
  {
    'name': 'Football',
    'borrower': 'Mr. James',
    'borrowedDate': '05/10/2024',
    'returnedDate': '',
    'approvedBy': 'Coach Steve',
    'returningTo': 'staff Jackson',
  },
];

final List<Map<String, dynamic>> returningAssetsData = [
  {
    'name': 'Badminton Racket',
    'borrower': 'Mr. Andrew',
    'borrowedDate': '06/10/2024',
    'approvedBy': 'Coach Steve',
    'returningTo': 'staff Kate',
    'returned': false,
  },
  {
    'name': 'Basketball',
    'borrower': 'Ms. Sarah',
    'borrowedDate': '07/10/2024',
    'approvedBy': 'Coach Steve',
    'returningTo': 'staff Mike',
    'returned': false,
  },
  {
    'name': 'Baseball Bat',
    'borrower': 'Mr. Tom',
    'borrowedDate': '10/10/2024',
    'approvedBy': 'Coach Steve',
    'returningTo': 'staff Ron',
    'returned': true,
  },
];
