import 'package:flutter/material.dart';
import 'package:sess_app/providers/department.dart';
import 'package:sess_app/utils/normalize_persian_word.dart';
import 'package:sess_app/widgets/search_input.dart' as MySearchInput;

class DepartmentSearch extends MySearchInput.SearchDelegate<Department> {
  final List<Department> departments;

  DepartmentSearch({@required this.departments});

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
    final List<Department> suggestItem = query.isEmpty
        ? []
        : departments.where((department) {
            return normalizePersianWord(department.name)
                .contains(normalizePersianWord(query));
          }).toList();
    return ListView.builder(
        itemCount: suggestItem.length,
        itemBuilder: (_, i) => ListTile(
              title: Text(
                suggestItem[i].name,
                textDirection: TextDirection.rtl,
              ),
              trailing: Icon(Icons.location_city),
              onTap: () {
                query = suggestItem[i].name;
                close(context, suggestItem[i]);
              },
            ));
  }
}
