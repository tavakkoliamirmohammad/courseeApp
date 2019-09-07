import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/providers/course.dart';
import 'package:sess_app/widgets/modal_exam_note_modify.dart';
import 'package:persian_date/persian_date.dart';
import 'package:sess_app/widgets/empty_item_notifier.dart';
import 'package:sess_app/models/exam.dart';

class CourseDetailExam extends StatefulWidget {
  final Function listKeyHandler;
  CourseDetailExam({this.listKeyHandler});
  @override
  _CourseDetailExamState createState() => _CourseDetailExamState();
}

class _CourseDetailExamState extends State<CourseDetailExam> {
  GlobalKey<AnimatedListState> _listKey = GlobalKey();
  Widget _buildItem(Exam item, Animation animation) {
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
              item.description,
              textDirection: TextDirection.rtl,
            ),
            subtitle: Text(PersianDate().gregorianToJalali(
                item.examTime.toString(), "yyyy/mm/dd  HH:nn")),
          ),

        )
    );
  }
  Function updateListKey(keyValue) => _listKey = keyValue;
  @override
  Widget build(BuildContext context) {
    widget.listKeyHandler(_listKey);
    final course = Provider.of<Course>(context);
    return course.exams.length == 0 ? EmptyItemNotifier(message: 'امتحانی یافت نشد!') : AnimatedList(
      key: _listKey,
      itemBuilder: (_, i, animation) => Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF159957), Color(0xFF155799)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          child: ListTile(
            key: ValueKey(course.exams[i].id),
            title: Text(
              course.exams[i].description,
              textDirection: TextDirection.rtl,
            ),
            subtitle: Text(PersianDate().gregorianToJalali(
                course.exams[i].examTime.toString(), "yyyy/mm/dd  HH:nn")),
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
                    int index = course.exams.indexWhere((exam) => exam.id == course.exams[i].id);
                    AnimatedListRemovedItemBuilder builder = (context, animation) {
                      // A method to build the Card widget.
                      return _buildItem(course.exams[i], animation);
                    };
                    setState(() {
                      _listKey.currentState.removeItem(index, builder);
                      course.deleteExam(
                          course.exams[i].id, Provider.of<Auth>(context).token);
                    });
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
                    builder: (_) {
                      final dateTime = PersianDate(
                          gregorian: course.exams[i].examTime.toString());
                      return ModalModifyExamNote(
                        afterSave:
                            (String note, DateTime dateTime, double grade, String token) =>
                                course.editExam(
                          course.exams[i].id,
                          note,
                          dateTime,
                          grade,
                          token,
                        ),
                        type: Type.EditExam,
                        initialInfo: {
                          "desciption": course.exams[i].description,
                          "year": dateTime.year.toString(),
                          "month": dateTime.month.toString(),
                          "day": dateTime.day.toString(),
                          "hour": dateTime.hour.toString(),
                          "minute": dateTime.minute.toString(),
                          'grade': course.exams[i].grade.toString(),
                        },
                      );
                    },
                    isScrollControlled: true);
              },
            ),
          ],
        ),
      ),
      initialItemCount: course.exams.length,
    );
  }
}
