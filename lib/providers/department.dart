import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sess_app/providers/course_list_provider.dart';
import 'package:http/http.dart' as http;

class Department with ChangeNotifier {
  final int id;
  final String name;
  CourseListProvider courses = CourseListProvider();

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

  Future<void> fetchAndSetCourses() async {
    try {
      var response =
          await http.get("http://Sessapp.moarefe98.ir/departmentcourse/$id");

      var extractedDate = List<Map<String, dynamic>>.from(
          jsonDecode(utf8.decode(response.bodyBytes)));

      extractedDate.forEach((course) {
        var mapTimePlace = _formatTimePlace(course['time_room']);

        courses.addCourse(
            course['pk'],
            course['title'],
            _formatTeachersName(course['teacher']),
            mapTimePlace['place'],
            mapTimePlace['time'],
            course['gender']);
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
