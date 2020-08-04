import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

abstract class SignoutEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class SignoutUser extends SignoutEvent{

  final FirebaseUser user;

  SignoutUser({@required this.user});

  @override
  List<Object> get props => [user];
}