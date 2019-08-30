import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/providers/departments_provider.dart';
import 'package:sess_app/screens/auth_screen.dart';
import 'package:sess_app/screens/course_detail_screen.dart';
import 'package:sess_app/screens/course_list.dart';
import 'package:sess_app/screens/department_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: DepartmentsProvider()),
        ChangeNotifierProvider.value(value: Auth()),
      ],
      child: MaterialApp(
        title: 'Coursee',
        theme: ThemeData(
          fontFamily: 'iransans',
          brightness: Brightness.dark,
          primarySwatch: Colors.orange,
          accentColor: Color(0xFFdd1818),
          textTheme: TextTheme(
              title: TextStyle(color: Colors.white),
              body1: TextStyle(color: Colors.white),
              subtitle: TextStyle(color: Colors.grey)),
        ),
        home: Consumer<Auth>(
            builder: (_, auth, __) => auth.isAuth
                ? DepartmentScreen()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (_, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? Center(child: CircularProgressIndicator())
                            : AuthScreen())),
        routes: {
          AuthScreen.routeName: (_) => AuthScreen(),
          DepartmentScreen.routeName: (_) => DepartmentScreen(),
          CourseDetailScreen.routeName: (_) => CourseDetailScreen(),
          CourseList.routeName: (_) => CourseList()
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}