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
  String metricID = ""; //Arm_Movement TODO: Dropdown menu for this selection
  String minigameID =
      ""; //Platform_Minigame TODO: Dropdown menu for this selection
  String chosenTimeFrame = "Activity"; // TODO: Dropdown menu for this selection
  Metric chosenMetric;
  Minigame chosenMinigame;

  List<Minigame> availableMinigames;

  bool _loading = false;

  void _getMinigameData() async {
    setState(() {
      _loading = true;
    });

    if (availableMinigames == null || availableMinigames.length <= 0) {
      availableMinigames = await HWSession().getMinigames();
    }

    print("Minigames was collected: " + availableMinigames.toString());
    setState(() {
      _loading = false;
    });
  }

  void _chooseMinigame(String id) {
    setState(() {
      minigameID = id;
      chosenMinigame = availableMinigames.firstWhere((m) => m.id == minigameID,
          orElse: () => null);
    });

    if (metricID != "") {
      _chooseMetric(metricID);
    }
  }

  void _chooseMetric(String id) {
    setState(() {
      metricID = id;
      chosenMetric = chosenMinigame.availableMetrics
          .firstWhere((e) => e.id == metricID, orElse: () => null);
    });
  }

  @override
  Widget build(BuildContext context) {
    if ((availableMinigames == null || availableMinigames.length <= 0) &&
        !_loading) {
      availableMinigames = new List<Minigame>();
      _getMinigameData();
    }
    // ScrollController _controller = new ScrollController();

    return Container(
      width: Constants.pageMaxWidth * 0.5,
      height: Constants.pageMaxHeight * 0.35,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TOP BAR
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // TITLE
                // Container(
                //   padding: EdgeInsets.all(8),
                //   child: SelectableText("Metric statistics"),
                // ),
                // TODO: Minigame Selection
                Container(
                  padding: EdgeInsets.all(8),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 60, maxWidth: 200),
                    child: DropdownButtonFormField(
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 12),
                      iconSize: 20,
                      items: availableMinigames
                          .map(
                            (minigame) => DropdownMenuItem(
                              child: Text(minigame.name),
                              value: minigame.id,
                            ),
                          )
                          .toList(),
                      decoration: InputDecoration(
                        hintText: 'Select minigame',
                        labelText: 'Minigame',
                      ),
                      onChanged: (value) {
                        _chooseMinigame(value);
                      },
                    ),
                  ),
                ),
                // TODO: Metric Selection
                Container(
                  padding: EdgeInsets.all(8),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 60, maxWidth: 200),
                    child: DropdownButtonFormField(
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 12),
                      iconSize: 20,
                      items: chosenMinigame == null
                          ? null
                          : chosenMinigame.availableMetrics
                              .map(
                                (metric) => DropdownMenuItem(
                                  child: Text(metric.name),
                                  value: metric.id,
                                ),
                              )
                              .toList(),
                      decoration: InputDecoration(
                        hintText: 'Select metric',
                        labelText: 'Metric',
                      ),
                      onChanged: (value) {
                        _chooseMetric(value);
                      },
                    ),
                  ),
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
              child: (chosenMetric == null || chosenMinigame == null)
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
