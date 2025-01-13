import 'package:flutter/material.dart';
class ChnagePassword extends StatelessWidget {
  const ChnagePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        centerTitle: true,
      ),  body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Name
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your Old password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Email or other details
            TextField(
              decoration: InputDecoration(
                labelText: 'New Password',
                hintText: 'Enter your New Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle save logic
                  print('Profile Saved');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Save Profile',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}