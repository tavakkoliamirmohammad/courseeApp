import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
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

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _fetchUserDetails;
  bool init = false;

  Future<void> _choosePicture(ImageSource source, Auth auth) async {
    File selectedFile = await ImagePicker.pickImage(
      source: source,
      maxWidth: 600,
    );
    if (selectedFile != null) {
      setState(() {
        auth.image = base64Encode(selectedFile.readAsBytesSync());
      });
      await auth.upload(selectedFile);
    }
  }

  @override
  void didChangeDependencies() {
    if (!init) {
      print("init called");
      _fetchUserDetails =
          Provider.of<Auth>(context, listen: false).fetchUserDetails();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  builder: (context) => AlertDialog(
                        content: Consumer<Auth>(
                          builder: (context, auth, child) => Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await _choosePicture(
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
                                      await _choosePicture(
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
        future: _fetchUserDetails,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ProfileScreenMain(),
      ),
    );
  }
}
