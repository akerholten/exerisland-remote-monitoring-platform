import 'package:flutter/material.dart';
import 'package:frontendflutter/src/handlers/signupHandler.dart';
import 'package:frontendflutter/src/model_classes/signupForm.dart';
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
  String email,
      firstName,
      lastName,
      password,
      repeatPassword,
      organizationID = '';

  bool _signedUp = false;
  bool _loading = false;

  void _trySignup() async {
    // Do verification of input, password == repeatPassword, valid email etc, possibly salt and hash password here?
    if (!_verifyInput()) {
      return;
    }

    // Do signup - then login / cookie and session creating
    SignupForm form = new SignupForm(
        email: email,
        firstName: firstName,
        lastName: lastName,
        password: password,
        userType:
            "observer", // @TODO: Possibly make this an option to choose, or that this should be defaulted on backend and not here
        organizationID: organizationID);

    setState(() {
      _loading = true;
    });

    _signedUp = await SignupHandler.signUp(form);

    setState(() {
      _loading = false;
    });

    if (_signedUp == false) {
      return;
    }

    Navigator.of(context).pushNamed(Routes.Login);
  }

  bool _verifyInput() {
    RegExp emailRegExp = new RegExp(
        r"^[ÆØÅæøåA-Za-z0-9a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[ÆØÅæøåA-Za-z0-9a-zA-Z0-9](?:[ÆØÅæøåa-zA-Z0-9-]{0,253}[ÆØÅæøåa-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    RegExp nameRegExp = new RegExp(r"^[ÆØÅæøåa-zA-Z0-9]*$");
    if (!emailRegExp.hasMatch(email)) {
      Alerts.showError("Invalid email");
      return false;
    }

    if (!nameRegExp.hasMatch(firstName)) {
      Alerts.showError("Invalid first name");
      return false;
    }

    if (!nameRegExp.hasMatch(lastName)) {
      Alerts.showError("Invalid last name");
      return false;
    }

    if (password.length < 8) {
      Alerts.showError("Password must be atleast 8 characters long!");
      return false;
    }

    if (password != repeatPassword) {
      Alerts.showError("Passwords do not match!");
      return false;
    }

    if (!nameRegExp.hasMatch(organizationID)) {
      Alerts.showError("Invalid organization ID");
      return false;
    }

    return true;
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
                            decoration: InputDecoration(
                              hintText: 'Enter first name',
                              labelText: 'First name',
                            ),
                            onChanged: (value) {
                              setState(() {
                                firstName = value;
                              });
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Enter last name',
                              labelText: 'Last name',
                            ),
                            onChanged: (value) {
                              setState(() {
                                lastName = value;
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
                            child: _loading
                                ? CircularProgressIndicator()
                                : FlatButton(
                                    child: Text(
                                      'Register',
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(fontSize: 16),
                                    ),
                                    padding: EdgeInsets.only(
                                        left: 64,
                                        right: 64,
                                        bottom: 20,
                                        top: 20),
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
