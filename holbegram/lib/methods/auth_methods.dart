import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/models/user.dart';

class AuthMethods {
  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;

  AuthMethods() {
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
  }

  Future<String> login({required String email, required String password}) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return 'Please fill all the fields';
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    Uint8List? file,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty || username.isEmpty) {
        return 'Please fill all the fields';
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = User(
        uid: userCredential.user!.uid,
        email: email,
        username: username,
        bio: '',
        photoUrl: '',
        followers: [],
        following: [],
        posts: [],
        saved: [],
        searchKey: username.toLowerCase(),
      );

      await _firestore.collection('users').doc(user.uid).set(user.toJson());
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }
}
