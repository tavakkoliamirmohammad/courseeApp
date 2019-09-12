import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sess_app/providers/auth.dart';
import 'package:sess_app/screens/suggestion_screen.dart';
import 'package:sess_app/screens/terms_policy_screen.dart';
import 'package:sess_app/widgets/main_drawer.dart';
import 'package:sess_app/screens/terms_policy_screen.dart';
import 'package:url_launcher/url_launcher.dart';





class AboutUsScreen extends StatelessWidget {
  static const routeName = '/about-us';

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(

        title: Text('درباره ما'),

        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        // title: Text('درباره ما' ),
      ),
      drawer: MainDrawer(),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
            ),
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/user.png'),
            ),
            ListTile(
              subtitle: Text(
                'Version: 2.0.0',
                textAlign: TextAlign.center,
              ),
              title: Text(
                'Coursee',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21,
                  letterSpacing: 3,
                ),
              ),
            ),
            ListTile(
              onTap: () async {
                final result = await authData.fetchTermsPolicy();
                Navigator.of(context).pushNamed(
                  TermsPolicyScreen.routeName,

                  arguments: {
                    'tos': result['tos']
                  },
                );

              },
              title: Text('Terms of Service', textDirection: TextDirection.rtl),
            ),
            Divider(),
            ListTile(
              onTap: () async {
                final result = await authData.fetchTermsPolicy();
                Navigator.of(context).pushNamed(
                  TermsPolicyScreen.routeName,

                  arguments: {
                    'pp': result['pp']
                  },
                );

              },
              title: Text('Privacy Policy', textDirection: TextDirection.rtl),
            ),
            Divider(),

            ListTile(


              onTap: () async {
                Navigator.of(context).pushNamed(
                  SuggestionScreen.routeName
                );
              },
              title: Text(
                'ثبت انتقادات و پیشنهادات',
                textDirection: TextDirection.rtl,
              ),
            ),
            Divider(),

            ListTile(
              onTap: () {},
              title: Text(
                'گزارش باگ',
                textDirection: TextDirection.rtl,
              ),
            ),
            Divider(),
            ListTile(
              onTap: () => launch("tel://+989379852503"),
              title: Text('تماس با ما', textDirection: TextDirection.rtl),
            ),
            Divider(),

            ListTile(
              onTap: () {},
              title: Text('اشتراک گذاری', textDirection: TextDirection.rtl),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
            ),
//            Container()
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(

                  onPressed: () {
                    _launchURL() async {
                      const url = 'https://t.me/mohamadbastin';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }

                    _launchURL();
                  },

                  icon: Icon(
                    FontAwesomeIcons.telegram,
                    size: 30,
                  ),
                ),
                IconButton(

                  onPressed: () {

                    _launchURL() async {
                      const url = 'https://instagram.com/mohamad__bastin';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }

                    _launchURL();
                  },

                  icon: Icon(
                    FontAwesomeIcons.instagram,
                    size: 30,
                  ),
                ),
                IconButton(

                  onPressed: () {
                    _launchURL() async {
                      const url = 'https://wa.me/989379852503';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }

                    _launchURL();
                  },

                  icon: Icon(
                    FontAwesomeIcons.whatsapp,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _launchURL() async {
                      const url = 'https://apple.com';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }

                    _launchURL();
                  },

                  icon: Icon(
                    FontAwesomeIcons.apple,
                    size: 30,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

}

//Future<Map<String, dynamic>> fetchTermsPolicy() async {
//  var response =
//  await http.get("http://Sessapp.moarefe98.ir/policy", headers: {
//    "Accept": "application/json",
//    'Content-Type': 'application/json',
//    "Authorization": "Token " + token.toString(),
//  });
//  print("Terms: " + json.decode(response.body).toString());
//  return json.decode(response.body)[0];
//}


