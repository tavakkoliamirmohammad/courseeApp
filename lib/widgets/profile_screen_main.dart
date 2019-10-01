import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/screens/course_detail_screen.dart';

class ProfileScreenMain extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
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
                      bottom: -50,
                      child: InkWell(
                        onTap: (auth.image == null || auth.image.isEmpty) ? () {} : () {
                          showDialog(
                            context: context,
                            builder: (context) => Dismissible(
                              key: Key('profile'),
                              direction: DismissDirection.up,
                              onDismissed: (dir) {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                child: Image.memory(
                                  base64.decode(auth.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          );
                        },

                        child: Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage:(auth.image == null || auth.image.isEmpty)
                                ? AssetImage(
                              'assets/images/avatar.png',
                            )
                                : MemoryImage(
                              base64.decode(auth.image),
                            ),
                          ),
                        ),
                      )
                  )
//                          backgroundImage:
//                              (auth.image == null || auth.image.isEmpty)
//                                  ? AssetImage(
//                                      'assets/images/avatar.png',
//                                    )
//                                  : MemoryImage(
//                                      base64.decode(auth.image),
//                                    ))),
                ],
              ),
            ),
            ...auth.userCourses.map((course1) => Column(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        CourseDetailScreen.routeName,
                        arguments: auth.userCourses.firstWhere((course) =>
                        course.id == course1.id));
                  },
                  title: Text(
                    course1.title,
                    textDirection: TextDirection.rtl,
                  ),
                  subtitle: Text(
                    course1.time,
                  ),
                ),
                Divider(),
              ],
            ))
          ],
      ),
    );
  }
}
