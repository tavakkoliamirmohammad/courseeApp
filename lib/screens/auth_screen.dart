import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/departments_provider.dart';
import 'package:sess_app/widgets/auth_card.dart';

class AuthScreen extends StatelessWidget {
  static final routeName = "/auth-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<DepartmentsProvider>(context, listen: false)
            .fetchAndSetDepartments(),
        builder: (_, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : LayoutBuilder(
                builder: (ctx, constraint) => SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: constraint.maxWidth, minHeight: constraint.maxHeight),
                        child: Container(
                          decoration: BoxDecoration(
//                            gradiennt: LinearGradient(
//                                colors: [Color(0xFF004e92), Color(0xFF000428)],
//                                begin: Alignment.bottomCenter,
//                                end: Alignment.topCenter,
//                                stops: [0, 1]),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                child: Text("The logo"),
                              ),
                              AuthCard()
                            ],
                          ),
                        ),
                      ),
                    )),
      ),
    );
  }
}
