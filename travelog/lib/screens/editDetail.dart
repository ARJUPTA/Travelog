import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditUserDetail extends StatefulWidget {
  @override
  _EditUserDetailState createState() => _EditUserDetailState();
}

class _EditUserDetailState extends State<EditUserDetail> {
  String _college;
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => {},
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                onSaved: (value) => {},
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
                            value: value['id'].toString(),
                            child: Text(value['name'] ?? ""),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    RaisedButton(
                      onPressed: () => {},
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
