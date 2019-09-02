import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/departments_provider.dart';
import 'package:sess_app/screens/course_list.dart';
import 'package:sess_app/serachDelagate/department_search.dart';
import 'package:sess_app/widgets/department_item.dart';
import 'package:sess_app/widgets/main_drawer.dart';

class DepartmentScreen extends StatelessWidget {
  static final routeName = "/department-name";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<DepartmentsProvider>(context, listen: false)
          .fetchAndSetDepartments(),
      builder: (_, snapShot) => snapShot.connectionState ==
              ConnectionState.waiting
          ? Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : Scaffold(
              appBar: AppBar(
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => showSearch(
                            context: context,
                            delegate: DepartmentSearch(
                                departments:
                                    Provider.of<DepartmentsProvider>(context)
                                        .departments))
                        .then((value) {
                      if (value != null) {
                        Navigator.of(context).pushNamed(CourseList.routeName, arguments: value);
                      }
                    }),
                  )
                ],
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "نام بخش ها",
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.account_balance),
                  ],
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              drawer: MainDrawer(),
              body: Container(
                padding: EdgeInsets.all(10),
                child: Consumer<DepartmentsProvider>(
                  builder: (_, departments, child) => GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 250,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 1.5),
                    itemBuilder: (_, i) => DepartmentItem(
                      department: departments.departments[i],
                    ),
                    itemCount: departments.departments.length,
                  ),
                ),
              ),
            ),
    );
  }
}
