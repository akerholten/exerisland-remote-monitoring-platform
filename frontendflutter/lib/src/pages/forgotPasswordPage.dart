import 'package:flutter/material.dart';
import '../components/alerts.dart';
import '../constants/constants.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String email = '';

  void _tryResetPassword() {
    setState(() {
      // Do verification of input email
      // Do a call to send a new password mail
      Alerts.showWarning("Method not implemented yet");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
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
                              'Forgot password',
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
                                'Reset Password',
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(fontSize: 16),
                              ),
                              padding: EdgeInsets.only(
                                  left: 32, right: 32, bottom: 20, top: 20),
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              onPressed: _tryResetPassword,
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
