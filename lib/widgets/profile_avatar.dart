import 'package:flutter/material.dart';
import 'package:laptop_harbour/globals/asset_path.dart';

class ProfileAvatar extends StatelessWidget {
  final dynamic imgUrl;
  ProfileAvatar({super.key, this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        child: Image.asset(
          imgUrl,
          fit: BoxFit.cover,
        ),
        radius: 50,
        backgroundColor: Colors.white,
      ),
    );
  }
}
