import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/providers/department.dart';
import 'package:sess_app/widgets/course_list_item.dart';

class CourseList extends StatelessWidget {
  static final routeName = "/course-list-screen";

  @override
  Widget build(BuildContext context) {
    final department = ModalRoute.of(context).settings.arguments as Department;
    final auth = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
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
        child: FutureBuilder(
          future: department.fetchAndSetCourses(auth.token),
          builder: (_, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : GridView.builder(
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
