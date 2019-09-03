import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:sess_app/widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/screens/course_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _imageFile;

  Future<void> _choosePicture(ImageSource source) async {
    File selectedFile = await ImagePicker.pickImage(
      source: source,
      maxWidth: 600,
    );
    setState(() {
      _imageFile = selectedFile;

    });
    print('here');
    print(_imageFile);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
//    print(userCoursesList);
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
                                  await _choosePicture(ImageSource.gallery);
                                  print(
                                      'next check' + _imageFile.toString());
                                  auth.upload(_imageFile).then((value) {
                                    print('value: ' + value.toString());
                                  }).catchError((error) {
                                    print("error: " + error.toString());
                                  });
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
                                  await _choosePicture(ImageSource.camera);
                                  print('next check: ' +
                                      _imageFile.toString());
                                  await auth.upload(_imageFile);
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
        future: Provider.of<Auth>(context, listen: false).fetchUserDetails(),
        builder: (context, snapshot) => snapshot.connectionState ==
            ConnectionState.waiting
            ? Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          child: Consumer<Auth>(
            builder: (context, auth, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomCenter,
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.lightBlueAccent,
                        child: Image.asset(
                          'assets/images/shiraz-uni.png',
                          fit: BoxFit.cover,
                        )),
                    Positioned(
                        bottom: -30,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: (auth.image == null || auth.image.isEmpty) ? AssetImage(
                            'assets/images/avatar.png',
                          ) : MemoryImage(
                            base64.decode(auth.image),
                          )
                        )),
                  ],
                ),
                Consumer<Auth>(
                  builder: (context, auth, child) => Container(
                    margin: EdgeInsets.only(top: 30),
                    height: 200,
                    child: ListView.builder(
                      itemBuilder: (context, index) => Column(
                        children: <Widget>[
                          ListTile(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  CourseDetailScreen.routeName,
                                  arguments: auth.userCourses.firstWhere(
                                          (course) =>
                                      course.id ==
                                          auth.userCourses[index].id));
                            },
                            title: Text(
                              auth.userCourses[index].title,
                              textDirection: TextDirection.rtl,
                            ),
                            subtitle: Text(
                              auth.userCourses[index].time,
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                      itemCount: auth.userCourses.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
