import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final message;
  final ctx;
  ErrorDialog({@required this.message, @required BuildContext this.ctx});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      title:
      Row(
        textDirection: TextDirection.rtl,
        children: <Widget>[
          Icon(Icons.error_outline),
          SizedBox(width: 10,),
          Text(
            "خطا",
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(message, textDirection: TextDirection.rtl,),
          SizedBox(height: 20,),
          RaisedButton(
            color: Colors.green,
            child: Text(
              "باشه",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
