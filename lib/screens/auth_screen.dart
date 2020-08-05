import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:weight_tracker/repository/user.dart';
import 'package:weight_tracker/widgets/login_form_widget.dart';
import 'package:weight_tracker/widgets/login_screen_path.dart';
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
        child: Stack(
          children: [
            header(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: FractionallySizedBox(
                    heightFactor: 0.5,
                  ),
                ),
                Flexible(
                    child: FractionallySizedBox(
                        heightFactor: 1.2, child: authTextForm())),
                Container(
                  height: height * 0.1,
                  child: Align(
                    alignment: _formIndex == 0
                        ? Alignment.bottomRight
                        : Alignment.bottomLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: FlatButton(
                        onPressed: () {
                          if (_formIndex == 0) {
                            _formController.animateToPage(1,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.ease);
                          } else {
                            _formController.animateToPage(0,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.ease);
                          }
                        },
                        child: Column(
                          children: [
                            Icon(_formIndex == 0
                                ? Icons.arrow_forward
                                : Icons.arrow_back),
                            Text(
                              _formIndex == 0 ? 'Sign Up' : 'Sign In',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: LoginPainter(),
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
        onPageChanged: (index) {
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
