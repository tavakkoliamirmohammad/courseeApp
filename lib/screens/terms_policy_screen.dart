import 'package:flutter/material.dart';

import 'package:flutter_html_view/flutter_html_view.dart';

class TermsPolicyScreen extends StatelessWidget {
  static const routeName = '/terms_policy';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(routeArgs.containsKey('pp')
            ? 'Prviacy Policy'
            : 'Terms of Service'),
      ),
      body: Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.all(10.0),
          child: Theme(
            data: Theme.of(context).copyWith(
                textTheme: TextTheme(body1: TextStyle(fontFamily: "Lato"))),
            child: HtmlView(
              data: routeArgs.containsKey('pp')
                  ? routeArgs['pp']
                  : routeArgs['tos'],
            ),
          )),
    );
  }
}
