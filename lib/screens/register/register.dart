import 'package:flutter/material.dart';
import 'package:laptop_harbour/config/colors.dart';
import 'package:laptop_harbour/widgets/custom_input.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                "Register Now ",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: primaryColor),
                textAlign: TextAlign.center,
              ),
              Text(
                "Create Your Account",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomInput(
                        hintText: "Enter Ur Name",
                        labelText: "name",
                        icon: Icons.person),
                    CustomInput(
                        hintText: "Enter Ur Email",
                        labelText: "email",
                        icon: Icons.email),
                    CustomInput(
                        hintText: "Enter Ur Password",
                        labelText: "password",
                        icon: Icons.lock),
                    SizedBox(
                      height: 30,
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
                          onPressed: () {},
                          child: Text(
                            " Login",
                          )),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Already Have An Account ? ",
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Login Now",
                            style: TextStyle(color: primaryColor),
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
