import 'package:flutter/material.dart';
import 'package:sess_app/providers/course.dart';
import 'package:sess_app/screens/course_detail_screen.dart';

class CourseListItem extends StatelessWidget {
  final Course course;

  CourseListItem({@required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        gradient: LinearGradient(colors: const [
//          Color(0xFF0575e6),
//          Color(0xFF021b79),
          Color(0xFF43C6AC),
          Color(0xFF191654)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Center(
        child: ListTile(
          onTap: () {
            Navigator.of(context)
                .pushNamed(CourseDetailScreen.routeName, arguments: course);
          },
          title: Text(
            course.title,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18),
            overflow: TextOverflow.fade,
            softWrap: true,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              course.teacher,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              softWrap: true,
              style:
                  TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
          ),
        ),
      ),
    );
  }
}
