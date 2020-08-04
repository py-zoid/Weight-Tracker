import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class UserObject {
  final String message;
  final FirebaseUser user;

  UserObject({@required this.message, @required this.user});

}