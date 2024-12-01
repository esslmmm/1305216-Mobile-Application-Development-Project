import 'dart:async';
import 'dart:convert';
import 'login.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Expense extends StatefulWidget {
  const Expense({super.key});

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  final String url = 'localhost:3000';
  bool isWaiting = false;
  String username = '';
  List? expenses;

  void popDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
          );
        });
  }

  void getExpenses() async {
    setState(() {
      isWaiting = true;
    });
    try {
      // get JWT token from local storage
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        // no token, jump to login page
        // check mounted to use 'context' for navigation in 'async' method
        if (!mounted) return;
        // Cannot use only pushReplacement() because the dialog is showing
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }

      // token found
      // decode JWT to get uername and role
      final jwt = JWT.decode(token!);
      Map payload = jwt.payload;

      // get expenses
      Uri uri = Uri.http(url, '/expenses');
      http.Response response =
          await http.get(uri, headers: {'authorization': token}).timeout(
        const Duration(seconds: 10),
      );
      // check server's response
      if (response.statusCode == 200) {
        // show expenses in ListView
        setState(() {
          // update username
          username = payload['username'];
          // convert response to List
          expenses = jsonDecode(response.body);
        });
      } else {
        // wrong username or password
        popDialog('Error', response.body);
      }
    } on TimeoutException catch (e) {
      debugPrint(e.message);
      popDialog('Error', 'Timeout error, try again!');
    } catch (e) {
      debugPrint(e.toString());
      popDialog('Error', 'Unknown error, try again!');
    } finally {
      setState(() {
        isWaiting = false;
      });
    }
  }

  void confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sure to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: logout,
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void logout() async {
    // remove stored token
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // await prefs.remove('token');

    // to prevent warning of using context in async function
    if (!mounted) return;
    // Cannot use only pushReplacement() because the dialog is showing
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    getExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          Text(username),
          IconButton(
            onPressed: confirmLogout,
            icon: const Icon(Icons.person_off),
          ),
        ],
      ),
      body: isWaiting
          ? const CircularProgressIndicator()
          : ListView.builder(
              itemCount: expenses == null ? 0 : expenses!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.paid),
                    title: Text(expenses![index]['item']),
                    subtitle: Text('${expenses![index]['paid']} baht'),
                  ),
                );
              },
            ),
    );
  }
}
