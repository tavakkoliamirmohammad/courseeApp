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

  Widget _buildFloatingActionBarButton(BuildContext ctx, Auth auth) {
    if (_currentPage == 0) {
      return FloatingActionButton(
        child: Icon(!isEnrolled
            ? FontAwesomeIcons.userPlus
            : FontAwesomeIcons.userMinus),
        onPressed: !isEnrolled
            ? () {
                auth.enrollCourse(course);
                setState(() {
                  isEnrolled = true;
                });
                Scaffold.of(ctx).removeCurrentSnackBar();
                Scaffold.of(ctx)
                    .showSnackBar(SnackBar(content: Text("درس اضافه شد")));
              }
            : () {
                auth.unrollCourse(course);
                setState(() {
                  isEnrolled = false;
                });
                Scaffold.of(ctx).removeCurrentSnackBar();
                Scaffold.of(ctx)
                    .showSnackBar(SnackBar(content: Text("از درس ها حذف شد")));
              },
      );
    }

    if (_currentPage == 3 || !isEnrolled) {
      return Container();
    }
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (_) => ModalModifyExamNote(
                  afterSave: _currentPage == 1
                      ? (String note, DateTime dateTime, String token) =>
                          course.addExam(course.id, note, dateTime, token)
                      : (String note, String token) =>
                          course.addNote(course.id, note, token),
                  type: _currentPage == 1 ? Type.AddExam : Type.AddNote,
                ),
            isScrollControlled: true);
      },
      child: Icon(Icons.add),
    );
  }

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
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text("توضیحات"),
                ),
                if(isEnrolled) BottomNavigationBarItem(
                  icon: Icon(Icons.assignment_ind),
                  title: Text("امتحانات"),
                ) ,
                if(isEnrolled) BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.stickyNote),
                  title: Text("یادداشت ها"),
                ) ,
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
