import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/bloc/authentication/authentication_bloc.dart';
import 'package:weight_tracker/bloc/authentication/authentication_event.dart';
import 'package:weight_tracker/bloc/signout/signout_event.dart';
import 'package:weight_tracker/bloc/signout/signout_state.dart';
import 'package:weight_tracker/repository/database.dart';
import 'package:weight_tracker/repository/user.dart';
import 'package:weight_tracker/widgets/loader.dart';
import 'package:weight_tracker/widgets/pointer.dart';
import 'package:weight_tracker/widgets/sign_out.dart';
import 'package:weight_tracker/bloc/signout/signout_bloc.dart';
import 'package:weight_tracker/widgets/user_data_widget.dart';
import 'package:weight_tracker/widgets/weigh_scale_path.dart';

class HomeParent extends StatelessWidget {
  final FirebaseUser _user;
  final UserRepository _userRepository;

  HomeParent(
      {Key key,
      @required FirebaseUser user,
      @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _user = user,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignoutBloc>(
      create: (context) => SignoutBloc(userRepository: _userRepository),
      child: HomeScreen(
        userRepository: _userRepository,
        user: _user,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final UserRepository _userRepository;
  DatabaseRepository _databaseRepository = DatabaseRepository();
  final FirebaseUser _user;
  double width;
  double height;
  SignoutBloc _signoutBloc;

  HomeScreen(
      {Key key,
      @required FirebaseUser user,
      @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _user = user,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    _signoutBloc = BlocProvider.of<SignoutBloc>(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return BlocListener<SignoutBloc, SignoutState>(
      listener: (context, state) {
        if (state.isFailed) {
        } else if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(AppStartedEvent());
        }
      },
      child: BlocBuilder<SignoutBloc, SignoutState>(builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            height: height,
            child: Stack(
              children: [
                CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: CurvePainter(),
                ),
                CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: PointerPainter(),
                ),
                UserDataParent(
                  databaseRepository: _databaseRepository,
                  user: _user,
                ),
                signOut(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget signOut() {
    return Container(
      height: 50.0,
      margin: EdgeInsets.symmetric(vertical: 50.0, horizontal: 15.0),
      child: Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () {
            _signoutBloc.add(SignoutUser());
          },
          child: SignOut(),
        ),
      ),
    );
  }
}
