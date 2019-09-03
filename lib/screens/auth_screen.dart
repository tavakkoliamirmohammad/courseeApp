import 'package:flutter/material.dart';
import 'package:sess_app/widgets/auth_card.dart';

class AuthScreen extends StatelessWidget {
  static final routeName = "/auth-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
          builder: (ctx, constraint) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: constraint.maxWidth,
                      minHeight: constraint.maxHeight),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
//                            crossAxisAlignment: CrossAxisAlignment.stretch,
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
    );
  }
}
