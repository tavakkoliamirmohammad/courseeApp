import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/widgets/errorDialog.dart';
import 'package:shamsi_date/shamsi_date.dart';

enum Type { AddNote, AddExam, EditNote, EditExam }

class ModalModifyExamNote extends StatefulWidget {
  final Function afterSave;
  final Type type;
  Map<String, String> initialInfo = {};

  ModalModifyExamNote(
      {
      @required this.afterSave,
      @required this.type,
      this.initialInfo});

  @override
  _ModalModifyExamNoteState createState() => _ModalModifyExamNoteState();
}

class _ModalModifyExamNoteState extends State<ModalModifyExamNote> {
  final _form = GlobalKey<FormState>();
  final Map<String, dynamic> info = {
    'desciption': '',
    'year': '',
    'month': '',
    'day': '',
    'hour': '',
    'minute': '',
    'grade': '',
  };
  var isinit = false;

  final dayFocusNode = FocusNode();
  final monthFocusNode = FocusNode();
  final yearFocusNode = FocusNode();
  final hourFocusNode = FocusNode();
  final minuteFocusNode = FocusNode();
  final gradeFocusNode = FocusNode();

  @override
  void didChangeDependencies() {
    if (!isinit && widget.type == Type.EditNote) {
      print(widget.initialInfo['desciption']);
      info['desciption'] = widget.initialInfo['desciption'];
    } else if (!isinit && widget.type == Type.EditExam) {
      info['desciption'] = widget.initialInfo['desciption'];
      info['year'] = widget.initialInfo['year'];
      info['month'] = widget.initialInfo['month'];
      info['day'] = widget.initialInfo['day'];
      info['hour'] = widget.initialInfo['hour'];
      info['minute'] = widget.initialInfo['minute'];
      info['grade'] = widget.initialInfo['grade'];
    }
    isinit = true;
    super.didChangeDependencies();
  }

  final TextEditingController textEditingController = TextEditingController();

  bool _dateValid(int year, int month, int day) {
    if (year <= 99 && year >= 0) {
      year += 1300;
    }
    if (year == null || month == null || day == null) {
      return false;
    } else if (year < 1300 || year > 1500) {
      return false;
    } else if (month < 1 || month > 12) {
      return false;
    } else if (day < 1 || day > 31) {
      return false;
    } else if (year % 4 == 3 && month == 12 && day == 31) {
      return false;
    } else if (year % 4 != 3 && month == 12 && day > 29) {
      return false;
    } else if (month > 7 && day == 31) {
      return false;
    }
    return true;
  }

  Future<void> _saveForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    print("${info['year']}/${info['month']}/${info['day']}");
    if (!(widget.type == Type.AddNote || widget.type == Type.EditNote) &&
        !_dateValid(int.parse(info['year']), int.parse(info['month']),
            int.parse(info['day']))) {
      await showDialog(
        context: context,
        builder: (ctx) => ErrorDialog(
          message: "تاریخ نامعتبر",
          ctx: ctx,
        ),
      );
      return;
    }

    final auth = Provider.of<Auth>(context, listen: false);
    if (widget.type == Type.AddExam || widget.type == Type.EditExam) {
      info['year'] =
          (int.parse(info['year']) <= 99 && int.parse(info['year']) >= 0)
              ? (int.parse(info['year']) + 1300).toString()
              : info['year'];
      final date = Jalali(int.parse(info['year']), int.parse(info['month']),
              int.parse(info['day']))
          .toDateTime()
          .add(Duration(
              hours: int.parse(info['hour']),
              minutes: int.parse(info['minute'])));
      widget.afterSave(
          info['description'],
          date,
          (double.tryParse(info['grade']) == null || info['grade'].isEmpty)
              ? 0.0
              : double.parse(info['grade']),
          auth.token);
    } else if (widget.type == Type.AddNote || widget.type == Type.EditNote) {
      widget.afterSave(info['description'], auth.token);
    }
    Navigator.of(context).pop(true);
  }

  Widget _buildDateInput(
      String title, Function validator, String value, Function onsave, FocusNode currFocusNode, FocusNode nextFocusNode) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: 70,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
            initialValue: value,
            cursorColor: Theme.of(context).accentColor,
            keyboardType: TextInputType.number,
            validator: validator,
            onSaved: onsave,
            textInputAction: currFocusNode != gradeFocusNode ? TextInputAction.next : TextInputAction.done,
            decoration: InputDecoration(
              labelText: title,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          focusNode: currFocusNode,
          onFieldSubmitted: (_) {
              currFocusNode == gradeFocusNode ? _saveForm() :
              FocusScope.of(context).requestFocus(nextFocusNode);

          },
        ),
      ),
    );
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
                  autofocus: true,
                  initialValue: info['desciption'],
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
              widget.type == Type.AddExam
                  ? SizedBox(
                      height: 20,
                    )
                  : Container(),
              (widget.type == Type.AddExam || widget.type == Type.EditExam)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "تاریخ",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _buildDateInput(
                                "سال",
                                (String value) {
                                  if (value.isEmpty) {
                                    return "الزامی";
                                  } else if (int.tryParse(value) == null ||
                                      int.parse(value) <= 0) {
                                    return "نامعتبر";
                                  }
                                  return null;
                                },
                                info['year'],
                                (value) {
                                  info['year'] = value;
                                }, yearFocusNode, hourFocusNode),
                            _buildDateInput(
                                "ماه",
                                (String value) {
                                  if (value.isEmpty) {
                                    return "الزامی";
                                  } else if (int.tryParse(value) == null ||
                                      int.parse(value) <= 0 ||
                                      int.parse(value) > 12) {
                                    return "نامعتبر";
                                  }
                                  return null;
                                },
                                info['month'],
                                (value) {
                                  info['month'] = value;
                                }, monthFocusNode, yearFocusNode),
                            _buildDateInput(
                                "روز",
                                (String value) {
                                  if (value.isEmpty) {
                                    return "الزامی";
                                  } else if (int.tryParse(value) == null ||
                                      int.parse(value) <= 0 ||
                                      int.parse(value) >= 32) {
                                    return "نامعتبر";
                                  }
                                  return null;
                                },
                                info['day'],
                                (value) {
                                  info['day'] = value;
                                }, null, monthFocusNode),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "زمان",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _buildDateInput(
                                "ساعت",
                                (String value) {
                                  if (value.isEmpty) {
                                    return "الزامی";
                                  } else if (int.tryParse(value) == null ||
                                      int.parse(value) < 0 ||
                                      int.parse(value) >= 24) {
                                    return "نامعتبر";
                                  }
                                  return null;
                                },
                                info['hour'],
                                (value) {
                                  info['hour'] = value;
                                }, hourFocusNode, minuteFocusNode),
                            _buildDateInput(
                                "دقیقه",
                                (String value) {
                                  if (value.isEmpty) {
                                    return "الزامی";
                                  } else if (int.tryParse(value) == null ||
                                      int.parse(value) < 0 ||
                                      int.parse(value) >= 60) {
                                    return "نامعتبر";
                                  }
                                  return null;
                                },
                                info['minute'],
                                (value) {
                                  info['minute'] = value;
                                }, minuteFocusNode, gradeFocusNode),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'نمره',
                          style: TextStyle(fontSize: 20),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        _buildDateInput(
                            'نمره',
                            (String value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              } else if (double.tryParse(value) == null ||
                                  double.tryParse(value) < 0) {
                                return 'نامعتبر';
                              }
                              return null;
                            },
                            info['grade'],
                            (value) {
                              info['grade'] = value;
                            }, gradeFocusNode, null),
                      ],
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
