import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sess_app/widgets/course_detail_item.dart';

class CourseDetailList extends StatelessWidget {
  final String teacher;
  final String place;
  final String time;
  final String sexulaity;
  final int group;
  final String examTime;
  final String unit;
final String faculty;

  CourseDetailList({
    @required this.teacher,
    @required this.time,
    @required this.place,
    @required this.sexulaity,
    @required this.group,
    @required this.examTime,
    @required this.unit,
    @required this.faculty,
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
          title: "گروه",
          subtitle: group.toString(),
          icon: FontAwesomeIcons.users,
        ),
        CourseDetailItem(
          title: "ساعت کلاس",
          subtitle: time,
          icon: Icons.access_time,
        ),
        CourseDetailItem(
          title: "تاریخ امتحان",
          subtitle: examTime,
          icon: Icons.calendar_today,
        ),
        CourseDetailItem(
          title: "جنسیت",
          subtitle: sexulaity,
          icon: FontAwesomeIcons.venusMars,
        ),
        CourseDetailItem(
          title: "واحد",
          icon: Icons.format_list_numbered_rtl,
          subtitle: unit,
        ),
        CourseDetailItem(
          title: "بخش ها و رشته ها",
          icon: FontAwesomeIcons.bookReader,
          subtitle: faculty,
        )
      ],
    );
  }
}
