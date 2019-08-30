import 'package:flutter/material.dart';
import 'package:sess_app/widgets/course_detail_item.dart';

class CourseDetailList extends StatelessWidget {
  final String teacher;
  final String place;
  final String time;
  final String sexulaity;

  CourseDetailList({
    @required this.teacher,
    @required this.time,
    @required this.place,
    @required this.sexulaity,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        CourseDetailItem(
          title: "نام استاد",
          subtitle: teacher,
          icon: Icons.person,
        ),
        CourseDetailItem(
          title: "مکان کلاس",
          subtitle: place,
          icon: Icons.account_balance,
        ),
        CourseDetailItem(
          title: "ساعت کلاس",
          subtitle: time,
          icon: Icons.access_time,
        ),
        CourseDetailItem(
          title: "جنسیت",
          subtitle: sexulaity,
          icon: Icons.people,
        ),
      ],
    );
  }
}
