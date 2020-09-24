import 'package:flutter/material.dart';
import '../handlers/loginHandler.dart';
import '../components/alerts.dart';
import '../constants/route_names.dart';
import '../constants/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // is this needed?
  String email, password = '';
  bool loggedIn = false;

  void _tryCookieLogin() {
    setState(() {
      loggedIn = LoginHandler.isLoggedInWithCookie();
    });
  }

  void _tryLogin() {
    setState(() {
      loggedIn = LoginHandler.login(email, password);

      if (loggedIn) {
        Alerts.showInfo("Logged in was successfull");
        Navigator.of(context).pushNamed(Routes.Dashboard);
        // TODO: Navigate to overview page
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false, // remove this if we want back button on app bar
        title: Text(Constants.applicationName),
      ),
      body: Form(
        key: _formKey,
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
                              'Login',
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
                          Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FlatButton(
                                  child: Text("Forgot your password?"),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(Routes.ForgotPassword);
                                  },
                                  textColor: Theme.of(context).primaryColor,
                                ),
                                FlatButton(
                                  child: Text("Sign up"),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(Routes.Signup);
                                  },
                                  textColor: Theme.of(context).primaryColor,
                                ),
                              ]),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FlatButton(
                              padding: EdgeInsets.only(
                                  left: 64, right: 64, bottom: 20, top: 20),
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              onPressed: _tryLogin,
                              child: Text(
                                'Log in',
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(fontSize: 16),
                              ),
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
