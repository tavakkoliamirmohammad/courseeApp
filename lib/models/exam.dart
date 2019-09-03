import 'package:flutter/material.dart';

class Exam {
  final int id;
  String description;
  DateTime examTime;
  double grade;

  Exam(
      {@required this.description,
      @required this.examTime,
      @required this.id,
      this.grade});
}
