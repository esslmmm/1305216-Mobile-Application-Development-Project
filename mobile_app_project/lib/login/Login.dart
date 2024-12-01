import 'package:flutter/material.dart';
import 'package:mobile_app_project/login/register.dart';
import 'package:mobile_app_project/staff/homeforstaff.dart';
import 'package:mobile_app_project/staff_lender/Homeforlen.dart';
import 'package:mobile_app_project/student/Homeforstu.dart';
import 'package:mobile_app_project/login/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool rememberMe = false;

  // TextEditingControllers for retrieving user input
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserCredentials();
  }

  Future<void> _loadUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool('rememberMe') ?? false;
      if (rememberMe) {
        usernameController.text = prefs.getString('username') ?? '';
        passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  Future<void> _saveUserCredentials(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('username', username);
      await prefs.setString('password', password);
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.remove('username');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', false);
    }
  }

  void loginUser(String username, String password) async {
    print('==== Login Attempt ====');
    print('Username: $username');
    // print('Password: $password'); // Avoid printing passwords in real systems

    try {
      if (username.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('กรุณากรอก Username และ Password')),
        );
        return;
      }

      var matchedUser = registeredUsers.firstWhere(
        (user) =>
            (user['username'] == username || user['email'] == username) &&
            user['password'] == password,
        orElse: () => {},
      );

      if (matchedUser.isEmpty) {
        print('No matching user found');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username หรือ Password ไม่ถูกต้อง')),
        );
        return;
      }

      print('User found! Role: ${matchedUser['role']}');

      // Save credentials if rememberMe is true
      await _saveUserCredentials(username, password);

      switch (matchedUser['role']) {
        case 'student':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StudentPage()),
          );
          break;
        case 'staff':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StaffPage()),
          );
          break;
        case 'lender':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LenderPage()),
          );
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ไม่พบสิทธิ์การใช้งาน')),
          );
      }
    } catch (e) {
      print('Error during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 30,
          color: Color(0xFF01082D),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Welcome Back!',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Color(0xFF01082D), fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Login to continue',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Color(0xFF01082D), fontWeight: FontWeight.normal)),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'UserName',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'UserName',
                          hintText: 'UserName',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Password', style: TextStyle(fontSize: 18)),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value!;
                                  });
                                },
                              ),
                              Text('Remember me',
                                  style: TextStyle(color: Color(0xFF1B305B))),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle forget password action here
                            },
                            child: Text(
                              'Forget password?',
                              style: TextStyle(color: Color(0xFF01082D)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: Color(0xFF01082D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            loginUser(usernameController.text,
                                passwordController.text);
                          },
                          child: Text('Login',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? "),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Register(),
                                ),
                              );
                            },
                            child: Text('Register',
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Image.asset('assets/images/sports.png')
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
