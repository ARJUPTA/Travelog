import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travelog/screens/editDetail.dart';
import '../providers/fireauth.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoggedIn;
  final _formKey = GlobalKey<FormState>();
  FireAuth _authMethods = FireAuth();
  String email, pass;
  init() async {
    isLoggedIn = await _authMethods.isLoggedIn();
    setState(() {});
  }

  Widget dialog(String message, String token) {
    return SimpleDialog(
      title: Text(
        "UH OH!",
        textAlign: TextAlign.center,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      children: [
        Text(
          message ?? "",
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Visibility(
          visible: token != null,
          child: FlatButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return EditUserDetail(
                        email: email,
                        pass: pass,
                      );
                    },
                  ),
                );
              },
              child: Text(
                "Create New One",
                style: TextStyle(color: Colors.blue),
              )),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    init();
    email = pass = "";
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn == null
        ? Center(child: CircularProgressIndicator())
        : !isLoggedIn
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Welcome to Travelog',
                    style: TextStyle(
                        fontFamily: "BreeSerif",
                        fontSize: 30.0,
                        color: Colors.white,
                        decoration: TextDecoration.none),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    elevation: 8.0,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: 320,
                      width: MediaQuery.of(context).size.width * 0.75,
                      padding: EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'E-Mail'),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value.isEmpty || !value.contains('@')) {
                                    return 'Invalid email!';
                                  }
                                  return null;
                                },
                                onSaved: (value) => {email = value},
                              ),
                              TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Password'),
                                obscureText: true,
                                validator: (value) {
                                  if (value.isEmpty || value.length < 8) {
                                    return 'Password is too short!';
                                  }
                                  return null;
                                },
                                onSaved: (value) => {pass = value},
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              RaisedButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    _authMethods
                                        .signInWithEmail(email, pass)
                                        .then((result) {
                                      if (result != null) {
                                        if (result == "not_found") {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return dialog(
                                                  "No Account Exists With This Email",
                                                  "token");
                                            },
                                          );
                                        } else {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return HomePage(
                                                  key: Key(result),
                                                  title: result,
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return dialog(
                                                "Wrong Username Or Password",
                                                null);
                                          },
                                        );
                                      }
                                    });
                                  }
                                },
                                color: Theme.of(context).primaryColor,
                                child: Text(
                                  'Sign In',
                                ),
                              ),
                              Row(children: <Widget>[
                                Expanded(
                                  child: new Container(
                                      margin: const EdgeInsets.only(
                                          left: 10.0, right: 15.0),
                                      child: Divider(
                                        color: Colors.white,
                                        height: 50,
                                      )),
                                ),
                                Text("OR"),
                                Expanded(
                                  child: new Container(
                                      margin: const EdgeInsets.only(
                                          left: 15.0, right: 10.0),
                                      child: Divider(
                                        color: Colors.white,
                                        height: 50,
                                      )),
                                ),
                              ]),
                              RaisedButton(
                                onPressed: () {
                                  _authMethods
                                      .signInWithGoogle()
                                      .then((result) {
                                    if (result != null) {
                                      print(result['result']);
                                      if (result['result'] == "not_found") {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return EditUserDetail(
                                                token: result['token'],
                                              );
                                            },
                                          ),
                                        );
                                      } else {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return HomePage(
                                                key: Key(result['result']),
                                                title: result['result'],
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    }
                                  });
                                },
                                color: Theme.of(context).primaryColor,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Image(
                                        image: AssetImage(
                                            'assets/google_logo.png'),
                                        height: 20.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Sign In with Google',
                                        ),
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            : HomePage(
                key: Key("Travelog"),
                title: "Travelog",
              );
  }
}
