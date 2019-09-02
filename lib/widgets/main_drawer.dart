import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/main.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/screens/auth_screen.dart';
import 'package:sess_app/screens/department_screen.dart';
import 'package:sess_app/screens/profile_screen.dart';

class MainDrawer extends StatelessWidget {
  Widget _drawerItemBuilder(String title, IconData icon, Function callback) {
    return ListTile(
      title: Text(
        title,
        textDirection: TextDirection.rtl,
      ),
      leading: Icon(icon),
      onTap: callback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          _drawerItemBuilder("پروفایل", Icons.account_circle, () {
            Navigator.of(context).pushReplacementNamed(
              ProfileScreen.routeName,
            );
          }),
          Divider(),
          _drawerItemBuilder("درس های من", FontAwesomeIcons.bookOpen, () {}),
          Divider(),
          _drawerItemBuilder(
              "بخش ها",
              FontAwesomeIcons.building,
              () => Navigator.of(context)
                  .pushReplacementNamed(DepartmentScreen.routeName)),
          Divider(),
          _drawerItemBuilder("خروج", Icons.exit_to_app, () {
            Navigator.of(context).pop();
//            Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
            Provider.of<Auth>(context, listen: false).logout();
            Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
//            runApp(MyApp());
          }),
          Divider(),
        ],
      ),
    );
  }
}
