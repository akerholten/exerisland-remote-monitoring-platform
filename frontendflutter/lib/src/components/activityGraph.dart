import 'package:flutter/material.dart';
import '../handlers/loginHandler.dart';
import '../components/alerts.dart';
import '../constants/route_names.dart';
import '../constants/constants.dart';
import '../handlers/debugTools.dart';
import 'package:intl/intl.dart' as intl;
import 'package:getwidget/getwidget.dart';

class ActivityGraph extends StatefulWidget {
  @required
  final Patient patient;

  ActivityGraph({this.patient});

  @override
  _ActivityGraphState createState() => _ActivityGraphState();
}

class _ActivityGraphState extends State<ActivityGraph> {
  @override
  Widget build(BuildContext context) {
    ScrollController _controller = new ScrollController();

    return Container(
      child: Center(
        child: SelectableText(
            "WIP: Graph over different metrics might be possible to show here"),
      ),
    );
  }
}
