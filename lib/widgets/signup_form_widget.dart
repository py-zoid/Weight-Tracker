import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/bloc/authentication/authentication_bloc.dart';
import 'package:weight_tracker/bloc/authentication/authentication_event.dart';
import 'package:weight_tracker/bloc/authentication/authentication_state.dart';
import 'package:weight_tracker/bloc/user_registration/user_registration_bloc.dart';
import 'package:weight_tracker/bloc/user_registration/user_registration_event.dart';
import 'package:weight_tracker/bloc/user_registration/user_registration_state.dart';
import 'package:weight_tracker/repository/user.dart';

class SignUpParent extends StatelessWidget {
  final UserRepository _userRepository;

  SignUpParent({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserRegistrationBloc>(
      create: (context) =>
          UserRegistrationBloc(userRepository: _userRepository),
      child: SignUpScreen(userRepository: _userRepository),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  final UserRepository _userRepository;
  SignUpScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  UserRepository _userRepository;
  UserRegistrationBloc _signupBloc;
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _nameController = new TextEditingController();
  double width;
  double height;
  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool isNameValid = true;
  String errorMessage;
  static final RegExp _emailRegEx = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
  );
  static final RegExp _passwordRegEx = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  void authFieldValidity(String name, String email, String password) {
    setState(() {
      isNameValid = name.length > 0 ? true : false;
      isEmailValid = _emailRegEx.hasMatch(email);
      isPasswordValid = _passwordRegEx.hasMatch(password);
    });

    if (!isNameValid) {
      setState(() {
        errorMessage = 'All fields are required';
      });
    } else if (!isEmailValid) {
      setState(() {
        errorMessage = 'Please enter a valid email';
      });
    } else if (!isPasswordValid) {
      setState(() {
        errorMessage =
            'Password must contain a number and greater than 8 characters';
      });
    }
  }

  @override
  void initState() {
    _userRepository = widget._userRepository;
    _signupBloc = BlocProvider.of<UserRegistrationBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    print(MediaQuery.of(context).devicePixelRatio);
    return BlocListener<UserRegistrationBloc, UserRegistrationState>(
      listener: (context, state) {
        if (state.isFailed) {
          setState(() {
            errorMessage = state.errorMessage;
          });
        } else if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(AppStartedEvent());
        }
      },
      child: BlocBuilder<UserRegistrationBloc, UserRegistrationState>(
          builder: (context, state) {
        return form();
      }),
    );
  }

  Widget form() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
            child: FractionallySizedBox(
          heightFactor: 0.7,
        )),
        authValidation(),
        authTextFields(),
        RaisedButton(
          onPressed: () {
            authFieldValidity(_nameController.text, _emailController.text,
                _passwordController.text);
            if (isNameValid && isPasswordValid && isEmailValid) {
              _signupBloc.add(RegisterUserEvent(
                name: _nameController.text,
                email: _emailController.text,
                password: _passwordController.text,
              ));
            }
          },
          child: Text('Sign Up'),
        ),
        Flexible(
            child: FractionallySizedBox(
          heightFactor: 0.3,
        )),
      ],
    );
  }

  Widget authValidation() {
    return errorMessage != null
        ? Text(
            errorMessage,
            style: TextStyle(color: Theme.of(context).errorColor),
          )
        : Container();
  }

  Widget authTextFields() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: width / 1.2,
              color: Colors.deepOrange[100],
              child: TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 25.0),
                  fillColor: Colors.deepOrange[100],
                  hintText: 'What\'s your call?',
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: width / 1.2,
              color: Colors.deepOrange[100],
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 25.0),
                  fillColor: Colors.deepOrange[100],
                  hintText: 'We won\'t spam your mail',
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: width / 1.2,
              color: Colors.deepOrange[100],
              child: TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 25.0),
                  fillColor: Colors.deepOrange[100],
                  hintText: 'Your secret is safe',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
