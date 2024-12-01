import 'package:flutter/material.dart';
import 'package:mobile_app_project/student/status_student.dart';
import 'package:mobile_app_project/login/Login.dart';
// import 'package:mobile_app_project/login/project.dart';
// import 'package:mobile_app_project/staff_lender/dashboard.dart';
// import 'package:mobile_app_project/student/status_student.dart';
// import 'package:mobile_app_project/test/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StatusStudent(),
      debugShowCheckedModeBanner: false,
    );
  }
}
