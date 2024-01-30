import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/constant.dart';
import 'package:flutter_chat_app/pages/home.dart';
import 'package:flutter_chat_app/services/auth_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _keepMeSignedIn = false;
  String _errorMessage = '';

  void _login() async {
    final username = _emailController.text;
    final password = _passwordController.text;

    try {
      final user = await AuthService().login(username, password);
      if (kDebugMode) {
        print('Login successful: Token - ${user.token}');
      }
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatRoomListPage(token: user.token),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Login failed: $e');
      }
      // setState(() {
      //   _errorMessage = 'Email or password incorrect. Please try again';
      // });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 90, left: 15, right: 15),
              child: Card(
                elevation: 8.0,
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/logo1.png',
                            width: 200,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      const Row(
                        children: [
                          Text(
                            'Hello! Let us get started',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Text('Sign in to continue.'),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      SizedBox(
                        height: 50.0,
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        height: 50.0,
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            primary: buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text(
                            'SIGN IN',
                            style: TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Visibility(
                        visible: _errorMessage.isNotEmpty,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            const SizedBox(width: 5.0),
                            Text(
                              _errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _keepMeSignedIn,
                                onChanged: (value) {
                                  setState(() {
                                    _keepMeSignedIn = value!;
                                  });
                                },
                              ),
                              const Text('Keep me signed in'),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // Add functionality for "Forgot your password?" here
                            },
                            child: const Text('Forgot your password?'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          TextButton(
                            onPressed: () {
                              // Add functionality for "Create" here
                            },
                            child: const Text('Create'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
