import 'package:flutter/material.dart';
import 'package:persian_date/persian_date.dart';
import 'package:sess_app/models/course_note.dart';

class CourseDetailNote extends StatelessWidget {
  final List<CourseNote> notes;

  CourseDetailNote({@required this.notes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (_, i) => Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF093637), Color(0xFF44A08D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: ListTile(
          title: Text(
            notes[i].note,
            textDirection: TextDirection.rtl,
          ),
          subtitle: Text(PersianDate().gregorianToJalali(notes[i].dateTime.toString(), "yyyy/mm/dd  hh:nn")),
        ),
      ),
      itemCount: notes.length,
    );
  }
}
