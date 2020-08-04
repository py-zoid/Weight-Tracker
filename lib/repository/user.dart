import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/models/user_object.dart';

class UserRepository {
  FirebaseAuth firebaseAuth;
  Firestore firestore;

  UserRepository() {
    this.firebaseAuth = FirebaseAuth.instance;
    this.firestore = Firestore.instance;
  }

  Future<UserObject> signUpEmail(String email, String password, String name) async{
    try {
      AuthResult result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      await firestore.collection('users').document(result.user.uid).setData({
        'email': email,
        'name': name,
      });

      return UserObject(message: 'success', user: result.user);

    }catch(e){
      return UserObject(message: e.message, user: null);
    }
  }

  Future<UserObject> signInEmail(String email, String password) async{
    try{
      AuthResult result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return UserObject(message: 'success', user: result.user);

    }catch(e){
      return UserObject(message: e.message, user: null);
    }
  }

  Future<void> signOut() async{
    await firebaseAuth.signOut();
  }

  Future<FirebaseUser> userPersists() async{
    FirebaseUser user = await firebaseAuth.currentUser();
    return user;
  }
}
