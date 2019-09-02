import 'package:flutter/material.dart';
import 'package:sess_app/widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/providers/department.dart';
import 'package:sess_app/screens/course_detail_screen.dart';
import 'package:sess_app/providers/course_list_provider.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
//    print(userCoursesList);
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
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
                  actions: <Widget>[
                    InkWell(
                      child: FittedBox(
                        child: Image.asset(
                          'assets/images/gallery.png',
                          fit: BoxFit.cover,
                        ),

                      ),
                      onTap: () {
                        ImagePicker.pickImage(
                          source: ImageSource.gallery,
                          maxWidth: 600,
                        );
                      },
                    ),
                    InkWell(
                      child: FittedBox(
                        child: Image.asset(
                          'assets/images/camera.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () {
                        ImagePicker.pickImage(
                          source: ImageSource.camera,
                          maxWidth: 600,
                        );
                      },
                    ),
                  ],
                )
              );
            },
          )
        ],
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
        future: Provider.of<Auth>(context, listen: false).fetchUserDetails(),
        builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(child: Column(
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 50,
                      child: CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/user.png',
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text(snapshot.data[0]['name']),
                  ],
                ),
              ),
            ),
            Consumer<Auth>(
              builder: (context, auth, child) => Container(
                height: deviceSize.height * 0.5,
                child: ListView.builder(
                  itemBuilder: (context, index) => Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              CourseDetailScreen.routeName,
                              arguments: auth.userCourses.firstWhere((course) => course.id == auth.userCourses[index].id));
                        },
                        title: Text(
                          auth.userCourses[index].title,
                          textDirection: TextDirection.rtl,
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
    );
  }
}
