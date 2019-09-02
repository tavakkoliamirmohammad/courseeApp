import 'package:flutter/material.dart';
import 'package:sess_app/providers/course.dart';

class CourseSearch extends SearchDelegate<Course> {
  final List<Course> courses;

  CourseSearch({@required this.courses});

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.close),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Course> suggestItem = query.isEmpty
        ? []
        : courses.where((course) {
            return course.title.contains(query);
          }).toList();
    return ListView.builder(
        itemCount: suggestItem.length,
        itemBuilder: (_, i) => ListTile(
              title: Text(
                suggestItem[i].title,
                textDirection: TextDirection.rtl,
              ),
              trailing: Icon(Icons.library_books),
              onTap: () {
                close(context, suggestItem[i]);
              },
            ));
  }
}
