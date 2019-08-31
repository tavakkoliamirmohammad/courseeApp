import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sess_app/models/course_note.dart';
import 'package:sess_app/models/exam.dart';
import 'package:sess_app/providers/course_list_provider.dart';
import 'package:http/http.dart' as http;

class Department with ChangeNotifier {
  final int id;
  final String name;
  CourseListProvider courses;

  Department({@required this.id, @required this.name});

  String _formatTeachersName(String courseTeacher) {
    final splittedTeacherName = courseTeacher.split("*");
    splittedTeacherName.removeLast();

    var teachersName = "";
    for (var i = 0; i < splittedTeacherName.length; i += 3) {
      if (i != 0) {
        teachersName += "\n";
      }
      teachersName += splittedTeacherName[i + 1];
      teachersName += " ";
      teachersName += splittedTeacherName[i];
    }
    return teachersName;
  }

  Map<String, String> _formatTimePlace(String timePlace) {
    Map<String, String> timePlaceMap = {};

    var splittedTP = timePlace.replaceAll(RegExp("[()]"), "||").split("\n");
    List<String> place = [];
    List<String> time = [];
    for (var i = 0; i < splittedTP.length; i += 1) {
      var splittedItem = splittedTP[i].split("||");
      splittedItem.removeLast();
      for (var j = 0; j < splittedItem.length; j += 2) {
        time += [splittedItem[0]];
        place += [splittedItem[1]];
      }
    }

    timePlaceMap['time'] = time.join("\n").replaceAll("-", " ");
    timePlaceMap['place'] = place.join("\n");
    return timePlaceMap;
  }

  Future<void> fetchAndSetCourses(String token) async {
    try {
      var response = await http
          .get("http://Sessapp.moarefe98.ir/departmentcourse/$id", headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json',
        "Authorization": "Token " + token.toString(),
      });

      var extractedDate = List<Map<String, dynamic>>.from(
          jsonDecode(utf8.decode(response.bodyBytes)));

      var enrollRes = await http
          .get("http://sessapp.moarefe98.ir/usercourse/__all__", headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json',
        "Authorization": "Token " + token.toString(),
      });

      var enrolledCourses = List<Map<String, dynamic>>.from(
          jsonDecode(utf8.decode(enrollRes.bodyBytes)));

      courses = CourseListProvider();
      extractedDate.forEach((course) {
        bool isEnrolled = false;
        int index = -1;
        var mapTimePlace = _formatTimePlace(course['time_room']);
        for (var i = 0; i < enrolledCourses.length; ++i) {
          if (enrolledCourses[i]['course']['pk'] == course['pk']) {
            index = i;
            isEnrolled = true;
            break;
          }
        }
        List<CourseNote> notes = [];
        List<Exam> exams = [];

        if (index != -1) {
          List<Map<String, dynamic>> exNotes =
              List<Map<String, dynamic>>.from(enrolledCourses[index]['notes']);
          List<Map<String, dynamic>> exExams = List<Map<String, dynamic>>.from(
              enrolledCourses[index]['exam_dates']);
          notes = exNotes
              .map((note) => CourseNote(
                  note: note['text'],
                  dateTime: DateTime.parse(note['date']),
                  id: note['pk']))
              .toList();
          exams = exExams
              .map((exam) => Exam(
                    description: exam['title'],
                    examTime: DateTime.parse(exam['date']),
                    id: exam['id'],
                  ))
              .toList();
        }
        courses.addCourse(
            course['pk'],
            course['title'],
            _formatTeachersName(course['teacher']),
            mapTimePlace['place'],
            mapTimePlace['time'],
            course['gender'],
            isEnrolled,
            exams,
            notes,
            int.parse(course['group']));
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
