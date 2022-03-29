import 'package:animestar/Models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  Stream<MyUser> get onAuthStateChanged;
  MyUser get currentUser;
  Future<MyUser> signInAnonymously();
  Future<MyUser> signInWithEmailAndPassword(String email, String password);
  Future<MyUser> registerWithEmailAndPassword(String email, String password);
  Future<MyUser> signInWithGoogle();
  Future<void> resetPassword(String email);
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  static const photoUrl =
      "https://images-na.ssl-images-amazon.com/images/I/51kwE8ygw7L._AC_SX679_.jpg";
  final googleSignIn = GoogleSignIn();

  MyUser _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return user.isAnonymous
        ? MyUser(
            uid: user.uid,
            photoUrl: photoUrl,
            email: '',
            displayName: 'Otaku',
          )
        : MyUser(
            uid: user.uid,
            photoUrl: user.photoURL == null ? photoUrl : user.photoURL,
            email: user.email,
            displayName: user.displayName == null ? "" : user.displayName,
          );
  }

  @override
  Stream<MyUser> get onAuthStateChanged {
    return _firebaseAuth
        .authStateChanges()
        .map((user) => _userFromFirebase(user));
  }

  @override
  MyUser get currentUser {
    return _userFromFirebase(_firebaseAuth.currentUser);
  }

  @override
  Future<MyUser> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<MyUser> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential _user;
    try {
      _user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    }
    return _userFromFirebase(_user.user);
  }

  @override
  Future<MyUser> registerWithEmailAndPassword(
      String email, String password) async {
    UserCredential _user;
    try {
      _user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    }
    return _userFromFirebase(_user.user);
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    }
  }

  @override
  Future<MyUser> signInWithGoogle() async {
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final authResult = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth TOken',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<void> signOut() async {
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
