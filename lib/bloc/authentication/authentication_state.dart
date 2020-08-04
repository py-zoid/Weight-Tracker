import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationState extends Equatable{
  @override
  List<Object> get props => [];
}

class VerifyState extends AuthenticationState{}

class AuthValidState extends AuthenticationState{
  final FirebaseUser user;
  AuthValidState({@required this.user});

  @override
  List<Object> get props => [user];
}

class AuthInvalidState extends AuthenticationState{}