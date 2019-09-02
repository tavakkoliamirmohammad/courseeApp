import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/providers/department.dart';
import 'package:sess_app/screens/course_detail_screen.dart';
import 'package:sess_app/serachDelagate/course_search.dart';
import 'package:sess_app/widgets/course_list_item.dart';

class CourseList extends StatelessWidget {
  static final routeName = "/course-list-screen";

  @override
  Widget build(BuildContext context) {
    final department = ModalRoute.of(context).settings.arguments as Department;
    final auth = Provider.of<Auth>(context, listen: false);
    return FutureBuilder(
      future: department.fetchAndSetCourses(auth.token),
      builder: (_, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Scaffold(
                  appBar: AppBar(
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            showSearch(
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
                    padding: EdgeInsets.all(10),
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
