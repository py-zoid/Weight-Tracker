import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:weight_tracker/repository/user.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState>{

  UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(VerifyState());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async*{
    if (event is AppStartedEvent){
      try {
        FirebaseUser user = await _userRepository.userPersists();
        if (user != null){
          yield AuthValidState(user: user);
        } else{
          yield AuthInvalidState();
        }
      } catch (e) {
        print(e.toString());
        yield AuthInvalidState();
      }
    }
  }
}