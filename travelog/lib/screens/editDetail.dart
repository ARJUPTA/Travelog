import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'collegeList.dart';

class EditUserDetail extends StatefulWidget {
  final List<College> college;
  EditUserDetail({Key key, this.college}) : super(key: key);
  @override
  _EditUserDetailState createState() => _EditUserDetailState();
}

class _EditUserDetailState extends State<EditUserDetail> {
  @override
  Widget build(BuildContext context) {
    var _college;
    return Container(
        child: FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString('assets/college_list.json'),
            builder: (context, snapshot) {
              List<College> college = parseJosn(snapshot.data.toString());
              return Scaffold(
                appBar: AppBar(
                  title: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('User Detail')),
                  automaticallyImplyLeading: false,
                ),
                body: Form(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        DropdownButtonHideUnderline(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                      value: value.name,
                                      child: Text(value.name),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  List<College> parseJosn(String response) {
    if (response == null) {
      return [];
    }
    final parsed =
        json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed.map<College>((json) => new College.fromJson(json)).toList();
  }
}
