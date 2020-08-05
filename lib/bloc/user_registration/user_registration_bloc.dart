import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weight_tracker/bloc/user_registration/user_registration_event.dart';
import 'package:weight_tracker/bloc/user_registration/user_registration_state.dart';
import 'package:weight_tracker/models/user_object.dart';
import 'package:weight_tracker/repository/user.dart';

class UserRegistrationBloc
    extends Bloc<RegisterUserEvent, UserRegistrationState> {
  UserRepository _userRepository = UserRepository();

  UserRegistrationBloc({UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(UserRegistrationState.initial());

  @override
  Stream<UserRegistrationState> mapEventToState(
      RegisterUserEvent event) async* {
    if (event is RegisterUserEvent) {
      yield UserRegistrationState.loading();
      try {
        UserObject user = await _userRepository.signUpEmail(
            event.email, event.password, event.name);
        if (user.message == 'success') {
          yield UserRegistrationState.success();
        } else {
          yield UserRegistrationState.failed(user.message);
        }
      } catch (e) {}
    }
  }
}
