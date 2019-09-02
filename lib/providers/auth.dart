import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sess_app/providers/course.dart';
import 'package:sess_app/providers/department.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sess_app/providers/course_list_provider.dart';

class Auth with ChangeNotifier {
  String name;
  String token;
  String phoneNumber;
  Department department;

  bool get isAuth {
    return token != null;
  }

  Future<void> getVerificationCode(String phone, String urlSegment) async {
    final res = await http.post("http://sessapp.moarefe98.ir/$urlSegment",
        body: json.encode({
          'phone': phone,
        }),
        headers: {
          'Content-Type': 'application/json',
        });
    print("verify response");
    print(json.decode(res.body));
  }

  Future<void> signup(
      String phone, String verifyCode, String name, String departmentId) async {
    final res = await http.post("http://sessapp.moarefe98.ir/api-token-auth/",
        body: json.encode({
          'username': phone,
          'password': verifyCode,
        }),
        headers: {
          'Content-Type': 'application/json',
        });

    token = json.decode(res.body)['token'];
    if(token == null){
      return;
    }
    print(json.decode(res.body));
    final updateRes =
        await http.post("http://sessapp.moarefe98.ir/profile/update/",
            body: json.encode({
              "name": name,
              "department": departmentId,
              "picture": "",
            }),
            headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": "Token " + token.toString(),
        });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('authToken', token);
    notifyListeners();
  }

  Future<void> login(String phone, String verifyCode) async {
    final res = await http.post("http://sessapp.moarefe98.ir/api-token-auth/",
        body: json.encode({
          'username': phone,
          'password': verifyCode,
        }),
        headers: {
          'Content-Type': 'application/json',
        });

    token = json.decode(res.body)['token'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('authToken', token);
    print(json.decode(res.body));
    notifyListeners();
  }

  Future<bool> autoLogin() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("contains key: " + prefs.containsKey("authToken").toString());
      if (!prefs.containsKey("authToken")) {
        return false;
      }

      // add other information

      token = prefs.getString("authToken");
      notifyListeners();
      return true;

  }

  Future<void> logout() async {
    name = null;
    department = null;
    phoneNumber = null;
    token = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  Future<void> enrollCourse(Course course) async {
    final res = await http.post(
        "http://sessapp.moarefe98.ir/usercourse/create/${course.id}",
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": "Token " + token.toString(),
        });
    course.enroll();
  }

  Future<void> unrollCourse(Course course) async {
    final res = await http.post(
        "http://Sessapp.moarefe98.ir/usercourse/delete/${course.id}",
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": "Token " + token.toString(),
        });
    course.unroll();
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

  Future<List<Course>> fetchUserDetails() async {
    var response = await http
        .get("http://Sessapp.moarefe98.ir/profile", headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Token " + token.toString(),
    });
//    print(token);
    List<Course> courseList = [];
    var userInfo = List<Map<String, dynamic>>.from(
        jsonDecode(utf8.decode(response.bodyBytes)));
    print(userInfo);
    userInfo[0]['user_course'].forEach((courseData) {
      Map<String, String> timePlace = _formatTimePlace(courseData['course']['time_room']);
      courseList.add(Course(
        id: courseData['course']['pk'],
        time: timePlace['time'],
        teacher: _formatTeachersName(courseData['course']['teacher']),
        sexuality: courseData['course']['gender'],
        place: timePlace['place'],
        notes: courseData['course']['notes'],
        isEnrolled: true,
        group: int.parse(courseData['course']['group']),
        exams: courseData['course']['exam_dates'],
        title: courseData['course']['title'],
      ));
//      print(course);
    });
//    print("courses: " + courseList.toString());
    print(courseList);
    return courseList;
  }

  Future<List<Map<String, dynamic>>> getUserInfo() async {
    var response = await http
        .get("http://Sessapp.moarefe98.ir/profile", headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Token " + token.toString(),
    });
    return List<Map<String, dynamic>>.from(
        jsonDecode(utf8.decode(response.bodyBytes)));
  }

}
