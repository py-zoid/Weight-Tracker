import 'package:flutter/material.dart';
import 'package:weight_tracker/app_bloc_observer.dart';
import 'package:weight_tracker/bloc/authentication/authentication_event.dart';
import 'package:weight_tracker/bloc/authentication/authentication_state.dart';
import 'package:weight_tracker/repository/user.dart';
import 'package:weight_tracker/screens/auth_screen.dart';
import 'package:weight_tracker/screens/splash_screen.dart';
import 'package:weight_tracker/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/bloc/authentication/authentication_bloc.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(
        userRepository: userRepository,
      )..add(AppStartedEvent()),
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.orange[700],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
          textTheme: ButtonTextTheme.normal,
        ),
        textTheme: TextTheme(
          button: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.blueGrey[200],
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.requestFocus(FocusNode());
            }
          },
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is AuthValidState) {
                return HomeParent(
                  user: state.user,
                  userRepository: _userRepository,
                );
              } else if (state is AuthInvalidState) {
                return AuthParent(
                  userRepository: _userRepository,
                );
              } else if (state is VerifyState) {
                return SplashScreen();
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
