import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/providers/departments_provider.dart';
import 'package:sess_app/screens/about_us_screen.dart';
import 'package:sess_app/screens/auth_screen.dart';
import 'package:sess_app/screens/course_detail_screen.dart';
import 'package:sess_app/screens/course_list.dart';
import 'package:sess_app/screens/department_screen.dart';
import 'package:sess_app/screens/profile_screen.dart';
import 'package:sess_app/screens/report_screen.dart';
import 'package:sess_app/screens/terms_policy_screen.dart';
import 'package:sess_app/widgets/server_connection_error.dart';
import 'package:sess_app/screens/about_us_screen.dart';
import 'package:sess_app/screens/suggestion_screen.dart';

void main() {
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
          AboutUsScreen.routeName: (_) => AboutUsScreen(),
          TermsPolicyScreen.routeName: (_) => TermsPolicyScreen(),

          SuggestionScreen.routeName: (_) => SuggestionScreen(),
          ReportScreen.routeName: (_) => ReportScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _fetchAndSetDepartments;
  bool init = false;

  @override
  void didChangeDependencies() {
    if (!init) {
      _fetchAndSetDepartments =
          Provider.of<DepartmentsProvider>(context, listen: false)
              .fetchAndSetDepartments();
    }
//    init = true;
    super.didChangeDependencies();
  }

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
          : snapshot.hasError
              ? ServerConnectionError(
                  message: "خط در برقراری ارتباط با سرور",
                  onPressed: () async {
                    setState(() {
                      _fetchAndSetDepartments =
                          Provider.of<DepartmentsProvider>(context,
                                  listen: false)
                              .fetchAndSetDepartments();
                    });
                  })
              : (Consumer2<Auth, DepartmentsProvider>(
                  builder: (_, auth, deps, __) => auth.isAuth
                      ? ProfileScreen()
                      : FutureBuilder(
                          future: auth.autoLogin(deps),
                          builder: (_, snapshot) => snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? Scaffold(
                                  body: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : AuthScreen(
                                  departments: deps,
                                )))),
    );
  }
}
