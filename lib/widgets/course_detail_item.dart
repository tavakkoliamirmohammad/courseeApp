import 'package:flutter/material.dart';
import 'package:sess_app/widgets/course_detail_item_avatar.dart';

class CourseDetailItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  CourseDetailItem(
      {@required this.title, @required this.subtitle, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        gradient: LinearGradient(
            colors: const [Color(0xFF4b6cb7), Color(0xFF182848)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: ListTile(
        title: Text(
          title,
          textDirection: TextDirection.rtl,
          style: TextStyle(
              color: Theme.of(context).textTheme.body1.color, fontSize: 20),
        ),
        trailing: CourseDetailItemAvatar(
          icon: icon,
        ),
        subtitle: Text(
          subtitle,
          textDirection: TextDirection.rtl,
          style: TextStyle(
              color: Theme.of(context).textTheme.subtitle.color, fontSize: 18),
        ),
      ),
    );
  }
}
