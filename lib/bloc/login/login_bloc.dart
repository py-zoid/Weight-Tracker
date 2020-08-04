import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:weight_tracker/models/user_object.dart';
import 'package:weight_tracker/repository/user.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>{

  UserRepository _userRepository = UserRepository();

  LoginBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(LoginState.initial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async*{
    if(event is LoginUser){
      yield LoginState.loading();
      try {
        UserObject user = await _userRepository.signInEmail(event.email, event.password);
        if(user.message == 'success') {
          yield LoginState.success();
        }else{
          yield LoginState.failed(user.message);
        }
      } catch (e) {
        yield LoginState.failed(e.toString());
      }

    }
  }
}