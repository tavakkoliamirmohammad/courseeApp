import 'package:flutter/material.dart';
import 'package:sess_app/providers/department.dart';
import 'package:sess_app/screens/course_list.dart';

class DepartmentItem extends StatelessWidget {
  final Department department;

  DepartmentItem({@required this.department});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        gradient: LinearGradient(colors: const [
          Color(0xFF8a2387),
          Color(0xFFE94057),
          Color(0xFFf27121),
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Center(
        child: ListTile(
          onTap: () {
            Navigator.of(context)
                .pushNamed(CourseList.routeName, arguments: department);
          },
          title: Text(
            department.name,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 20),
            overflow: TextOverflow.fade,
            softWrap: true,
          ),
        ),
      ),
    );
  }
}
