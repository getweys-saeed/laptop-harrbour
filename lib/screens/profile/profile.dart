import 'package:flutter/material.dart';
import 'package:laptop_harbour/globals/asset_path.dart';
import 'package:laptop_harbour/widgets/profile_avatar.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          children: [
            Column(
              children: [
                ProfileAvatar(
                  imgUrl: AssetPath.appLogo,
                ),
                SizedBox(height: 10),
                Text("Muhammad Saeed"),
                Text(
                  "saeed@gmail.com",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w100),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 237, 237, 237),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                width: 310,
                child: ListTile(
                  titleTextStyle: TextStyle(fontSize: 18),
                  title: Text("Change Password"),
                  leading: Icon(Icons.lock_clock_outlined),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 237, 237, 237),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                width: 310,
                child: ListTile(
                  titleTextStyle: TextStyle(fontSize: 18),
                  title: Text("Edit Profile"),
                  leading: Icon(Icons.person_outline_sharp),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 237, 237, 237),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                width: 310,
                child: ListTile(
                  titleTextStyle: TextStyle(fontSize: 18),
                  title: Text("Logout"),
                  leading: Icon(Icons.logout),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
            )
          ],
        ),
      )),
      //   ClipOval(
      //   child: Image.asset(
      //     AssetPath.appLogo,
      //     width: 100,
      //     height: 100,
      //     fit: BoxFit.cover,
      //   ),
      // );
    );
  }
}
