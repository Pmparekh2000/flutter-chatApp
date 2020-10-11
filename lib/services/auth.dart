import 'package:chatapp/modals/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // '_' is used to make method private
  User _userFromFirebaseUser(FirebaseUser user) {
    return user !=null ? User(userId: user.uid): null;
  }

  // Future is a return type. Especially for requesting data from server with some delay
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch(e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch(e) {
      print(e.toString());
    }
  }

  Future resetPassword(String email) async{
    try {
      return await _auth.sendPasswordResetEmail(email: email)
    } catch(e) {
      print(e.toString());
    }
  }

  Future signInOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
    }
  }
}