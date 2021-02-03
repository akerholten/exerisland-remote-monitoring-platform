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
// TODO: text on x and y axis and formatting of graph to look better on page
class ActivityGraph extends StatefulWidget {
  @required
  final Patient patient;

  ActivityGraph({this.patient});

  @override
  _ActivityGraphState createState() => _ActivityGraphState();
}

// TODO: Create class for returning a FlChart graph
// TODO: Create class functionality for returning LineChartBarData with spots and titles depending on metric and timeframe feeden into it
List<String> availableTimeFrames = ["Activity", "Daily", "Weekly", "Monthly"];
List<FlSpot> spotsWritten = [FlSpot(1, 1), FlSpot(2, 4), FlSpot(6, 2)];

class _ActivityGraphState extends State<ActivityGraph> {
  String metricID = "Arm_Movement"; // TODO: Dropdown menu for this selection
  String minigameID =
      "Platform_Minigame"; // TODO: Dropdown menu for this selection
  String chosenTimeFrame = "Activity"; // TODO: Dropdown menu for this selection
  Metric chosenMetric;
  bool _loading = false;

  void _getMetricData() async {
    setState(() {
      _loading = true;
    });

    List<Minigame> minigames = await HWSession().getMinigames();

    chosenMetric = minigames
        .firstWhere((m) => m.id == minigameID)
        .availableMetrics
        .firstWhere((e) => e.id == metricID);

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
    // List<LineChartBarData> lines = [
    //   LineChartBarData(spots: spotsWritten, isCurved: true)
    // ];
    // chartData = new LineChartData(
    //     lineBarsData: lines,
    //     titlesData: FlTitlesData(show: true, leftTitles: SideTitles()));

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
            // ConstrainedBox(
            //   constraints: BoxConstraints(maxWidth: 900, maxHeight: 700),
            //   // padding: EdgeInsets.all(8),
            //   child: SimpleTimeSeriesChart
            //       .withSampleData(), // TODO: Replace with actual functionality when created
            // ),
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
                      minigameID: minigameID,
                      chosenTimeFrame: chosenTimeFrame,
                    ), // TODO: Replace with actual functionality when created
            )
          ],
        ),
      ),
      //   SelectableText(
      //       "WIP: Graph over different metrics might be possible to show here in the future"),
      // ),
    );
  }
}
