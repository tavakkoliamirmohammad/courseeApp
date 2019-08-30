import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sess_app/providers/course.dart';
import 'package:sess_app/providers/department.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    print(token);

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
    print(json.decode(updateRes.body));

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
    print(token);
    notifyListeners();
  }

  Future<bool> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
    print(json.decode(res.body));
  }

  Future<void> unrollCourse(Course course) async {
    final res = await http.post(
        "http://Sessapp.moarefe98.ir/usercourse/delete/${course.id}",
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": "Token " + token.toString(),
        });
    print(res.statusCode);
    course.unroll();

  }
}