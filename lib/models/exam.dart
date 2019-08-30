import 'package:flutter/material.dart';

class Exam {
  final int id;
  String description;
  DateTime examTime;

  Exam({@required this.description, @required this.examTime, @required this.id});
}
