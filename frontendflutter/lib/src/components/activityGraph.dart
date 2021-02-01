import 'package:flutter/material.dart';
import 'package:frontendflutter/src/components/charts/timeSeriesChart.dart';
import 'package:frontendflutter/src/model_classes/patient.dart';
import 'package:charts_flutter/flutter.dart';

// TODO: get available metricIDs based on data stored on this local user
// TODO: get available minigameIDs based on data stored on this local user
// TODO: text on x and y axis and formatting of graph to look better on page
class ActivityGraph extends StatefulWidget {
  @required
  final Patient patient;

  ActivityGraph({this.patient});

  @override
  _ActivityGraphState createState() => _ActivityGraphState();
}

List<String> availableTimeFrames = ["Session", "Daily", "Weekly", "Monthly"];

class _ActivityGraphState extends State<ActivityGraph> {
  String metricID; // TODO: Dropdown menu for this selection
  String minigameID; // TODO: Dropdown menu for this selection
  String chosenTimeFrame; // TODO: Dropdown menu for this selection

  @override
  Widget build(BuildContext context) {
    // ScrollController _controller = new ScrollController();

    return Container(
        child: Center(
      child: SimpleTimeSeriesChart
          .withSampleData(), // TODO: Replace with actual functionality when created
    )
        //   SelectableText(
        //       "WIP: Graph over different metrics might be possible to show here in the future"),
        // ),
        );
  }
}
