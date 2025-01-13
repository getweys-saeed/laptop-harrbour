import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:laptop_harbour/config/colors.dart';
import 'package:laptop_harbour/screens/index/index.dart';
import 'package:laptop_harbour/screens/register/register.dart';
import 'package:laptop_harbour/widgets/custom_input.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


Future<void> loginUser(
    String email, String password, BuildContext context) async {
  const url = 'http://127.0.0.1:8000/api/login';
  final storage = FlutterSecureStorage();


  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      String role = responseBody['user']['role'];
      String status = responseBody['user']['status'];
      String token = responseBody['token'];

      if (role == 'user' && status == 'active') {
        // If role is admin and status is active, navigate to the homepage
         await storage.write(key: 'auth_token', value: token);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => IndexPage()));
     } else {
        // If role or status is not correct, show an error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unauthorized: Invalid Crednetiasl ')));
      }
    } else if (response.statusCode == 401) {
      print('Unauthorized: Incorrect password');
      final responseBody = jsonDecode(response.body);
      String errorMessage = responseBody['message'] ?? 'Incorrect password';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } else if (response.statusCode == 404) {
      print('Not Found: User not registered');
      final responseBody = jsonDecode(response.body);
      String errorMessage = responseBody['message'] ?? 'No user found with this email';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } else if (response.statusCode == 400) {
      print('Bad Request: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bad request')));
    } else {
      print('Unexpected status code: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unexpected error occurred')));
    }
  } catch (e) {
    print('An error occurred: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                "Welcome Back",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: primaryColor),
                textAlign: TextAlign.center,
              ),
              Text(
                "Enter Your Credentials To Login",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              SizedBox(height: 40),
              Form(
                autovalidateMode: AutovalidateMode.always,
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    CustomInput(
                      controller: emailController,
                      hintText: "Enter Ur Email",
                      labelText: "email",
                      icon: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Check if the email format is valid
                        if (!RegExp(
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    CustomInput(
                      controller: passwordController,
                      obscureText: true,
                      hintText: "Enter Ur Password",
                      labelText: "password",
                      icon: Icons.lock,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        // Check if the password length is at least 6 characters
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 330,
                      height: 40,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(theme.primaryColor),
                            foregroundColor:
                                WidgetStatePropertyAll(Colors.white),
                          ),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              String email = emailController.text;

                              String password = passwordController.text;
                              loginUser(email, password, context);

                          
                            }
                          },
                          child: Text(
                            " Login",
                          )),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Don't Have An Account ? ",
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Register Now",
                            style: TextStyle(color: primaryColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()));
                              },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
