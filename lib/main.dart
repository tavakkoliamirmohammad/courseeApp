import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/providers/departments_provider.dart';
import 'package:sess_app/screens/auth_screen.dart';
import 'package:sess_app/screens/course_detail_screen.dart';
import 'package:sess_app/screens/course_list.dart';
import 'package:sess_app/screens/department_screen.dart';
import 'package:sess_app/screens/profile_screen.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays(
    [],
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DepartmentsProvider>.value(
            value: DepartmentsProvider()),
        ChangeNotifierProvider<Auth>.value(value: Auth()),
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
        home: HomePage(),
        routes: {
          AuthScreen.routeName: (_) => AuthScreen(),
          DepartmentScreen.routeName: (_) => DepartmentScreen(),
          CourseDetailScreen.routeName: (_) => CourseDetailScreen(),
          CourseList.routeName: (_) => CourseList(),
          ProfileScreen.routeName: (_) => ProfileScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<DepartmentsProvider>(context, listen: false)
          .fetchAndSetDepartments(),
      builder: (_, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : (Consumer2<Auth, DepartmentsProvider>(
              builder: (_, auth, deps, __) => auth.isAuth
                  ? ProfileScreen()
                  : FutureBuilder(
                      future: auth.autoLogin(deps),
                      builder: (_, snapshot) => snapshot.connectionState ==
                              ConnectionState.waiting
                          ? Scaffold(
                              body: Center(child: CircularProgressIndicator()),
                            )
                          : AuthScreen()))),
    );
  }
}
