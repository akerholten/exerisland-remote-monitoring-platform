import 'package:flutter/material.dart';
import 'package:frontendflutter/src/model_classes/loginForm.dart';
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
  bool _loading = false;

  void _tryCookieLogin() async {
    loggedIn = await LoginHandler.isLoggedInWithCookie();

    if (loggedIn) {
      // TODO: Check if user is observer or patient here? And then push correct accordingly
      Navigator.of(context).pushReplacementNamed(Routes.Dashboard);
    }
  }

  void _tryLogin() async {
    if (!_verifyInput()) {
      return;
    }

    LoginForm form = new LoginForm(email: email, password: password);

    setState(() {
      _loading = true;
    });

    loggedIn = await LoginHandler.manualLogin(form);

    setState(() {
      _loading = false;
    });

    if (loggedIn) {
      // TODO: Navigate to overview page
      Navigator.of(context).pushReplacementNamed(Routes.Dashboard);
    } else {
      Alerts.showError("Unable to log in with email and password combination");
    }
  }

  bool _verifyInput() {
    RegExp emailRegExp = new RegExp(
        r"^[ÆØÅæøåA-Za-z0-9a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[ÆØÅæøåA-Za-z0-9a-zA-Z0-9](?:[ÆØÅæøåa-zA-Z0-9-]{0,253}[ÆØÅæøåa-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    RegExp nameRegExp = new RegExp(r"^[ÆØÅæøåa-zA-Z0-9]*$");

    // Commented out because currently it should be allowed to login with a simple ID and not a full email for experiment purposes
    // if (!emailRegExp.hasMatch(email)) {
    //   Alerts.showError("Invalid email");
    //   return false;
    // }

    // Verify anything with password?
    // if (password.length < 8) {
    //   Alerts.showError("Password must be atleast 8 characters long!");
    //   return false;
    // }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    double appWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false, // remove this if we want back button on app bar
        title: Text(Constants.applicationName),
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              alignment: Alignment.center,
              width: appWidth,
              child: Form(
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
                                      style:
                                          Theme.of(context).textTheme.headline4,
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
                                    obscureText:
                                        true, // hides text as this is password
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FlatButton(
                                          child: Text("Forgot your password?"),
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                                Routes.ForgotPassword);
                                          },
                                          textColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                        FlatButton(
                                          child: Text("Sign up"),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushNamed(Routes.Signup);
                                          },
                                          textColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                      ]),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: _loading
                                        ? CircularProgressIndicator()
                                        : FlatButton(
                                            padding: EdgeInsets.only(
                                                left: 64,
                                                right: 64,
                                                bottom: 20,
                                                top: 20),
                                            color:
                                                Theme.of(context).primaryColor,
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
            ),
          ),
        ),
      ),
    );
  }
}
