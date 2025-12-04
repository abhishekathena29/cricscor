import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // A nullable User object to hold the current user data.
  User? _currentUser;
  User? get currentUser => _currentUser;

  bool get isSignedIn => _currentUser != null;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  changeLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  /// Handles user sign-in with email and password.
  Future<bool> signIn({required String email, required String password}) async {
    changeLoading(true);
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message;
      print(_error);
      return false;
    } catch (e) {
      _error = e.toString();
      print(_error);
      return false;
    } finally {
      changeLoading(false);
    }
  }

  /// Handles new user registration with email and password.
  Future<bool> signUp({
    required String username,
    required String userType,
    required String email,
    required String password,
    // Add additional fields like userType, username, etc. here if needed
  }) async {
    changeLoading(true);
    try {
      // Creates the user in Firebase Auth
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        await FirebaseFirestore.instance.doc(userCredential.user!.uid).set({
          "email": email,
          "username": username,
          "userType": userType,
          "createdAt": Timestamp.now(),
        });
      }
      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message;
      print(_error);
      return false;
    } catch (e) {
      print(_error);
      _error = e.toString();
      return false;
    } finally {
      changeLoading(false);
    }
  }

  /// Handles user sign-out.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    // authStateChanges listener handles the rest.
  }
}
