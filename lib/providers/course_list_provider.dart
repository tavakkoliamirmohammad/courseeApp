import 'package:flutter/material.dart';
import 'package:sess_app/models/course_note.dart';
import 'package:sess_app/models/exam.dart';
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

  void addCourse(
      int id,
      String title,
      String teacher,
      String place,
      String time,
      String sexuality,
      bool isEnrolled,
      List<Exam> exams,
      List<CourseNote> notes,
      int group,
      String examTime,
      String unit,
      String faculty) {
    _courses.add(Course(
      id: id,
      title: title,
      teacher: teacher,
      place: place,
      sexuality: sexuality,
      time: time,
      isEnrolled: isEnrolled,
      exams: exams,
      notes: notes,
      group: group,
      examTime: examTime,
      unit: unit,
      faculty: faculty
    ));
    notifyListeners();
  }

  set userCourses(List<Course> courseList) {
    _courses = courseList;
  }
}
