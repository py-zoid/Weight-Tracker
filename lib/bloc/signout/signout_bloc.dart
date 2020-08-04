import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:weight_tracker/repository/user.dart';
import 'signout_event.dart';
import 'signout_state.dart';

class SignoutBloc extends Bloc<SignoutEvent, SignoutState>{

  UserRepository _userRepository = UserRepository();

  SignoutBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(SignoutState.initial());

  @override
  Stream<SignoutState> mapEventToState(SignoutEvent event) async*{
    if(event is SignoutUser){
      yield SignoutState.loading();
      try {
        await _userRepository.signOut();
        yield SignoutState.success();
      } catch (e) {
        print(e.toString());
        yield SignoutState.failed();
      }

    }
  }
}