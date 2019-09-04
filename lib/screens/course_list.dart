import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/providers/department.dart';
import 'package:sess_app/screens/course_detail_screen.dart';
import 'package:sess_app/serachDelagate/course_search.dart';
import 'package:sess_app/widgets/course_list_item.dart';
import 'package:sess_app/widgets/search_input.dart' as MySearchInput;
import 'package:sess_app/widgets/server_connection_error.dart';

class CourseList extends StatefulWidget {
  static final routeName = "/course-list-screen";

  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  Future<void> _fetchAndSetUserCourse;
  Department department;
  Auth auth;
  bool isInit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!isInit) {
      department = ModalRoute.of(context).settings.arguments as Department;
      auth = Provider.of<Auth>(context, listen: false);
      _fetchAndSetUserCourse = department.fetchAndSetCourses(auth.token);
    }
    isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchAndSetUserCourse,
      builder: (_, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : snapshot.hasError
              ? ServerConnectionError(
                  message: "خط در برقراری ارتباط با سرور",
                  onPressed: () {
                    setState(() {
                      _fetchAndSetUserCourse = department.fetchAndSetCourses(auth.token);
                    });
                  })
              : Scaffold(
                  resizeToAvoidBottomPadding: false,
                  appBar: AppBar(
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            MySearchInput.showSearch(
                                    cursorColor: Theme.of(context).accentColor,
                                    hintText: "جست و جو",
                                    context: context,
                                    delegate: CourseSearch(
                                        courses: department.courses.courses))
                                .then((value) {
                              if (value != null) {
                                Navigator.of(context).pushNamed(
                                    CourseDetailScreen.routeName,
                                    arguments: value);
                              }
                            });
                          })
                    ],
                    title: Text(
                      "دروس " + department.name,
                      textDirection: TextDirection.rtl,
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  body: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 1.5),
                      itemBuilder: (_, i) => CourseListItem(
                        course: department.courses.courses[i],
                      ),
                      itemCount: department.courses.courses.length,
                    ),
                  ),
                ),
    );
  }
}
