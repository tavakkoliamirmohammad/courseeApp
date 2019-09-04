import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/course.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/widgets/empty_item_notifier.dart';
import 'package:sess_app/widgets/server_connection_error.dart';

class CourseDetailParticipants extends StatefulWidget {
  @override
  _CourseDetailParticipantsState createState() =>
      _CourseDetailParticipantsState();
}

class _CourseDetailParticipantsState extends State<CourseDetailParticipants> {
  @override
  Widget build(BuildContext context) {
    final course = Provider.of<Course>(context, listen: false);

    Future<List> _getProfiles;
//    course.getProfiles(course, Provider.of<Auth>(context).token).then((value) {
//      print(value.toString());
//    });
    return Container(
      child: FutureBuilder(
        future: course.getProfiles(
            course, Provider.of<Auth>(context, listen: false).token),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : snapshot.hasError
                ? ServerConnectionError(
                    message: "خط در برقراری ارتباط با سرور",
                    onPressed: () async {
                      setState(() {
                        _getProfiles = course.getProfiles(course,
                            Provider.of<Auth>(context, listen: false).token);
                      });
                    })
                : snapshot.data.length == 0
                    ? EmptyItemNotifier(
                        message: "دانشجویی ثبت نام نکرده است!",
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF928DAB),
                                    Color(0xFF1F1C2C),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                              child: ListTile(
                                title: Text(
                                  snapshot.data[index]['name'],
                                  textDirection: TextDirection.rtl,
                                ),
                                trailing: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: (snapshot.data[index]
                                                  ['picture'] ==
                                              null ||
                                          snapshot.data[index]['picture'].isEmpty)
                                      ? AssetImage('assets/images/avatar.png')
                                      : MemoryImage(base64.decode(
                                          snapshot.data[index]['picture'])),
                                ),
                              ),
                            )),
                        itemCount: snapshot.data.length,
                      ),
      ),
    );
  }
}
