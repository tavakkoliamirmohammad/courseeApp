import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sess_app/models/course_note.dart';
import 'package:sess_app/models/exam.dart';
import 'package:http/http.dart' as http;

class Course with ChangeNotifier {
  final int id;
  final String title;
  final String teacher;
  final String place;
  final String sexuality;
  final String time;
  final int group;
  final String examTime;
  bool isEnrolled = false;

  List<CourseNote> notes;
  List<Exam> exams;

  Course(
      {@required this.id,
      @required this.title,
      @required this.teacher,
      @required this.place,
      @required this.sexuality,
      @required this.time,
      @required this.isEnrolled,
      @required this.notes,
      @required this.exams,
      @required this.group,
      @required this.examTime});

  void enroll() {
    this.isEnrolled = true;
    notifyListeners();
  }

  void unroll() {
    this.isEnrolled = false;
    this.notes = [];
    this.exams = [];
    notifyListeners();
  }

  Future<void> addNote(int courseId, String note, String token) async {
    final dateTime = DateTime.now();
    final res =
        await http.post("http://sessapp.moarefe98.ir/note/create/$courseId",
            body: json.encode({
              "text": note,
              "date": dateTime.toIso8601String(),
            }),
            headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": "Token " + token.toString(),
        });
    print(json.decode(res.body));
    print("add note");
    notes.add(CourseNote(
        id: json.decode(res.body)['pk'], note: note, dateTime: dateTime));
    print(json.decode(res.body)['pk']);
    notifyListeners();
  }

  Future<void> editNote(
      int id, String note, String token, DateTime dateTime) async {
    final res = await http.post("http://sessapp.moarefe98.ir/note/update/$id",
        body: json.encode({
          "text": note,
          "date": dateTime.toIso8601String(),
        }),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": "Token " + token.toString(),
        });
    print(json.decode(res.body));
    final index = notes.indexWhere((element) {
      return element.id == id;
    });
    if (index >= 0) {
      notes[index] =
          CourseNote(note: note, dateTime: notes[index].dateTime, id: id);
      notifyListeners();
    }
  }

  Future<void> deleteNote(int id, String token) async {
    final res = await http
        .post("http://sessapp.moarefe98.ir/note/delete/$id", headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Token " + token.toString(),
    });
    print("delete is");
    print(json.decode(res.body));
    notes.removeWhere((element) {
      return element.id == id;
    });
    notifyListeners();
  }

  Future<void> addExam(
      int courseId, String description, DateTime time, double grade, String token) async {
    final res =
        await http.post("http://sessapp.moarefe98.ir/exam/create/$courseId",
            body: json.encode({
              "title": description,
              "date": time.toIso8601String(),
              "grade": "0",
            }),
            headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": "Token " + token.toString(),
        });
    print(json.decode(res.body));
    exams.add(Exam(
        id: json.decode(res.body)['pk'],
        description: description,
        grade: grade,
        examTime: time));
    notifyListeners();
  }

  Future<void> editExam(
      int id, String description, DateTime time, double grade, String token) async {
    final res = await http.post("http://sessapp.moarefe98.ir/exam/update/$id",
        body: json.encode({
          "title": description,
          "date": time.toIso8601String(),
          "grade": grade,
        }),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": "Token " + token.toString(),
        });
    print(json.decode(res.body));
    final index = exams.indexWhere((element) {
      return element.id == id;
    });
    if (index >= 0) {
      exams[index] = Exam(description: description, examTime: time, grade: grade, id: id);
      notifyListeners();
    }
  }

  Future<void> deleteExam(int id, String token) async {
    final res = await http
        .post("http://sessapp.moarefe98.ir/exam/delete/$id", headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Token " + token.toString(),
    });
    print(json.decode(res.body));
    exams.removeWhere((element) {
      return element.id == id;
    });
    notifyListeners();
  }

  Future<List> getProfiles(Course course, String token) async {
    var response = await http
        .get("http://Sessapp.moarefe98.ir/course/${course.id}", headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Token " + token.toString(),
    });
    var courseDetails = List<Map<String, dynamic>>.from(
        jsonDecode(utf8.decode(response.bodyBytes)));
    print("profiles: " + courseDetails[0]['profiles'].toString());
    return courseDetails[0]['profiles'];

  }
}
