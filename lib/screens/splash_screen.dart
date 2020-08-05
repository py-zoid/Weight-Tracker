import 'package:flutter/material.dart';
import 'package:weight_tracker/widgets/loader.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Loader(),
    );
  }
}
