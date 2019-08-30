import 'package:flutter/material.dart';
import 'package:sess_app/providers/course.dart';

class CourseListProvider with ChangeNotifier {
  List<Course> _courses = [];

  List<Course> get courses {
    return [..._courses];
  }

  Course findById(int courseId) {
    return _courses.firstWhere((course) {
      return course.id == courseId;
    });
  }

  void addCourse(int id, String title, String teacher, String place, String time,
      String sexuality, bool isEnrolled) {
    _courses.add(Course(
        id: id,
        title: title,
        teacher: teacher,
        place: place,
        sexuality: sexuality,
        time: time, isEnrolled: isEnrolled));
    notifyListeners();
  }
}
