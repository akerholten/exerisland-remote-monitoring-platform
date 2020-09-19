import 'package:flutter/material.dart';
import '../handlers/loginHandler.dart';
import '../components/alerts.dart';
import '../constants/route_names.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
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
        Alerts.showInfo(context, "Logged in was successfull");
        Navigator.of(context).pushNamed(TestRoute);
        // TODO: Navigate to overview page
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              style: Theme.of(context).textTheme.title,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              filled: true,
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
                              filled: true,
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
                                    Alerts.showWarning(context,
                                        "Method not implemented yet"); // TODO: Go to forgot password page here
                                  },
                                  textColor: Theme.of(context).primaryColor,
                                ),
                                FlatButton(
                                  child: Text("Sign Up"),
                                  onPressed: () {
                                    Alerts.showWarning(context,
                                        "Method not implemented yet"); // TODO: Go to sign up page here
                                  },
                                  textColor: Theme.of(context).primaryColor,
                                ),
                              ]),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FlatButton(
                                padding: EdgeInsets.only(
                                    left: 64, right: 64, bottom: 16, top: 16),
                                color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                onPressed: _tryLogin,
                                child: Text('Log in')),
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
