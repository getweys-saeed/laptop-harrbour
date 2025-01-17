import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laptop_harbour/globals/asset_path.dart';
import 'package:laptop_harbour/screens/login/login.dart';
import 'package:laptop_harbour/screens/order_tracking/order_trakcing.dart';
import 'package:laptop_harbour/screens/profile/change_profile.dart';
import 'package:laptop_harbour/screens/profile/chnage_password.dart';
import 'package:http/http.dart' as http;

class ProfileWidget extends StatelessWidget {
  // Fetch user data from the API
  Future<Map<String, dynamic>> getUserData() async {
    final storage = FlutterSecureStorage();
    const url = 'http://127.0.0.1:8000/api/profile';

    // Read token from secure storage
    final token = await storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception("Token not found");
    }

    // Make the API request
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // Parse the user data from the response
      final data = jsonDecode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: FutureBuilder<Map<String, dynamic>>(
            future: getUserData(), // Call getUserData to fetch the profile
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data found.'));
              } else {
                // Extract user data from snapshot
                final userData = snapshot.data!;
                final String name = userData['name']?.toString() ?? 'No Name';
                final String base = "http://127.0.0.1:8000/";
                final String email = userData['email']?.toString() ?? 'No Email';
                final String profileImage = userData['photo']?.toString() ?? 'default.png';

                return Column(
                  children: [
                    Image.network(
                      "$base$profileImage",
                      height: 50,
                      width: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      email,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 30),
                    // Edit Profile
                    _buildListTile(
                      context,
                      "Edit Profile",
                      Icons.person_outline_sharp,
                      ChangeProfilePage(),
                    ),
                    const SizedBox(height: 8),
                    // Change Password
                    _buildListTile(
                      context,
                      "Change Password",
                      Icons.lock_clock_outlined,
                      ChangePassword(),
                    ),
                    const SizedBox(height: 8),
                    // Track Order
                    _buildListTile(
                      context,
                      "Track Order",
                      Icons.sell,
                      const OrderTrackingPage(),
                    ),
                    const SizedBox(height: 8),
                    // Logout
                    _buildListTile(
                      context,
                      "Logout",
                      Icons.logout,
                      null,
                      onTap: () async {
                        final storage = FlutterSecureStorage();
                        const url =
                            'http://127.0.0.1:8000/api/logout'; // Replace with your API logout endpoint

                        try {
                          // Fetch token from secure storage
                          final token = await storage.read(key: 'auth_token');

                          // If the token exists, make a request to log out the user from the backend
                          if (token != null) {
                            final response = await http.post(
                              Uri.parse(url),
                              headers: {
                                'Authorization': 'Bearer $token',
                              },
                            );

                            if (response.statusCode == 200) {
                              // Successful logout from the backend, delete token from secure storage
                              await storage.delete(key: 'auth_token');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            } else {
                              print(
                                  'Failed to logout from server. Status code: ${response.statusCode}');
                            }
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          }
                        } catch (e) {
                          print('Error logging out: $e');
                        }
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    IconData icon,
    Widget? page, {
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 237, 237, 237),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: 310,
        child: ListTile(
          titleTextStyle: const TextStyle(fontSize: 18),
          title: Text(title),
          onTap: onTap ??
              () {
                if (page != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => page),
                  );
                }
              },
          leading: Icon(icon),
          trailing: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
