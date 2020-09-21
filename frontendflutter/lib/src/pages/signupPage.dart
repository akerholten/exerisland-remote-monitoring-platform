import 'package:flutter/material.dart';
import '../handlers/loginHandler.dart';
import '../components/alerts.dart';
import '../constants/route_names.dart';
import '../constants/constants.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String email, password, repeatPassword, organizationID = '';

  void _trySignup() {
    setState(() {
      // Do verification of input, password == repeatPassword, valid email etc, possibly salt and hash password here?
      // Do signup - then login / cookie and session creating
      Alerts.showWarning(context, scaffoldKey, "Method not implemented yet");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(Constants.applicationName),
      ),
      body: Form(
        child: Scrollbar(
          child: Align(
            alignment: Alignment.center,
            child: Card(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: Padding(
                    padding: EdgeInsets.only(left: 32, right: 32),
                    child: Column(
                      children: [
                        ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SelectableText(
                              'Sign up',
                              style: Theme.of(context).textTheme.headline4,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Enter email',
                              labelText: 'Email',
                            ),
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                          ),
                          TextFormField(
                            obscureText: true, // hides text as this is password
                            decoration: InputDecoration(
                              hintText: 'Enter password',
                              labelText: 'Password',
                            ),
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                          ),
                          TextFormField(
                            obscureText: true, // hides text as this is password
                            decoration: InputDecoration(
                              hintText: 'Repeat password',
                              labelText: 'Repeat password',
                            ),
                            onChanged: (value) {
                              setState(() {
                                repeatPassword = value;
                              });
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Organization ID',
                              labelText: 'Organization ID',
                            ),
                            onChanged: (value) {
                              setState(() {
                                organizationID = value;
                              });
                            },
                          ),
                          Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FlatButton(
                                  child: Text("Back to login"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  textColor: Theme.of(context).primaryColor,
                                ),
                              ]),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FlatButton(
                              child: Text(
                                'Register',
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(fontSize: 16),
                              ),
                              padding: EdgeInsets.only(
                                  left: 64, right: 64, bottom: 20, top: 20),
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              onPressed: _trySignup,
                            ),
                          ),
                        ].expand(
                          (widget) => [
                            widget,
                            SizedBox(
                              height: 24,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
