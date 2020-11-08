import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travelog/providers/backend.dart';
import 'package:travelog/providers/fireauth.dart';
import 'package:travelog/screens/chat_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title = ""}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List<Group> groups = [new Group("Jan Shatabdi"), new Group("Gareeb Rath")];
  List<Group> dms = [
    new Group("Arjun"),
    new Group("Lakshya"),
    new Group("Nishtha")
  ];
  List<Group> more = [
    new Group("Rajdhani"),
    new Group("Jan Shatabdi"),
    new Group("Gareeb Rath")
  ];

  init() async {
    var result = await getMyGroups("list");
    if (result != null)
      setState(() {
        print(result);
        // groups =
        // groups = result;
        // print(groups);
      });
  }

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    // init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan[200],
          leading: IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await FireAuth().signOutGoogle();
              Navigator.of(context).pop();
            },
            // TODO: change it to account avatar (not an icon)
            icon: Icon(Icons.account_circle),
            iconSize: 42.0,
          ),
          title: Text(
            widget.title ?? "",
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
        body: Column(
          children: <Widget>[
            SizedBox(height: 15.0),
            RaisedButton(
              onPressed: () => {Navigator.of(context).pushNamed('/addJourney')},
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Add New Journey',
                style: TextStyle(color: Colors.indigo[900]),
              ),
              color: Colors.cyan[200],
            ),
            SizedBox(height: 15.0),
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    color: Colors.cyan[200],
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: Colors.indigo[900],
                      unselectedLabelColor: Colors.white70,
                      labelColor: Colors.indigo,
                      onTap: (value) {},
                      tabs: [
                        Tab(text: 'Direct Messages'),
                        Tab(text: 'My groups'),
                        Tab(text: 'Join group'),
                      ],
                      controller: tabController,
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                          collection: dms[index].topic)));
                                },
                                child: ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text(dms[index].topic ?? "")),
                              );
                            },
                            itemCount: dms.length,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  leading: Icon(Icons.person),
                                  title: Text(groups[index].topic ?? ""));
                            },
                            itemCount: groups.length,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Icon(Icons.person),
                                title: Text(more[index].topic ?? ""),
                                trailing: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => ChatScreen(
                                                  collection:
                                                      more[index].topic)));
                                    },
                                    child: Icon(Icons.add)),
                              );
                            },
                            itemCount: more.length,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10.0),
            //   ListView(
            //     shrinkWrap: true,
            //     children: <Widget>[
            //       Padding(
            //         padding: const EdgeInsets.all(15.0),
            //         child: Center(
            //           child: Text(
            //             'Current Journey',
            //             style: TextStyle(fontSize: 25.0),
            //           ),
            //         ),
            //       ),
            //       Container(
            //         child: ListView.builder(
            //           physics: ScrollPhysics(),
            //           shrinkWrap: true,
            //           scrollDirection: Axis.vertical,
            //           itemCount: 1,
            //           padding: EdgeInsets.all(8),
            //           itemBuilder: (context, index) {
            //             return;
            //           },
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.all(15.0),
            //         child: Center(
            //           child: Text(
            //             'Upcoming Journey',
            //             style: TextStyle(fontSize: 25.0),
            //           ),
            //         ),
            //       ),
            //       Container(
            //         child: ListView.builder(
            //           physics: ScrollPhysics(),
            //           shrinkWrap: true,
            //           scrollDirection: Axis.vertical,
            //           itemCount: 1,
            //           padding: EdgeInsets.all(8),
            //           itemBuilder: (context, index) {
            //             return;
            //           },
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.all(15.0),
            //         child: Center(
            //           child: Text(
            //             'Past Journeys',
            //             style: TextStyle(fontSize: 25.0),
            //           ),
            //         ),
            //       ),
            //       Container(
            //         child: ListView.builder(
            //           physics: ScrollPhysics(),
            //           shrinkWrap: true,
            //           scrollDirection: Axis.vertical,
            //           itemCount: 1,
            //           padding: EdgeInsets.all(8),
            //           itemBuilder: (context, index) {
            //             return;
            //           },
            //         ),
            //       ),
            //     ],
            //   )
          ],
        ),
      ),
    );
// This trailing comma makes auto-formatting nicer for build methods.
  }
}
