import 'package:flutter/material.dart';
import '../constants/constants.dart';

class ErrorPage extends StatelessWidget {
  @required
  final String title;

  ErrorPage({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false, // remove this if we want back button on app bar
        title: Text(Constants.applicationName),
      ),
      body: Center(
        child: SelectableText(
          this.title,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}
