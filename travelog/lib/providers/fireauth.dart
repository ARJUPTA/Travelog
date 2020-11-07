import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';

class FireAuth {
  auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    auth.UserCredential authResult =
        await _auth.signInWithCredential(credential);
    auth.User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      auth.User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');

      var preferences = await SharedPreferences.getInstance();
      preferences.setString("token", await user.getIdToken());

      return '${user.displayName}';
    }

    return null;
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }

  Future<bool> isLoggedIn() async {
    var preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey("token")) {
      auth.UserCredential authResult =
          await _auth.signInWithCustomToken(preferences.get("token"));
      auth.User user = authResult.user;
      return user != null;
    }
    return false;
  }

  Future<String> signInWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }
}
