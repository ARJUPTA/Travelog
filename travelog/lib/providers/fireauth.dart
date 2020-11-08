import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:travelog/models/http_exception.dart';

class FireAuth {
  auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<Map<String, String>> signInWithGoogle() async {
    Map<String, String> result = {"token": "", "result": ""};
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
      String idToken = await user.getIdToken();
      assert(idToken != null);

      auth.User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');

      var preferences = await SharedPreferences.getInstance();
      String backToken = await backCall(idToken, "", "", "", "signin");
      if (backToken != null) {
        preferences.setString("token", backToken);
        result['result'] = '${user.displayName}';
        return result;
      } else {
        result['result'] = "not_found";
        result['token'] = idToken;
        return result;
      }
    }
    return null;
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }

  Future<bool> isLoggedIn() async {
    // var preferences = await SharedPreferences.getInstance();
    // if (preferences.containsKey("token")) {
    //   auth.UserCredential authResult =
    //       await _auth.signInWithCustomToken(preferences.get("token"));
    //   auth.User user = authResult.user;
    auth.User user = auth.FirebaseAuth.instance.currentUser;
    return user != null;
  }

  Future<String> signInWithEmail(String email, String password) async {
    UserCredential authResult;
    try {
      authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        return "not_found";
      }
      return null;
    }
    User user = authResult.user;
    if (user != null) {
      assert(!user.isAnonymous);
      String idToken = await user.getIdToken();
      assert(idToken != null);

      auth.User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithEmail succeeded: $user');

      var preferences = await SharedPreferences.getInstance();
      preferences.setString(
          "token", await backCall(idToken, "", "", "", "signin"));

      return '${user.displayName}';
    }
    return null;
  }

  Future<bool> signup(
      {String token,
      String username,
      String name,
      String college,
      String email,
      String pass}) async {
    if (email != null) {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      User user = authResult.user;
      if (user != null) {
        assert(!user.isAnonymous);
        String idToken = await user.getIdToken();
        assert(idToken != null);

        auth.User currentUser = _auth.currentUser;
        assert(user.uid == currentUser.uid);

        print('signInWithEmail succeeded: $user');

        token = idToken;
      }
    }
    print(token);
    var preferences = await SharedPreferences.getInstance();
    String backToken = await backCall(token, username, name, college, "signup");
    if (backToken != null) {
      preferences.setString("token", backToken);
      return true;
    } else
      return false;
  }

  Future<String> backCall(String idToken, String username, String name,
      String college, String urlSegment) async {
    final url =
        'https://us-central1-travellog-bhu.cloudfunctions.net/api/auth/$urlSegment';
    var body;
    if (urlSegment == "signup") {
      body = json.encode(
        {
          "idToken": idToken,
          "name": name,
          "institution": college,
          "username": username
        },
      );
    } else if (urlSegment == "signin") {
      body = json.encode(
        {
          "idToken": idToken,
        },
      );
    }
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );
      final responseData = json.decode(response.body);
      print(responseData);

      if (responseData['error'] != null) {
        print(HttpException(responseData['error']['message']));
      } else
        return responseData['idToken'];
    } catch (error) {
      print(error);
    }
    return null;
  }
}
