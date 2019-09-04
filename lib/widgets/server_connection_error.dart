import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServerConnectionError extends StatelessWidget {
  final String message;
  final Function onPressed;

  ServerConnectionError({@required this.message, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.exclamationTriangle,
              color: Colors.red,
              size: 70,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              message,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 100,
              child: RaisedButton(
                elevation: 0,
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(20)),
                onPressed: this.onPressed,
                child: Text(
                  "تلاش مجدد",
                  textDirection: TextDirection.rtl,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
