import 'package:flutter/material.dart';

class SignOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          children: [Icon(Icons.exit_to_app), Text('Sign Out')],
        ),
      ),
    );
  }
}
