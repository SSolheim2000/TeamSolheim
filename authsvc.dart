import 'package:TeamSolheim/dbContactInfo.dart';
import 'package:TeamSolheim/dbSubscriptions.dart';
import 'package:TeamSolheim/dbUserData.dart';
import 'package:TeamSolheim/home.dart';
import 'package:TeamSolheim/user.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  final FirebaseAuth _auth =FirebaseAuth.instance; //underscore means private and can only be used here.

  // Create user object based on Firebase USER
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
      .map(_userFromFirebaseUser);
  }

  // Google sign in ************************************
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      //'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future signInGoogle() async {
    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final AuthResult authResult = await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;
      Home.myUID = authResult.user.uid;
      print(Home.myUID);
    } catch (error) {
      print(error);
    }
  }


////sign in anonymous ************************************
//  Future signInAnon() async {
//    try {
//      AuthResult result = await _auth.signInAnonymously();
//      FirebaseUser user = result.user;
//      print(result);
//      return _userFromFirebaseUser(user);
//    }catch(e){
//      print(e.toString());
//      print(e);
//      return null;
//    }
//  }

//sign in email
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      Home.myUID = result.user.uid;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

//register
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      //create a new document in firestorm
      print('${user.uid} - before');
      await DBServiceContactInfo(uid: user.uid).updateContactInfo(null, null, null, null,null,null,null,null,null,null,null,null,null);
      await DBServiceUserData(uid: user.uid).updateUserData(2, null, null,null,null,null,null,null,null,null,null,null);
      await DBServiceSubscriptions(uid: user.uid).updateSubscriptions(null, true, null,null,null,null,null);
      print('${user.uid} - after');
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

// logout Firebase
  Future signOutFirebase() async {
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }
// Logout Google
  Future signOutGoogle() async {
    try{
      return await _googleSignIn.disconnect();
    } catch(e){
      print(e.toString());
      return null;
    }
  }
}