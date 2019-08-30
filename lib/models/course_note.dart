import 'package:flutter/material.dart';

class CourseNote{
  final int id;
  String note;
  final DateTime dateTime;

  CourseNote({@required this.note, @required this.dateTime, @required this.id});
}