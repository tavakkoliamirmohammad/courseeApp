import 'dart:convert';

import 'package:flutter/material.dart';
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

//      print(enrolledCourses);
      courses = CourseListProvider();
      extractedDate.forEach((course) {
        bool isEnrolled = false;
        var mapTimePlace = _formatTimePlace(course['time_room']);
        for (var i = 0; i < enrolledCourses.length; ++i) {
          if (enrolledCourses[i]['course']['pk'] == course['pk']) {
            isEnrolled = true;
            break;
          }
        }
        courses.addCourse(
            course['pk'],
            course['title'],
            _formatTeachersName(course['teacher']),
            mapTimePlace['place'],
            mapTimePlace['time'],
            course['gender'],
            isEnrolled);
      });
      print("course length is " + courses.courses.length.toString());
    } catch (e) {
      print(e.toString());
    }
  }
}
