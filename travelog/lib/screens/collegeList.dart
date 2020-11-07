import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class College {
  final String name;
  final int id;

  College({this.name, this.id});

  factory College.fromJson(Map<String, dynamic> json) {
    return new College(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
