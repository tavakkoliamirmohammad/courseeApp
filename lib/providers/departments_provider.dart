import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sess_app/providers/course.dart';
import 'package:sess_app/providers/department.dart';
import 'package:http/http.dart' as http;

class DepartmentsProvider with ChangeNotifier {
  List<Department> _departments = [];

  List<Department> get departments {
    return [..._departments];
  }

  Future<void> fetchAndSetDepartments() async {
    var response =
        await http.get("http://sessapp.moarefe98.ir/department/__all__");
    var extractedDate = List<Map<String, dynamic>>.from(
        jsonDecode(utf8.decode(response.bodyBytes)));
    final List<Department> extractedList = [];
    extractedDate.forEach((dep) {
      extractedList.add(Department(id: dep['id'], name: dep['title']));
    });
    _departments = extractedList;
    notifyListeners();
  }

  Department findById(int id){
    return _departments.firstWhere((department){
      return department.id == id;
    });
  }
}
