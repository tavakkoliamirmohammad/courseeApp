import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/departments_provider.dart';
import 'package:sess_app/screens/course_detail_screen.dart';
import 'package:sess_app/screens/course_list.dart';
import 'package:sess_app/screens/department_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: DepartmentsProvider(),
      child: MaterialApp(
        title: 'Coursee',
        theme: ThemeData(
          fontFamily: 'iransans',
          brightness: Brightness.dark,
          primaryColor: Colors.red,
          accentColor: Color(0xFFdd1818),
          textTheme: TextTheme(
              title: TextStyle(color: Colors.white),
              body1: TextStyle(color: Colors.white),
              subtitle: TextStyle(color: Colors.grey)),
        ),
        home: DepartmentScreen(),
        routes: {
          CourseDetailScreen.routeName: (_) => CourseDetailScreen(),
          CourseList.routeName: (_) => CourseList()
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
