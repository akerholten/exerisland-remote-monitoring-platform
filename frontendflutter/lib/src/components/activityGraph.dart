import 'package:flutter/material.dart';
import 'package:frontendflutter/src/model_classes/patient.dart';

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
    // ScrollController _controller = new ScrollController();

    return Container(
      child: Center(
        child: SelectableText(
            "WIP: Graph over different metrics might be possible to show here in the future"),
      ),
    );
  }
}
