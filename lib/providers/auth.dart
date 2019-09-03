import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sess_app/models/course_note.dart';
import 'package:sess_app/models/exam.dart';
import 'package:sess_app/providers/course.dart';
import 'package:sess_app/providers/department.dart';
import 'package:http/http.dart' as http;
import 'package:sess_app/providers/departments_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sess_app/providers/course_list_provider.dart';

class Auth with ChangeNotifier {
  String name;
  String token;
  String image;
  String phoneNumber;
  Department department;
  CourseListProvider userCourseList;

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
    final extractedResponse = json.decode(utf8.decode(res.bodyBytes));
    if (extractedResponse['status'] != 200) {
      throw HttpException(extractedResponse['text']);
    }
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
    if (json.decode(res.body)['non_field_errors'] != null) {
      throw HttpException("کد وارد شده معتیر نمی باشد. لطفا دوباره سعی کنید.");
    }
    token = json.decode(res.body)['token'];
    if (token == null) {
      return;
    }
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
    if (json.decode(res.body)['non_field_errors'] != null) {
      throw HttpException("کد وارد شده معتیر نمی باشد. لطفا دوباره سعی کنید.");
    }
    token = json.decode(res.body)['token'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('authToken', token);
    notifyListeners();
  }

  Future<bool> autoLogin(DepartmentsProvider departments) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("authToken")) {
      return false;
    }
    // add other information
    token = prefs.getString("authToken");
    final Map<String, dynamic> initialData = await fetchUserInitialInfo();
    name = initialData['name'];
    department = departments.findById(initialData['department']);
    image = initialData['picture'];
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
    await http.post(
        "http://sessapp.moarefe98.ir/usercourse/create/${course.id}",
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": "Token " + token.toString(),
        });
    course.enroll();
    notifyListeners();
  }

  Future<void> unrollCourse(Course course) async {
    await http.post(
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

  Future<void> fetchUserDetails() async {
    try {
      var response =
          await http.get("http://Sessapp.moarefe98.ir/profile", headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json',
        "Authorization": "Token " + token.toString(),
      });
      userCourseList = CourseListProvider();
      var userInfo = List<Map<String, dynamic>>.from(
          jsonDecode(utf8.decode(response.bodyBytes)));

      userInfo[0]['user_course'].forEach((courseData) {
        Map<String, String> timePlace =
            _formatTimePlace(courseData['course']['time_room']);

        List<CourseNote> notes = [];
        List<Exam> exams = [];
        List<Map<String, dynamic>> exNotes =
            List<Map<String, dynamic>>.from(courseData['notes']);
        List<Map<String, dynamic>> exExams =
            List<Map<String, dynamic>>.from(courseData['exam_dates']);
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
        userCourseList.addCourse(
            courseData['course']['pk'],
            courseData['course']['title'],
            _formatTeachersName(courseData['course']['teacher']),
            timePlace['place'],
            timePlace['time'],
            courseData['course']['gender'],
            true,
            exams,
            notes,
            int.parse(courseData['course']['group']),
            courseData['course']['final_time']);
      });
      notifyListeners();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future upload(File imageFile) async {
    if (imageFile == null) {
      return;
    }
    String base64Image = base64Encode(imageFile.readAsBytesSync());
    final response =
        await http.post('http://sessapp.moarefe98.ir/profile/update/',
            body: json.encode({
              'name': name,
              'phone': phoneNumber,
              'picture': base64Image,
              'department': department.id,
            }),
            headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": "Token " + token.toString(),
        });
    image = base64Image;
    print(json.decode(response.body));
  }

  Future<Map<String, dynamic>> fetchUserInitialInfo() async {
    var response =
        await http.get("http://Sessapp.moarefe98.ir/profile", headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Token " + token.toString(),
    });
    return Map<String, dynamic>.from(
        json.decode(utf8.decode(response.bodyBytes))[0]);
  }

  List<Course> get userCourses {
    return userCourseList.courses;
  }
}
