import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

enum AddType {
  AddNote,
  AddExam,
}

class ModalModifyExamNote extends StatefulWidget {
  final Function afterSave;
  final AddType addType;

  ModalModifyExamNote({@required this.afterSave, @required this.addType});

  @override
  _ModalModifyExamNoteState createState() => _ModalModifyExamNoteState();
}

class _ModalModifyExamNoteState extends State<ModalModifyExamNote> {
  final _form = GlobalKey<FormState>();
  final Map<String, dynamic> info = {
    'desciption': '',
    'dateTime': null,
  };

  final TextEditingController textEditingController = TextEditingController();

  Future<void> _saveForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    if (widget.addType == AddType.AddExam) {
      widget.afterSave(info['description'], info['datetime']);
    } else {
      widget.afterSave(info['description']);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _form,
        child: Padding(
          padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: 10 + MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: <Widget>[
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  cursorColor: Theme.of(context).accentColor,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  decoration: InputDecoration(
                    icon: Icon(Icons.message),
                    labelText: "توضیحات",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                  onSaved: (value) {
                    info['description'] = value;
                  },
                  validator: (value) {
                    return value == "" ? "لطفا چیزی را وارد کنید" : null;
                  },
                ),
              ),
              widget.addType == AddType.AddExam
                  ? SizedBox(
                      height: 20,
                    )
                  : Container(),
              widget.addType == AddType.AddExam
                  ? FlatButton(
                      child: Text(
                        "انتخاب تاریخ",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontFamily: 'iransans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext _) {
                            return PersianDateTimePicker(
                              type:
                                  'datetime', //optional ,default value is date.
                              onSelect: (date) {
//                                print();
                              },
                            );
                          },
                        );
                      },
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text(
                  "ذخیره",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: _saveForm,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
