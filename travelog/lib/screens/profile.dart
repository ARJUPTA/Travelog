import 'package:flutter/material.dart';
import 'package:faker/faker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var faker = new Faker();
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: <Widget>[
        SizedBox(height: 8),
        Card(
          color: Theme.of(context).primaryColor,
          child: Container(
            height: 200,
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          faker.person.name(),
                          style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Email: ' + faker.internet.email(),
                          style: TextStyle(fontSize: 15.0, color: Colors.black),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'College: IIT(BHU)',
                          style: TextStyle(fontSize: 15.0, color: Colors.black),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 55,
                      backgroundImage:
                          NetworkImage('https://picsum.photos/250?image=9'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 25),
        Card(
          margin: EdgeInsets.fromLTRB(35, 5, 35, 5),
          color: Colors.teal[100],
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  'Privacy Settings',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Checkbox(
                      activeColor: Colors.red,
                      value: this.isVisible,
                      onChanged: (bool value) {
                        setState(() {
                          this.isVisible = value;
                        });
                      },
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Visibility',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 30),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 120,
            ),
            RaisedButton(
              onPressed: () => {},
              child: Text('Logout'),
            ),
          ],
        )
      ]),
    );
  }
}
