import 'package:flutter/material.dart';

class GridCourseItem extends StatelessWidget {
  final title;
  final IconData iconData;

  const GridCourseItem({@required this.title, @required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(),
        ),
      ),
    );
  }
}
