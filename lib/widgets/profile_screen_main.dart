import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/screens/course_detail_screen.dart';

class ProfileScreenMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                    color: Theme.of(context).accentColor,
                    child: Image.asset(
                      'assets/images/shiraz-uni.jpg',
                      fit: BoxFit.cover,
                    )),
                Positioned(
                    bottom: -30,
                    child: CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            (auth.image == null || auth.image.isEmpty)
                                ? AssetImage(
                                    'assets/images/avatar.png',
                                  )
                                : MemoryImage(
                                    base64.decode(auth.image),
                                  ))),
              ],
            ),
            Consumer<Auth>(
              builder: (context, auth, child) => Container(
                margin: EdgeInsets.only(top: 30),
                height: 400,
                child: ListView.builder(
                  itemBuilder: (context, index) => Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              CourseDetailScreen.routeName,
                              arguments: auth.userCourses.firstWhere((course) =>
                                  course.id == auth.userCourses[index].id));
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
    );
  }
}
