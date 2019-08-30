import 'package:flutter/material.dart';

class CourseDetailItemAvatar extends StatelessWidget {
  final IconData icon;

  CourseDetailItemAvatar({@required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: Icon(icon, color: Colors.white,size: 30,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: LinearGradient(
          colors: const [
            Color(0xFFee0979),
            Color(0xFFff6a00),
          ],
        ),
      ),
      padding: const EdgeInsets.all(5),
    );
  }
}
