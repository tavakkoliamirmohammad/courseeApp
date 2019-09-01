import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/providers/departments_provider.dart';
import 'package:sess_app/widgets/errorDialog.dart';

enum UserState {
  Login,
  Signup,
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _form = GlobalKey<FormState>();
  final _nameForm = GlobalKey<FormFieldState>();
  UserState userState = UserState.Signup;

  bool isLoading = false;

  double mainHeight;
  var isinit = false;


  @override
  void initState() {
    print("init state called");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(!isinit){
      mainHeight = MediaQuery.of(context).size.height * 0.7;
    }
    isinit = true;
    super.didChangeDependencies();
  }
  final Map<String, dynamic> info = {'dep': null, 'phone': '', 'name': ''};

  Future<void> _showMessageDialog(String message) async {
    return showDialog(
      context: context,
      builder: (ctx) => ErrorDialog(message: message, ctx: ctx,),
    );
  }

  Future<String> _showCheckVerificationDialog() async {
    String code;
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: Text(
          "کد تایید",
          textDirection: TextDirection.rtl,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "کد تایید را وارد کنید",
              textDirection: TextDirection.rtl,
            ),
            SizedBox(
              height: 20,
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                cursorColor: Theme.of(ctx).accentColor,
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: "کد",
                ),
                onChanged: (value) {
                  code = value;
                },
                onSubmitted: (value) {
                  code = value;
                  Navigator.of(ctx).pop(code);
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(code);
                  },
                  color: Colors.green,
                  child: Text(
                    "تایید",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(code);
                  },
                  color: Colors.red,
                  child: Text(
                    "لغو",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void createScrollListDialog(BuildContext context) {
    final departments =
        Provider.of<DepartmentsProvider>(context, listen: false).departments;
    showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
              title: Text(
                "نام بخش ها",
                textDirection: TextDirection.rtl,
              ),
              children: departments
                  .map((department) => SimpleDialogOption(
                        child: Text(
                          department.name,
                          style: TextStyle(fontSize: 18),
                          textDirection: TextDirection.rtl,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(department);
                        },
                      ))
                  .toList(),
            )).then((department) {
      setState(() {
        info['dep'] = department;
      });
    });
  }

  Future<void> _saveForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    if (userState == UserState.Signup &&
        (info['phone'].isEmpty || info['dep'] == null)) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    _form.currentState.save();
    final departments = Provider.of<Auth>(context, listen: false);
    await departments.getVerificationCode(
        info['phone'], userState == UserState.Signup ? "signup/" : "login/");
    final code = await _showCheckVerificationDialog();
    if (userState == UserState.Signup) {
      await departments.signup(
          info['phone'], code, info['name'], info['dep'].id.toString());
    } else {
      await departments.login(info['phone'], code);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Color(0xFFC33764),
                Color(0xFF1D2671),
//              Color(0xFF2C5364)
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            )),
        height: mainHeight,
        width: mediaQuery.width * 0.9,
        constraints: BoxConstraints(maxWidth: 500),
        child: Form(
          key: _form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              userState == UserState.Signup
                  ? Column(
                      children: <Widget>[
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(
                            key: _nameForm,
                            cursorColor: Theme.of(context).accentColor,
                            textDirection: TextDirection.rtl,
                            decoration: InputDecoration(
                              labelText: "نام",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            validator: (val) {
                              if (val.isEmpty) {
                                return "لطفا چیزی وارد کنید";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              info['name'] = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  : Container(),
              InternationalPhoneNumberInput(
                onInputChanged: (value) {
                  info['phone'] = value;
                  print(info['phone']);
                },
                formatInput: false,
                initialCountry2LetterCode: "IR",
                inputDecoration: InputDecoration(
                  labelText: "شماره تلفن",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              userState == UserState.Signup
                  ? Column(
                      children: <Widget>[
                        FlatButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.account_balance),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "انتخاب بخش",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          onPressed: () => createScrollListDialog(context),
                        ),
//
                        Text(
                          info['dep'] != null
                              ? info['dep'].name.toString()
                              : "بخشی را انتخاب نکرده اید",
                          overflow: TextOverflow.fade,
                          softWrap: true,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  : Container(),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFfdbb2d),
                            Color(0xFFfd1d1d),
                            Color(0xFF833ab4)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: EdgeInsets.all(0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: _saveForm,
                        child: Container(
                          width: 200,
                          child: Text(
                            userState == UserState.Signup ? "ثبت نام" : "ورود",
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        color: Colors.transparent,
                        elevation: 0,
//                        ),
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              userState == UserState.Signup
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textDirection: TextDirection.rtl,
                      children: <Widget>[
                        Text("آیا قبلا ثبت نام کرده اید؟"),
                        SizedBox(
                          width: 10,
                        ),
                        RaisedButton(
                          padding: EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "وارد شوید",
                            style: TextStyle(fontSize: 12),
                          ),
                          onPressed: () {
                            setState(() {
                              userState = UserState.Login;
                              mainHeight = mediaQuery.height *0.5;
                            });
                          },
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textDirection: TextDirection.rtl,
                      children: <Widget>[
                        Text("هنوز ثبت نام نکرده اید؟"),
                        SizedBox(
                          width: 10,
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text("ثبت نام کنید"),
                          onPressed: () {
                            setState(() {
                              userState = UserState.Signup;
                              mainHeight = mediaQuery.height *0.7;
                            });
                          },
                        )
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
