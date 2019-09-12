import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sess_app/providers/auth.dart';

class SuggestionScreen extends StatefulWidget {
  static const routeName = '/suggestion';
  @override
  _SuggestionScreenState createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  TextEditingController _suggestionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  var authData;
  String suggestion = '';

  @override
  void initState() {
    // TODO: implement initState
    authData = Provider.of<Auth>(context, listen: false);
    super.initState();
  }

  Future<void> _saveForm() async {
//    const url = 'http://sessapp.moarefe98.ir/profile/report/create';
    var response = await http.post(
        'http://sessapp.moarefe98.ir/report/create/',
      body: json.encode({
        "text": suggestion.toString(),
      }),
      headers: {
    "Accept": "application/json",
    'Content-Type': 'application/json',
    "Authorization": "Token " + authData.token.toString(),
    });
    print(response.statusCode);
    print(response.body);
    print("sugg code: " + json.decode(response.body).toString());
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('ثبت انتقادات و پیشنهادات'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            width: deviceSize.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      maxLines: 3,
                      controller: _suggestionController,
                      cursorColor: Theme.of(context).accentColor,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        labelText: 'انتقاد یا پیشنهاد',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onFieldSubmitted: (value) async {
                        suggestion = value;
                        await _saveForm();
                      },
                      onSaved: (value) async {
                        suggestion = value;
                        await _saveForm();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 25,),
                FlatButton(
                  color: Theme.of(context).accentColor,
                  onPressed: () async {
                    suggestion = _suggestionController.text;
                    await _saveForm();
                    Navigator.of(context).pop();
                  },
                  child: Text('ارسال', textDirection: TextDirection.rtl,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
