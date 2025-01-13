import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final IconData? icon;
  final TextEditingController? controller;
  final String? Function(String?)? validator; 
  
  CustomInput({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.icon,
    this.controller,
    this.validator,
    this.obscureText = false
  });

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        obscureText: obscureText,
        controller: controller,
        validator: validator, // Set the validator for validation
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.grey,
            size: 24,
          ),
          labelStyle: TextStyle(color: Colors.grey),
          hintText: hintText,
          labelText: labelText,
          
          hintStyle: TextStyle(color: Colors.grey),
          floatingLabelStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 11,
            horizontal: 13,
          ),
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 181, 181, 181),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(18)),
              borderSide: BorderSide(
                  color: const Color.fromARGB(255, 113, 113, 113),
                  width: 2.0)),
        ),
      ),
    );
  }
}
