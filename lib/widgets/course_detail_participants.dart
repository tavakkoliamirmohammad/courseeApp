import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/course.dart';
import 'package:sess_app/providers/auth.dart';

class CourseDetailParticipants extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final course = Provider.of<Course>(context, listen: false);
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
            : ListView.builder(
                itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue,
                            Colors.green,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(
                        snapshot.data[index]['name'],
                        textDirection: TextDirection.rtl,
                      ),
                      trailing: CircleAvatar(
                        backgroundImage: AssetImage(
                          snapshot.data[index]['picture'] == null
                              ? 'assets/images/avatar.png'
                              : 'assets/images/user.png',
                        ),
                      ),
                    )),
                itemCount: snapshot.data.length,
              ),
      ),
    );
  }
}
