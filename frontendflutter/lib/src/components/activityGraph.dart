import 'package:flutter/material.dart';
import 'package:frontendflutter/src/components/charts/linearChart.dart';
import 'package:frontendflutter/src/components/charts/timeSeriesChart.dart';
import 'package:frontendflutter/src/constants/constants.dart';
import 'package:frontendflutter/src/constants/hwsession.dart';
import 'package:frontendflutter/src/model_classes/metric.dart';
import 'package:frontendflutter/src/model_classes/minigame.dart';
import 'package:frontendflutter/src/model_classes/patient.dart';
import 'package:fl_chart/fl_chart.dart';

// TODO: get available metricIDs based on data stored on this local user
// TODO: get available minigameIDs based on data stored on this local user
class ActivityGraph extends StatefulWidget {
  @required
  final Patient patient;

  ActivityGraph({this.patient});

  @override
  _ActivityGraphState createState() => _ActivityGraphState();
}

List<String> availableTimeFrames = ["Activity", "Daily", "Weekly", "Monthly"];

class _ActivityGraphState extends State<ActivityGraph> {
  String metricID = "Arm_Movement"; // TODO: Dropdown menu for this selection
  String minigameID =
      "Platform_Minigame"; // TODO: Dropdown menu for this selection
  String chosenTimeFrame = "Activity"; // TODO: Dropdown menu for this selection
  Metric chosenMetric;
  Minigame chosenMinigame;
  bool _loading = false;

  void _getMetricData() async {
    setState(() {
      _loading = true;
    });

    List<Minigame> minigames = await HWSession().getMinigames();

    chosenMinigame = minigames.firstWhere((m) => m.id == minigameID);
    chosenMetric =
        chosenMinigame.availableMetrics.firstWhere((e) => e.id == metricID);

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (chosenMetric == null) {
      _getMetricData();
    }
    // ScrollController _controller = new ScrollController();

    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TOP BAR
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // TITLE
                Container(
                  padding: EdgeInsets.all(8),
                  child: SelectableText("Metric statistics"),
                ),
                // TODO: Minigame Selection
                Container(
                  padding: EdgeInsets.all(8),
                  child: SelectableText("Minigame"),
                ),
                // TODO: Metric Selection
                Container(
                  padding: EdgeInsets.all(8),
                  child: SelectableText("Metric"),
                ),
                // TODO: Timeframe selection
                Container(
                  padding: EdgeInsets.all(8),
                  child: SelectableText("Timeframe"),
                ),
              ],
            ),
            // ACTUAL GRAPH
            Container(
              constraints: BoxConstraints(
                  maxWidth: Constants.pageMaxWidth * 0.4,
                  maxHeight: Constants.pageMaxHeight * 0.35),
              padding: EdgeInsets.all(8),
              child: _loading
                  ? CircularProgressIndicator()
                  : LinearChart(
                      patient: widget.patient,
                      chosenMetric: chosenMetric,
                      chosenMinigame: chosenMinigame,
                      chosenTimeFrame: chosenTimeFrame,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
