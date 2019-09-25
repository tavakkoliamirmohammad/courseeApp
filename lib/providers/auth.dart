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
    await http.post("http://sessapp.moarefe98.ir/$urlSegment",
        body: json.encode({
          'phone': phone,
        }),
        headers: {
          'Content-Type': 'application/json',
        });
  }

  Future<void> signup(String phone, String verifyCode, String name,
      String departmentId) async {
    final res = await http.post("http://sessapp.moarefe98.ir/api-token-auth/",
        body: json.encode({
          'username': phone,
          'password': verifyCode,
        }),
        headers: {
          'Content-Type': 'application/json',
        });

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

  Future<void> login(
      String phone, String verifyCode, DepartmentsProvider departments) async {
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
    final Map<String, dynamic> initialData = await fetchUserInitialInfo();
    name = initialData['name'];
    department = departments.findById(initialData['department']);
    image = initialData['picture'];
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
    final res = await http.post(
        "http://sessapp.moarefe98.ir/usercourse/create/${course.id}",
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": "Token " + token.toString(),
        });
    print(json.decode(res.body));
    course.enroll();
    notifyListeners();
  }

  Future<void> unrollCourse(Course course) async {
    try {
      await http.post(
          "http://Sessapp.moarefe98.ir/usercourse/delete/${course.id}",
          headers: {
            "Accept": "application/json",
            'Content-Type': 'application/json',
            "Authorization": "Token " + token.toString(),
          });
      course.unroll();
      notifyListeners();
    } catch (e) {
      throw e;
    }

//    userCourseList.courses.removeWhere((courseInList) => courseInList.id == course.id);
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

  String _formatFacultyName(String faculty) {
    if (faculty == null || faculty.isEmpty) {
      return faculty;
    }
    if (faculty[faculty.length - 1] == '*') {
      faculty = faculty.substring(0, faculty.length - 1);
    }
    return faculty;
  }

  Future<void> fetchUserDetails() async {
    print("called");
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
      print("userInfo: " + userInfo[0]['user_course'][0]['course']['unit'][12].toString());
      userInfo[0]['user_course'].forEach((courseData) {
        Map<String, String> timePlace =
            _formatTimePlace(courseData['course']['time_room']);
        List<CourseNote> notes = [];
        List<Exam> exams = [];
        List<Map<String, dynamic>> exNotes =
            List<Map<String, dynamic>>.from(courseData['notes']);
        List<Map<String, dynamic>> exExams =
            List<Map<String, dynamic>>.from(courseData['exam_dates']);
        print("exams: " + exExams.toString());
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
                  grade: double.parse(exam['grade'].toString()),
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
            courseData['course']['final_time'],
            courseData['course'] ['vahed'],
            _formatFacultyName(courseData['course']['unit']));
      });
//      notifyListeners();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future upload(File imageFile) async {
    if (imageFile == null) {
      print("reached");
      return;
    }
    String base64Image = base64Encode(imageFile.readAsBytesSync());
    print('baseImg: ' + base64Image);
//    String fileName = imageFile.path.split("/").last;
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

    print("response: " + response.body.toString());
  }

  Future<Map<String, dynamic>> fetchUserInitialInfo() async {
    var response =
        await http.get("http://Sessapp.moarefe98.ir/profile", headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Token " + token.toString(),
    });
    print(json.decode(utf8.decode(response.bodyBytes))[0]);
    return Map<String, dynamic>.from(
        json.decode(utf8.decode(response.bodyBytes))[0]);
  }

  Future<Map<String, dynamic>> fetchTermsPolicy() async {

    var response =
    await http.get("http://Sessapp.moarefe98.ir/policy", headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Token " + token.toString(),
    });
    print("Terms: " + json.decode(response.body).toString());
    return json.decode(response.body)[0];
  }

  Future<Map<String, dynamic>> fetchContact() async {

    var response =
    await http.get("http://Sessapp.moarefe98.ir/contact", headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Token " + token.toString(),
    });
    print("contact: " + json.decode(response.body).toString());
    return json.decode(response.body)[0];
  }

  List<Course> get userCourses {
    print("courses: " + userCourseList.courses.toString());
    return userCourseList.courses;
  }
}
