import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travelog/providers/fireauth.dart';
import 'package:travelog/screens/home.dart';

class EditUserDetail extends StatefulWidget {
  EditUserDetail({this.token, this.email, this.pass});
  final String token;
  final String email;
  final String pass;
  @override
  _EditUserDetailState createState() => _EditUserDetailState();
}

class _EditUserDetailState extends State<EditUserDetail> {
  String _college, _username, _name;
  final _formKey = GlobalKey<FormState>();
  final String url = 'https://api.jsonbin.io/b/5fa6d20b48818715939d73b0';

  List college = List();

  Future<void> getCollegeList() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);
    setState(() {
      college = resBody;
    });
  }

  @override
  void initState() {
    super.initState();
    this.getCollegeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
            padding: EdgeInsets.only(left: 10.0), child: Text('User Detail')),
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => {_name = value},
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                onSaved: (value) => {_username = value},
              ),
              DropdownButtonHideUnderline(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new InputDecorator(
                      decoration: InputDecoration(
                        filled: false,
                        hintText: 'Choose College',
                        labelText: 'College',
                      ),
                      isEmpty: _college == null,
                      child: new DropdownButton<String>(
                        value: _college,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            _college = newValue;
                          });
                        },
                        items: college.map((value) {
                          return DropdownMenuItem<String>(
                            value: value['name'] ?? "",
                            child: Text(value['name'] ?? ""),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
<<<<<<< HEAD
                          FireAuth()
                              .signup(
                                  token: widget.token,
                                  username: _username,
                                  name: _name,
                                  college: _college,
                                  email: widget.email,
                                  pass: widget.pass)
                              .then((result) {
                            if (result)
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomePage(
                                  key: Key(_name),
                                  title: _name,
                                ),
                              ));
                          });
=======
                          FireAuth().signup(
                              token: widget.token,
                              username: _username,
                              name: _name,
                              college: _college,
                              email: widget.email,
                              pass: widget.pass);

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomePage(
                              key: Key(_name),
                              title: _name,
                            ),
                          ));
>>>>>>> origin/main
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.save),
                          SizedBox(width: 8),
                          Text('Save Details'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
