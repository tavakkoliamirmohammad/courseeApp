import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/providers/course.dart';
import 'package:sess_app/widgets/course_detail_exam.dart';
import 'package:sess_app/widgets/course_detail_list.dart';
import 'package:sess_app/widgets/course_detail_notes.dart';
import 'package:sess_app/widgets/course_detail_participants.dart';
import 'package:sess_app/widgets/modal_exam_note_modify.dart';

class CourseDetailScreen extends StatefulWidget {
  static final routeName = '/course-detail-screen';

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  int _currentPage = 0;
  PageController _pageController;
  bool isEnrolled;
  bool isInit = false;
  Course course;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  void didChangeDependencies() {
    if (!isInit) {
      course = ModalRoute.of(context).settings.arguments as Course;
      isEnrolled = course.isEnrolled;
      isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _showErrorSnackBar(BuildContext ctx, String message) {
    Scaffold.of(ctx).removeCurrentSnackBar();
    Scaffold.of(ctx).showSnackBar(SnackBar(
      content: Row(
        textDirection: TextDirection.rtl,
        children: <Widget>[
          Icon(
            FontAwesomeIcons.exclamationTriangle,
            color: Colors.red,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            message,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
      duration: Duration(seconds: 1),
    ));
  }

  Widget _buildFloatingActionBarButton(BuildContext ctx, Auth auth) {
    if (_currentPage == 0) {
      return FloatingActionButton(
        child: Icon(!isEnrolled
            ? FontAwesomeIcons.userPlus
            : FontAwesomeIcons.userMinus),
        onPressed: !isEnrolled
            ? () async {
                try {
                  await auth.enrollCourse(course);
                  setState(() {
                    isEnrolled = true;
                  });
                  Scaffold.of(ctx).removeCurrentSnackBar();
                  Scaffold.of(ctx).showSnackBar(SnackBar(
                    content: Row(
                      textDirection: TextDirection.rtl,
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "به درس های شما اضافه شد",
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                    duration: Duration(seconds: 1),
                  ));
                } catch (e) {
                  _showErrorSnackBar(ctx, "خطا در برقراری ارتباط با سرور");
                }
              }
            : () async {
                try {
                  await auth.unrollCourse(course);
                  setState(() {
                    isEnrolled = false;
                  });
                  Scaffold.of(ctx).removeCurrentSnackBar();
                  Scaffold.of(ctx).showSnackBar(SnackBar(
                    content: Row(
                      textDirection: TextDirection.rtl,
                      children: <Widget>[
                        Icon(
                          Icons.remove,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "از درس هایتان حذف شد",
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                    duration: Duration(seconds: 1),
                  ));
                } catch (e) {
                  _showErrorSnackBar(ctx, "خطا در برقراری ارتباط با سرور");                }
              },
      );
    }

    if (_currentPage == 3 || !isEnrolled) {
      return Container();
    }
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
            context: context,
            builder: (_) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: ModalModifyExamNote(
                afterSave: _currentPage == 1
                    ? (String note, DateTime dateTime, double grade,
                    String token) =>
                    course.addExam(
                        course.id, note, dateTime, grade, token)
                    : (String note, String token) =>
                    course.addNote(course.id, note, token),
                type: _currentPage == 1 ? Type.AddExam : Type.AddNote,
              ),
            );
            }
            );
      },
      child: Icon(Icons.add),

    );
  }
  GlobalKey<AnimatedListState> _listKey = GlobalKey();
  function(val) => _listKey = val;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text(course.title),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Expanded(
              child: Container(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: <Widget>[
                    CourseDetailList(
                      place: course.place,
                      sexulaity: course.sexuality,
                      teacher: course.teacher,
                      time: course.time,
                      group: course.group,
                      examTime: course.examTime,
                      unit: course.unit,
                      faculty: course.faculty,
                    ),
                    if (isEnrolled)
                      ChangeNotifierProvider<Course>.value(
                        child: CourseDetailExam(),
                        value: course,
                      ),
                    if (isEnrolled)
                      ChangeNotifierProvider<Course>.value(
                        child: CourseDetailNote(),
                        value: course,
                      ),
                    ChangeNotifierProvider<Course>.value(
                      child: CourseDetailParticipants(),
                      value: course,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _currentPage,
        onTap: (page) {
          _pageController.animateToPage(page,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("توضیحات"),
          ),
          if (isEnrolled)
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_ind),
              title: Text("امتحانات"),
            ),
          if (isEnrolled)
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.stickyNote),
              title: Text("یادداشت ها"),
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('دانشجویان'),
          ),
        ],
      ),
      floatingActionButton: Consumer<Auth>(
        builder: (_, auth, child) => Builder(
            builder: (BuildContext ctx) =>
                _buildFloatingActionBarButton(ctx, auth)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
