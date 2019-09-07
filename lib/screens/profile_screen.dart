import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sess_app/widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/widgets/profile_screen_main.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

void _showErrorSnackBar(BuildContext ctx, String message) {
  Scaffold.of(ctx).removeCurrentSnackBar();
  Scaffold.of(ctx).showSnackBar(SnackBar(
    content: Row(
      textDirection: TextDirection.rtl,
      children: <Widget>[
        Icon(
          FontAwesomeIcons.exclamationTriangle,
          color: Colors.red,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          message,
          textDirection: TextDirection.rtl,
        ),
      ],
    ),
    duration: Duration(seconds: 1),
  ));
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool init = false;

  Future<void> _choosePicture(BuildContext ctx, ImageSource source, Auth auth) async {
    File selectedFile = await ImagePicker.pickImage(
      source: source,
      maxWidth: 600,
    );
    try {
      await auth.upload(selectedFile);
      if (selectedFile != null) {
        setState(() {
          auth.image = base64Encode(selectedFile.readAsBytesSync());
        });
      }
    } catch (error) {
      _showErrorSnackBar(ctx, 'خطا در برقراری ارتباط با سرور');
    }
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    resizeToAvoidBottomPadding: false,
    appBar: AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "پروفایل",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: 10,
          ),
          Icon(Icons.account_circle)
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      content: Consumer<Auth>(
                        builder: (context, auth, child) =>
                            Builder(
                              builder: (ctx) => Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceAround,
                                children: <Widget>[
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          await _choosePicture(ctx,
                                              ImageSource.gallery, auth);
                                        },
                                        icon: Icon(
                                          Icons.photo,
                                        ),
                                      ),
                                      Text(
                                        'گالری',
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.camera),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          await _choosePicture(ctx,
                                              ImageSource.camera, auth);
                                        },
                                      ),
                                      Text(
                                        'دوربین',
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                      ),
                      title: Text(
                        'انتخاب',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ));
          },
        )
      ],
    ),
    drawer: MainDrawer(),
    body: FutureBuilder(
      future: Provider.of<Auth>(context, listen: false).fetchUserDetails(),
      builder: (context, snapshot) =>
      RefreshIndicator(
        onRefresh: Provider.of<Auth>(context, listen: false).fetchUserDetails,
        child: snapshot.connectionState == ConnectionState.waiting
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ProfileScreenMain(),
      ),
    ),
  );
}}