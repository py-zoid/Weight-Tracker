import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class UserRegistrationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RegisterUserEvent extends UserRegistrationEvent {
  final String name, email, password;

  RegisterUserEvent(
      {@required this.name, @required this.email, @required this.password});

  @override
  List<Object> get props => [name, email, password];
}
