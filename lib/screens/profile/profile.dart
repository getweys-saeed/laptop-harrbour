import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laptop_harbour/globals/asset_path.dart';
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
                final String name = userData['name'] ?? 'No Name';
                final String base = "http://127.0.0.1:8000/";
                final String email = userData['email'] ?? 'No Email';
                final String profileImage =
                    userData['photo'] ?? userData['photo'];
                print(base + profileImage);
                print("NAME: $name");
                print("NAME: $profileImage");
                // print("img"+profileImage);

                return Column(
                  children: [
                    // Container(
                    //   height: 50,
                    //   width: 50,
                    //   decoration: BoxDecoration(
                    //     color: Colors.red,
                    //     image: DecorationImage(
                    //       fit: BoxFit.contain,
                    //       image: NetworkImage("$base$profileImage"),
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   height: 50,
                    //   width: 50,
                    //   color: Colors.amber,
                    // ),
                    Image.network(
                       "$base$profileImage",
                      // "http://127.0.0.1:8000/storage/users/1736697513_download.jpg",
                      // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQeYNuL2S2jV1JoJd3SMcB9U7XSME2JjTI-zQ&s",
                      height: 50,
                      width: 50,
                      // errorBuilder: (context, error, stackTrace) {
                      //   return Icon(Icons
                      //       .error); // Display an error icon or a placeholder image
                      // },
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
                      const ChnagePassword(),
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
                        await storage.delete(key: 'auth_token');
                        Navigator.pushReplacementNamed(context,
                            '/login'); // Replace with actual login route
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
