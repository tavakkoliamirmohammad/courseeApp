import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/screens/course_detail_screen.dart';

class ProfileScreenMain extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Container(
              margin: EdgeInsets.only(bottom: 35),
              child: Stack(
                alignment: Alignment.bottomCenter,
                overflow: Overflow.visible,
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      height: 200,
                      child: Image.asset(
                        'assets/images/shiraz-uni.jpg',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
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
            ),
          ),
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: ListView.builder(
              shrinkWrap: true,
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
        ],
    );
  }
}
