import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:weight_tracker/repository/user.dart';
import 'package:weight_tracker/widgets/login_form_widget.dart';
import 'package:weight_tracker/widgets/signup_form_widget.dart';
import 'dart:math';

class AuthParent extends StatefulWidget {
  final UserRepository _userRepository;

  AuthParent({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _AuthParentState createState() => _AuthParentState();
}

class _AuthParentState extends State<AuthParent> {
  double height;

  double width;

  int _formIndex = 0;

  final PageController _formController = new PageController();


  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        height: height,
        child: Column(
          children: [
            header(),
            Expanded(child: authTextForm()),
            Align(
              alignment: _formIndex == 0 ?
              Alignment.bottomRight
                  : Alignment.bottomLeft,
              child: FlatButton(
                onPressed: (){
                  if(_formIndex == 0){
                    _formController.animateToPage(1, duration: Duration(milliseconds: 400), curve: Curves.ease);
                  }else{
                    _formController.animateToPage(0, duration: Duration(milliseconds: 400), curve: Curves.ease);
                  }
                },
                  child: Text(
                    _formIndex == 0 ? 'Sign Up' : 'Sign In',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      child: Stack(
        children: [
          Container(
            width: width,
            child: Image.asset(
              "assets/login_screen_wave.png",
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            top: height / 6,
            right: 75,
            child: Container(
              width: width / 3,
              height: width / 3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage("assets/weight_scale_icon.png"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget authTextForm() {
    return Container(
      child: PageView(
        controller: _formController,
        onPageChanged: (index){
            setState(() {
              _formIndex = (_formIndex + 1) % 2;
            });
        },
        children: [
          LoginParent(userRepository: widget._userRepository),
          SignUpParent(userRepository: widget._userRepository),
        ],
      ),
    );
  }
}
