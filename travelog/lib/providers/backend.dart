import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:travelog/models/http_exception.dart';

class Group {
  String topic;
  List<String> participants = [];
  Map<String, String> trip;

  // Group(var response){
  //   this.topic = response['topic'];
  //   this.participants = response['participants'];
  //   this.trip['boardingDate'] = response['trip']['boardingDate'];
  //   this.trip['creator'] = response['trip']['creator'];
  //   this.trip['duration'] = response['trip']['duration'];
  //   this.trip['from'] = response['trip']['from'];
  //   this.trip['to'] = response['trip']['to'];
  //   this.trip['trainNumber'] = response['trip']['trainNumber'];
  // }

  Group.fromJson(var response) {
    this.topic = response['topic'];
    this.participants = response['participants'];
    this.trip['boardingDate'] = response['trip']['boardingDate'];
    this.trip['creator'] = response['trip']['creator'];
    this.trip['duration'] = response['trip']['duration'];
    this.trip['from'] = response['trip']['from'];
    this.trip['to'] = response['trip']['to'];
    this.trip['trainNumber'] = response['trip']['trainNumber'];
  }

  static List<Group> listFromJson(String str) =>
      List<Group>.from(json.decode(str).map((x) => Group.fromJson(x)));
}

Future getMyGroups(String urlSegment) async {
  var preferences = await SharedPreferences.getInstance();
  String token = preferences.get("token");
  if (token == null) return "no_token";
  final url =
      'https://us-central1-travellog-bhu.cloudfunctions.net/api/auth/groups/list';

  try {
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    final responseData = json.decode(response.body);
    print(responseData);

    if (responseData['error'] != null) {
      print(HttpException(responseData['error']['message']));
    } else {
      List<Group> groups = Group.listFromJson(responseData);
      return groups;
    }
  } catch (error) {
    print(error);
  }
  return null;
}
