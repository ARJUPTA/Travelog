import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title = ""}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[200],
        leading: IconButton(
          onPressed: () => {},
          // TODO: change it to account avatar (not an icon)
          icon: Icon(Icons.account_circle),
          iconSize: 42.0,
        ),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.indigo[900]),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: RaisedButton(
                color: Colors.red[600],
                textColor: Colors.white,
                onPressed: () => {},
                child: Text(
                  'Emergency Alert',
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () => {},
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Add New Journey',
                style: TextStyle(color: Colors.indigo[900]),
              ),
              color: Colors.cyan[200],
            ),
            ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: Text(
                      'Current Journey',
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
                Container(
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: 1,
                    padding: EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      return;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: Text(
                      'Upcoming Journey',
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
                Container(
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: 1,
                    padding: EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      return;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: Text(
                      'Past Journeys',
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
                Container(
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: 1,
                    padding: EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      return;
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
