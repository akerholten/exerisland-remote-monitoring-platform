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

  @required
  final double width;

  @required
  final double height;

  ActivityGraph({this.patient, this.height, this.width});

  @override
  _ActivityGraphState createState() => _ActivityGraphState();
}

// TODO: Possibly add an 'x average' and 'x total' option for daily/weekly/monthly? Or a tick box for avg/total when those are chosen
// TODO: Also consider having a way to view a maximum amount of data points or something? To view specific ranges, e.g. 10 days, 10 weeks, 20 months etc
List<String> availableTimeFrames = [
  "Activity",
  "Daily total",
  "Activity average (daily)",
  "Weekly total",
  "Activity average (weekly)",
  "Monthly total",
  "Activity average (monthly)"
];

class _ActivityGraphState extends State<ActivityGraph> {
  String metricID;
  String minigameID = "";
  String chosenTimeFrame = "Activity";
  Metric chosenMetric;
  Minigame chosenMinigame;

  List<Minigame> availableMinigames;

  GlobalKey<FormFieldState> metricFormKey;
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

      if (metricID != "") {
        _chooseMetric(metricID);
      }
    });
  }

  void _chooseMetric(String id) {
    setState(() {
      metricID = id;
      chosenMetric = chosenMinigame.availableMetrics
          .firstWhere((e) => e.id == metricID, orElse: () => null);

      if (chosenMetric == null) {
        print("Chosen metric was null");
        // metricFormKey.currentState.reset();
        // chosenMetric = chosenMinigame.availableMetrics[0];
        // metricID = chosenMetric.id;
        metricID = null;
      }
    });
  }

  void _chooseTimeFrame(String selection) {
    setState(() {
      chosenTimeFrame = selection;
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
            // TOP BAR // TODO: Possibly have a title over selection options?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // TITLE
                // Container(
                //   padding: EdgeInsets.all(8),
                //   child: SelectableText("Metric statistics"),
                // ),
                // Minigame Selection
                Container(
                  padding: EdgeInsets.all(8),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 60, maxWidth: 220),
                    child: DropdownButtonFormField(
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 14),
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
                // Metric Selection
                Container(
                  padding: EdgeInsets.all(8),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 60, maxWidth: 220),
                    child: DropdownButtonFormField(
                      key: metricFormKey,
                      value: metricID,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 14),
                      iconSize: 20,
                      items: (chosenMinigame == null ||
                              chosenMinigame.availableMetrics == null ||
                              chosenMinigame.availableMetrics.length <= 0)
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
                // Timeframe Selection
                Container(
                  padding: EdgeInsets.all(8),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 60, maxWidth: 220),
                    child: DropdownButtonFormField(
                      value: "Activity",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 14),
                      iconSize: 20,
                      items: availableTimeFrames
                          .map(
                            (timeFrame) => DropdownMenuItem(
                              child: Text(timeFrame),
                              value: timeFrame,
                            ),
                          )
                          .toList(),
                      decoration: InputDecoration(
                        hintText: 'Select timeframe',
                        labelText: 'Timeframe',
                      ),
                      onChanged: (value) {
                        _chooseTimeFrame(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
            // ACTUAL GRAPH
            Container(
              constraints: BoxConstraints(
                  maxWidth: widget.width, //Constants.pageMaxWidth * 0.4
                  maxHeight: widget.height), //Constants.pageMaxHeight * 0.34)
              padding: EdgeInsets.all(8),
              child: (chosenMetric == null || chosenMinigame == null)
                  ? Container()
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
