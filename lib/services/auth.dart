import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:face_studio/models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

	// create user object based on FirebaseUser
	User _userFromFirebaseUser(FirebaseUser firebaseUser) {
		return firebaseUser != null ? 
              User(uid: firebaseUser.uid, 
                  email: firebaseUser.email, 
                  fullName: firebaseUser.displayName, 
                  photoUrl: firebaseUser.photoUrl,
                  isEmailVerified: firebaseUser.isEmailVerified,
                  sendEmailVerification: firebaseUser.sendEmailVerification) : null;
	}

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
      //.map((FirebaseUser fUser) => _userFromFirebaseUser(fUser));
      .map(_userFromFirebaseUser);
  }

  // sign in google
  Future googleSignIn() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      final FirebaseUser currentUser = await _auth.currentUser();
      return user.uid == currentUser.uid ? _userFromFirebaseUser(currentUser) : _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  // sign in email&password
  Future emailPasswordSignIn(String email, String password) async {
    try {
      final FirebaseUser existingUser = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      )).user;
      final FirebaseUser currentUser = await _auth.currentUser();
      return existingUser.uid == currentUser.uid ? _userFromFirebaseUser(currentUser) : _userFromFirebaseUser(existingUser);
    } catch(e) {
      print(e);
      return null;
    }
  }

  Future registerUser(String email, String password) async {
    try {
      final FirebaseUser newUser = (await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
        )).user;
      return _userFromFirebaseUser(newUser);
    } catch(e) {
      print(e);
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
} 
