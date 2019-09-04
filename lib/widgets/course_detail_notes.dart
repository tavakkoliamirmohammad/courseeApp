import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:persian_date/persian_date.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/providers/course.dart';
import 'package:sess_app/widgets/empty_item_notifier.dart';
import 'package:sess_app/widgets/modal_exam_note_modify.dart';

class CourseDetailNote extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final course = Provider.of<Course>(context);
    print("The length of course note is " + course.notes.length.toString());
    return course.notes.length == 0 ? EmptyItemNotifier(message: 'یادداشتی یافت نشد!',) : ListView.builder(
      itemBuilder: (_, i) => Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF093637), Color(0xFF44A08D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          child: ListTile(
            key: ValueKey(course.notes[i].id),
            title: Text(
              course.notes[i].note,
              textDirection: TextDirection.rtl,
            ),
            subtitle: Text(PersianDate().gregorianToJalali(
                course.notes[i].dateTime.toString(), "yyyy/mm/dd  HH:nn")),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              icon: Icons.delete,
              color: Colors.red,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(
                      "حذف؟",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 18),
                    ),
                    content: Text(
                      "آیا از حذف این مورد اطمینان دارید؟",
                      textDirection: TextDirection.rtl,
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("خیر", style: TextStyle(fontSize: 16)),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      FlatButton(
                        child: Text(
                          "بله",
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  ),
                ).then((value) {
                  if (value == true) {
                    course.deleteNote(
                        course.notes[i].id, Provider.of<Auth>(context).token);
                  }
                });
              },
            ),
            IconSlideAction(
              icon: Icons.edit,
              color: Colors.green,
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (_) => ModalModifyExamNote(
                          afterSave: (String note, String token) =>
                              course.editNote(course.notes[i].id, note, token,
                                  course.notes[i].dateTime),
                          type: Type.EditNote,
                          initialInfo: {"desciption": course.notes[i].note},
                        ),
                    isScrollControlled: true);
              },
            ),
          ],
        ),
      ),
      itemCount: course.notes.length,
    );
  }
}
