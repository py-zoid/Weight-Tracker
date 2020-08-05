import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginUser extends LoginEvent {
  final String email, password;

  LoginUser({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}
