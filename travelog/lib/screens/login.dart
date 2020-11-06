import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'E-Mail'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Invalid email!';
                        }
                      },
                      onSaved: (value) => {},
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty || value.length < 8) {
                          return 'Password is too short!';
                        }
                      },
                      onSaved: (value) => {},
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      onPressed: () => {},
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Sign In',
                      ),
                    ),
                    Row(children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 15.0),
                            child: Divider(
                              color: Colors.white,
                              height: 50,
                            )),
                      ),
                      Text("OR"),
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 15.0, right: 10.0),
                            child: Divider(
                              color: Colors.white,
                              height: 50,
                            )),
                      ),
                    ]),
                    RaisedButton(
                      onPressed: () => {},
                      color: Theme.of(context).primaryColor,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image(
                              image: AssetImage('assets/google_logo.png'),
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
    );
  }
}
