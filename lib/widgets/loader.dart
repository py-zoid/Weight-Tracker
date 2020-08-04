import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation_radius_in;
  Animation<double> animation_radius_out;
  final double initialSize = 100.0;
  double size = 100.0;
//  Animation<double> animation_radius_out;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    animation_radius_in= Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: controller, curve: Interval(0.75, 1.0, curve: Curves.elasticIn)));
    animation_radius_out= Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Interval(0.0, 0.25, curve: Curves.elasticOut)));

    controller.addListener(() {
      setState(() {
        if(controller.value >= 0.75 && controller.value <= 1.0){
          size = animation_radius_in.value * initialSize;
        }else if(controller.value >= 0.0 && controller.value <= 0.25){
          size = animation_radius_out.value * initialSize;
        }
      });
    });

    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: LoadingIcon(
          size: size,
        ),
      ),
    );
  }
}

class LoadingIcon extends StatelessWidget {
  final double size;

  LoadingIcon({this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.size,
      height: this.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage("assets/weight_scale_icon.png"),
        ),
      ),
    );
  }
}
