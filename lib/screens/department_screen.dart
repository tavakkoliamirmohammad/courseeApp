import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/departments_provider.dart';
import 'package:sess_app/widgets/department_item.dart';

class DepartmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "نام بخش ها",
              textDirection: TextDirection.rtl,
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.account_balance),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: Provider.of<DepartmentsProvider>(context, listen: false)
            .fetchAndSetDepartments(),
        builder: (_, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : Container(
                    padding: EdgeInsets.all(10),
                    child: Consumer<DepartmentsProvider>(
                      builder: (_, departments, child) => GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: 1.5),
                        itemBuilder: (_, i) => DepartmentItem(
                          department: departments.departments[i],
                        ),
                        itemCount: departments.departments.length,
                      ),
                    ),
                  ),
      ),
    );
  }
}
