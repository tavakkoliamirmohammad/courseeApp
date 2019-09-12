import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:persian_date/persian_date.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/providers/course.dart';
import 'package:sess_app/widgets/empty_item_notifier.dart';
import 'package:sess_app/widgets/modal_exam_note_modify.dart';
import 'package:sess_app/models/course_note.dart';

class CourseDetailNote extends StatefulWidget {
  @override
  _CourseDetailNoteState createState() => _CourseDetailNoteState();
}

class _CourseDetailNoteState extends State<CourseDetailNote>
    with TickerProviderStateMixin {
//  AnimationController _controller;
//  Animation<Offset> _offsetFloat;
//
//  @override
//  void initState() {
//    super.initState();
//    _controller = AnimationController(
//      vsync: this,
//      duration: const Duration(seconds: 3),
//    );
//    _offsetFloat = Tween<Offset>(begin: Offset(2.0, 0.0,), end: Offset.zero)
//        .animate(_controller);
//    _offsetFloat.addListener((){
//      setState((){});
//    });
//
//    _controller.forward();
//
//  }

  Widget _buildItem(CourseNote item, Animation animation) {
    return SizeTransition(
        sizeFactor: animation,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.red, Colors.deepOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: ListTile(
            key: ValueKey(item.id),
            title: Text(
              item.note,
              textDirection: TextDirection.rtl,
            ),
            subtitle: Text(PersianDate().gregorianToJalali(
                item.dateTime.toString(), "yyyy/mm/dd  HH:nn")),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final course = Provider.of<Course>(context);
    print("The length of course note is " + course.notes.length.toString());
    return course.notes.length == 0
        ? EmptyItemNotifier(
            message: 'یادداشتی یافت نشد!',
          )
        : ListView.builder(
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
                      course.notes[i].dateTime.toString(),
                      "yyyy/mm/dd  HH:nn")),
                ),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    icon: Icons.delete,
                    color: Colors.red,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
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
                              child:
                                  Text("خیر", style: TextStyle(fontSize: 16)),
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
                          course.deleteNote(course.notes[i].id,
                              Provider.of<Auth>(context).token);
                          print("before");
                          print(course.notes.length);
                          print("after");
                          print(course.notes.length);
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
                          builder: (context) => ModalModifyExamNote(
                                afterSave: (String note, String token) =>
                                    course.editNote(course.notes[i].id, note,
                                        token, course.notes[i].dateTime),
                                type: Type.EditNote,
                                initialInfo: {
                                  "desciption": course.notes[i].note
                                },
                              ),
                          isScrollControlled: true);
                      setState(() {
                        
                      });
                    },
                  ),
                ],
              ),
            ),
            itemCount: course.notes.length,
          );
  }
}
