import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangeProfilePage extends StatefulWidget {
  @override
  _ChangeProfilePageState createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  String? profileImageUrl;

  Future<Map<String, dynamic>> _fetchProfile() async {
    // Fetch the token from secure storage
    final token = await storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('Authentication token not found. Please log in again.');
    }

    final uri = Uri.parse('http://127.0.0.1:8000/api/profile');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to fetch profile data. HTTP status: ${response.statusCode}');
    }
  }

  Future<void> _updateProfile({required String name, required String email}) async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication token not found. Please log in again.')),
      );
      return;
    }

    final uri = Uri.parse('http://127.0.0.1:8000/api/profileUpdate');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = json.encode({'name': name, 'email': email});

    try {
      final response = await http.put(uri, headers: headers, body: body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile. HTTP status: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    try {
      final profile = await _fetchProfile();
      setState(() {
        _nameController.text = profile['name'] ?? '';
        _emailController.text = profile['email'] ?? '';
        profileImageUrl = profile['photo'] != null
            ? 'http://127.0.0.1:8000/${profile['photo']}'
            : null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Profile'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            if (profileImageUrl != null)
              ClipOval(
                child: Image.network(
                  profileImageUrl!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, size: 100, color: Colors.grey);
                  },
                ),
              )
            else
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            const SizedBox(height: 16),

            // Profile Name
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Email
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _updateProfile(
                    name: _nameController.text,
                    email: _emailController.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
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
