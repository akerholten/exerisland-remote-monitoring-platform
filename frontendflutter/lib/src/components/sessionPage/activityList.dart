import 'package:flutter/material.dart';
import 'package:frontendflutter/src/constants/hwsession.dart';
import 'package:frontendflutter/src/handlers/tools.dart';
import 'package:frontendflutter/src/model_classes/activity.dart';
import 'package:frontendflutter/src/model_classes/metric.dart';
import 'package:frontendflutter/src/model_classes/minigame.dart';
import 'package:frontendflutter/src/model_classes/patient.dart';
import 'package:frontendflutter/src/model_classes/recommendation.dart';
import '../../components/alerts.dart';
import '../../components/buttons/smallButtons.dart';
import '../modal_AddNewRecommendation.dart';
import '../../constants/constants.dart';
import '../../handlers/debugTools.dart';
import 'package:intl/intl.dart' as intl;
import 'package:getwidget/getwidget.dart';

class ActivityList extends StatefulWidget {
  @required
  final List<Activity> activities;

  @required
  final ValueChanged onActivityChosen;

  ActivityList({this.activities, this.onActivityChosen});

  @override
  _ActivityListState createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  List<Minigame> minigames;
  bool _loading = false;

  void _getMinigames() async {
    setState(() {
      _loading = true;
    });

    minigames = await HWSession().getMinigames();

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = new ScrollController();

    if (minigames == null) {
      _getMinigames();
    }

    return Card(
      child: _loading || widget.activities == null
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Header
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 18, right: 10, top: 10, bottom: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Row of information
                            SelectableText(
                              "Recent Activity",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(fontSize: 16),
                            ),
                            // Show ["all", "physical", "coordination"] mini-game related activities
                            // Sort by ["Duration", "Name"] etc?
                          ]),
                    ),
                    // Divider
                    Container(
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      child: Container(
                        height: 1,
                        width: double.maxFinite,
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ],
                ),
                // Rows of tasks and their info
                Expanded(
                  child: Scrollbar(
                    controller: _controller,
                    isAlwaysShown: true,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _controller,
                      shrinkWrap: true,
                      children: (widget.activities.map((activity) {
                        Minigame minigame = minigames.firstWhere(
                            (element) => element.id == activity.minigameID,
                            orElse: () => null);
                        // In case minigame is not found
                        if (minigame == null) {
                          minigame = new Minigame();
                          minigame.id = "noData";
                          minigame.name = "Minigame not found";
                          minigame.description = "";
                          minigame.tags = new List<String>();
                        }

                        Metric durationMetric = activity.metrics.firstWhere(
                            (element) => element.id == "Duration",
                            orElse: () => null);

                        return Container(
                          padding: EdgeInsets.all(8),
                          child: Card(
                            child: FlatButton(
                              onPressed: (() =>
                                  widget.onActivityChosen(activity)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Mini-Game title
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        child: _loading
                                            ? CircularProgressIndicator()
                                            : SelectableText(
                                                minigame.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              ),
                                      ),
                                      // Tags
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        child: SelectableText(
                                          "Tags: " +
                                              Tools.listOfStringsToString(
                                                  minigame.tags),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(fontSize: 14),
                                        ),
                                      ),
                                      // Description
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        child: SelectableText(
                                          "Description: " +
                                              minigame.description,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // RIGHT side column ("Minigame", and "Duration")
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              bottom: 18, left: 4),
                                          child: SelectableText(
                                            "Minigame",
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              bottom: 4, left: 4, top: 18),
                                          child: durationMetric == null
                                              ? SelectableText(
                                                  "Duration: No data")
                                              : SelectableText("Duration: " +
                                                  Tools.secondsToHHMMSS(
                                                      durationMetric.value)),
                                        )
                                      ]),
                                ],
                              ),
                            ),
                          ),
                        );
                      })).toList(),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
