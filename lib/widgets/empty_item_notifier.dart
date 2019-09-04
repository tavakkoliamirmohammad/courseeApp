import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmptyItemNotifier extends StatelessWidget {
  final String message;
  EmptyItemNotifier({@required this.message});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(FontAwesomeIcons.boxOpen, size: 70,),
          SizedBox(height: 25,),
          Text(message, textDirection: TextDirection.rtl, style: TextStyle(fontSize: 16), textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}
