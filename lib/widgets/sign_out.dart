import 'package:flutter/material.dart';

class SignOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Icon(Icons.exit_to_app),
          Text('Sign Out')
        ],
      ),
    );
  }
}
