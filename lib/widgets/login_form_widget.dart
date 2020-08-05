import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/bloc/authentication/authentication_bloc.dart';
import 'package:weight_tracker/bloc/authentication/authentication_event.dart';
import 'package:weight_tracker/bloc/authentication/authentication_state.dart';
import 'package:weight_tracker/bloc/login/login_bloc.dart';
import 'package:weight_tracker/bloc/login/login_event.dart';
import 'package:weight_tracker/bloc/login/login_state.dart';
import 'package:weight_tracker/repository/user.dart';

class LoginParent extends StatelessWidget {
  final UserRepository _userRepository;

  LoginParent({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(userRepository: _userRepository),
      child: LoginScreen(userRepository: _userRepository),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final UserRepository _userRepository;
  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRepository _userRepository;
  LoginBloc _loginBloc;
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  double width;
  double height;
  bool isEmailValid = true;
  bool isPasswordValid = true;
  String errorMessage;
  static final RegExp _emailRegEx = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
  );
  static final RegExp _passwordRegEx = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  void authFieldValidity(String email, String password) {
    setState(() {
      isEmailValid = _emailRegEx.hasMatch(email);
      isPasswordValid = _passwordRegEx.hasMatch(password);
    });
    if (!isEmailValid) {
      setState(() {
        errorMessage = 'Please enter a valid email';
      });
    } else if (!isPasswordValid) {
      setState(() {
        errorMessage = 'Password is not valid';
      });
    }
  }

  @override
  void initState() {
    _userRepository = widget._userRepository;
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailed) {
          setState(() {
            errorMessage = state.errorMessage;
          });
        } else if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(AppStartedEvent());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return Center(
          child: Column(
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
                  authFieldValidity(
                      _emailController.text, _passwordController.text);
                  if (isPasswordValid && isEmailValid) {
                    _loginBloc.add(LoginUser(
                      email: _emailController.text,
                      password: _passwordController.text,
                    ));
                  }
                },
                child: Text('Sign In'),
              ),
              Flexible(
                  child: FractionallySizedBox(
                heightFactor: 0.3,
              )),
            ],
          ),
        );
      }),
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
        children: [
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
                  hintText: 'Email',
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
//              margin: EdgeInsets.only(top: 20),
              width: width / 1.2,
              color: Colors.deepOrange[100],
              child: TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 25.0),
                  fillColor: Colors.deepOrange[100],
                  hintText: 'Password',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
