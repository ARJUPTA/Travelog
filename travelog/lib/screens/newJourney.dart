import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddJourney extends StatefulWidget {
  @override
  _AddJourneyState createState() => _AddJourneyState();
}

class _AddJourneyState extends State<AddJourney> {
  static final List<String> _dropdownItems = <String>['Train', 'Flight'];
  String _mode;
  String _stationTo;
  String _stationFrom;
  String _airportTo;
  String _airportFrom;

  final String url = 'https://api.jsonbin.io/b/5fa6d269bd01877eecdaf34a/2';
  final String url1 = 'https://api.jsonbin.io/b/5fa6d292bd01877eecdaf35b';

  List stationCode = List();
  List airport = List();

  Future<void> getStationList() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);
    setState(() {
      stationCode = resBody['data'];
    });
  }

  Future<void> getAirportList() async {
    var res = await http
        .get(Uri.encodeFull(url1), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);
    setState(() {
      airport = resBody['data'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getStationList();
  }

  void reload() {
    setState(() {});
  }

  var finaldate;

  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      finaldate = order.toIso8601String();
    });
  }

  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Add Journey'),
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
                          hintText: 'Choose Mode of Travel',
                          labelText: 'Mode of Travel',
                        ),
                        isEmpty: _mode == null,
                        child: new DropdownButton<String>(
                          value: _mode,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              _mode = newValue;
                              reload();
                            });
                          },
                          items: _dropdownItems.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                _mode != null
                    ? Column(
                        children: [
                          DropdownButtonHideUnderline(
                            child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new InputDecorator(
                                    decoration: InputDecoration(
                                      filled: false,
                                      hintText: 'From',
                                      labelText: 'From',
                                    ),
                                    isEmpty: _mode == 'Train'
                                        ? _stationFrom == null
                                        : _airportFrom == null,
                                    child: _mode == 'Train'
                                        ? DropdownButton<String>(
                                            value: _stationFrom,
                                            isDense: true,
                                            onChanged: (String newValue) {
                                              setState(() {
                                                _stationFrom = newValue;
                                              });
                                            },
                                            items: stationCode.map((value) {
                                              return DropdownMenuItem<String>(
                                                value: value['code'],
                                                child: Text(value['name']),
                                              );
                                            }).toList(),
                                          )
                                        : DropdownButton<String>(
                                            value: _airportFrom,
                                            isDense: true,
                                            onChanged: (String newValue) {
                                              setState(() {
                                                _airportFrom = newValue;
                                              });
                                            },
                                            items: airport.map((value) {
                                              return DropdownMenuItem<String>(
                                                value: value['IATA_code'],
                                                child:
                                                    Text(value['airport_name']),
                                              );
                                            }).toList(),
                                          ),
                                  ),
                                ]),
                          ),

                          DropdownButtonHideUnderline(
                            child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new InputDecorator(
                                    decoration: InputDecoration(
                                      filled: false,
                                      hintText: 'To',
                                      labelText: 'To',
                                    ),
                                    isEmpty: _mode == 'Train'
                                        ? _stationTo == null
                                        : _airportTo == null,
                                    child: _mode == 'Train'
                                        ? DropdownButton<String>(
                                            value: _stationTo,
                                            isDense: true,
                                            onChanged: (String newValue) {
                                              setState(() {
                                                _stationTo = newValue;
                                              });
                                            },
                                            items: stationCode.map((value) {
                                              return DropdownMenuItem<String>(
                                                value: value['code'],
                                                child: Text(value['name']),
                                              );
                                            }).toList(),
                                          )
                                        : DropdownButton<String>(
                                            value: _airportTo,
                                            isDense: true,
                                            onChanged: (String newValue) {
                                              setState(() {
                                                _airportTo = newValue;
                                              });
                                            },
                                            items: airport.map((value) {
                                              return DropdownMenuItem<String>(
                                                value: value['IATA_code'],
                                                child:
                                                    Text(value['airport_name']),
                                              );
                                            }).toList(),
                                          ),
                                  ),
                                ]),
                          ),

                          // Date

                          SizedBox(
                            height: 8.0,
                          ),

                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              color: Colors.grey[850],
                              onPressed: callDatePicker,
                              child: Text('Select Journey Date'),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          finaldate != null
                              ? Text(finaldate)
                              : SizedBox(height: 0.0),
                          _mode == 'Train'
                              ? TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Enter Train No.: '),
                                  onSaved: (value) => {},
                                )
                              : _mode == 'Flight'
                                  ? TextFormField(
                                      decoration: InputDecoration(
                                          labelText: 'Enter refCode: '),
                                      onSaved: (value) => {},
                                    )
                                  : SizedBox(height: 10.0),

                          // Station code, From To, Date and dept
                          // For flight: F, depart_date, from, to, time,
                          SizedBox(height: 35),
                          _mode != null
                              ? RaisedButton(
                                  onPressed: () => {},
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(Icons.save),
                                      SizedBox(width: 8),
                                      Text('Save Journey'),
                                    ],
                                  ),
                                )
                              : SizedBox(height: 10.0),
                        ],
                      )
                    : SizedBox(
                        height: 10,
                      ),
              ],
            ),
          ),
        ));
  }
}
