import 'package:flutter/material.dart';
import 'package:sess_app/models/course_note.dart';
import 'package:sess_app/models/exam.dart';

class Course with ChangeNotifier {
  final int id;
  final String title;
  final String teacher;
  final String place;
  final String sexuality;
  final String time;
  final List<CourseNote> notes = [
    CourseNote(dateTime: DateTime.now(), note: "سلام خوبین"
        "منم خوبم"),
    CourseNote(dateTime: DateTime.now(), note: "سلام خوبین"
        "منم خوبم"),
    CourseNote(dateTime: DateTime.now(), note: "سلام خوبین"
        "منم خوبم"),
  ];
  final List<Exam> exams = [];

  Course(
      {@required this.id,
      @required this.title,
      @required this.teacher,
      @required this.place,
      @required this.sexuality,
      @required this.time});

  void addNote(String note) {
    notes.add(CourseNote(note: note, dateTime: DateTime.now()));
    notifyListeners();
  }

  void addExam(String description, DateTime time){
    exams.add(Exam(description: description, examTime: time));
    notifyListeners();
  }
}
