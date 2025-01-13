// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class ChangeProfilePage extends StatelessWidget {
//   final ImagePicker _picker = ImagePicker();

//   // Controllers for text fields (you can also pass them as arguments to this widget)
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();

//   // Function to pick an image
//   Future<void> _pickImage(BuildContext context) async {
//     final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Change Profile'),
//         centerTitle: true,
//         backgroundColor: Colors.orange,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Profile Image Picker
//             Center(
//               child: GestureDetector(
//                 onTap: () => _pickImage(context), // Pick image
//                 child: CircleAvatar(
//                   radius: 60,
//                   backgroundColor: Colors.grey[200],
//                   backgroundImage: AssetImage('assets/images/default_profile.png'),
//                   child: Icon(Icons.camera_alt, color: Colors.white),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),

//             // Name Field
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(
//                 labelText: 'Name',
//                 hintText: 'Enter your name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),

//             // Email Field
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 hintText: 'Enter your email',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             SizedBox(height: 16),

//             // Phone Number Field
//             TextField(
//               controller: phoneController,
//               decoration: InputDecoration(
//                 labelText: 'Phone Number',
//                 hintText: 'Enter your phone number',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             SizedBox(height: 20),

//             // Save Changes Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Handle save logic and pass back updated data
//                   print('Name: ${nameController.text}');
//                   print('Email: ${emailController.text}');
//                   print('Phone: ${phoneController.text}');
//                   // Typically you would use a state management solution here
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange, // Button color
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text(
//                   'Save Changes',
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChangeProfilePage extends StatefulWidget {
  @override
  _ChangeProfilePageState createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512);

      if (pickedImage != null) {
        setState(() {
          _pickedImage = pickedImage;
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Profile'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _pickedImage != null
                        ? FileImage(File(_pickedImage!.path))
                        : null,
                    child: _pickedImage == null
                        ? Icon(Icons.camera_alt, size: 30, color: Colors.white)
                        : null,
                  ),
                  if (_isLoading)
                    CircularProgressIndicator(), // Show loading indicator while image is being picked
                ],
              ),
            ),
            SizedBox(height: 16),

            // Profile Name
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Email or other details
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
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
