import 'package:flutter/material.dart';

class TermsPolicyScreen extends StatelessWidget {
  static const routeName = '/terms_policy';
  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            routeArgs.containsKey('pp') ? 'Prviacy Policy' : 'Terms of Service'
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        child: Text(
          routeArgs.containsKey('pp') ? routeArgs['pp'] : routeArgs['tos']
        ),
      ),
    );
  }
}
