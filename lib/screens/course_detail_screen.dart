import 'package:flutter/material.dart';
import 'package:sess_app/providers/course.dart';
import 'package:sess_app/widgets/course_detail_exam.dart';
import 'package:sess_app/widgets/course_detail_list.dart';
import 'package:sess_app/widgets/course_detail_notes.dart';
import 'package:sess_app/widgets/modal_exam_note_modify.dart';

class CourseDetailScreen extends StatefulWidget {
  static final routeName = '/course-detail-screen';

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  int _currentPage = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final course = ModalRoute.of(context).settings.arguments as Course;

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
                    ),
                    CourseDetailExam(),
                    CourseDetailNote(
                      notes: course.notes,
                    ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_ind),
            title: Text("امتحانات"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text("یادداشت ها"),
          )
        ],
      ),
      floatingActionButton: _currentPage == 0
          ? null
          : FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (_) => ModalModifyExamNote(
                          afterSave: _currentPage == 1 ? course.addExam :course.addNote,
                          addType: _currentPage == 1
                              ? AddType.AddExam
                              : AddType.AddNote,
                        ),
                    isScrollControlled: true);
              },
              child: Icon(Icons.add),
            ),
    );
  }
}
