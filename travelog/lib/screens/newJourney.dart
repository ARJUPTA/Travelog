import 'package:flutter/material.dart';

class AddJourney extends StatefulWidget {
  @override
  _AddJourneyState createState() => _AddJourneyState();
}

class _AddJourneyState extends State<AddJourney> {
  static final List<String> _dropdownItems = <String>['Train', 'Flight', 'Bus'];
  String _mode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back),
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
                TextFormField(
                  decoration: InputDecoration(labelText: 'PNR No.'),
                  onSaved: (value) => {},
                ),
                SizedBox(height: 35),
                RaisedButton(
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
              ],
            ),
          ),
        ));
  }
}
