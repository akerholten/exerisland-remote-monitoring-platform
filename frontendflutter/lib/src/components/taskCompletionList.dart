import 'package:flutter/material.dart';
import 'package:frontendflutter/src/constants/hwsession.dart';
import 'package:frontendflutter/src/model_classes/minigame.dart';
import 'package:frontendflutter/src/model_classes/patient.dart';
import 'package:frontendflutter/src/model_classes/recommendation.dart';
import '../components/alerts.dart';
import '../components/buttons/smallButtons.dart';
import 'modal_AddNewRecommendation.dart';
import '../constants/constants.dart';
import '../handlers/debugTools.dart';
import 'package:intl/intl.dart' as intl;
import 'package:getwidget/getwidget.dart';

class TaskCompletionList extends StatefulWidget {
  @required
  final Patient patient;

  @required
  final ValueChanged onRecommendationAdded;

  final bool personalPage;

  TaskCompletionList(
      {this.patient, this.onRecommendationAdded, this.personalPage = false});

  @override
  _TaskCompletionListState createState() => _TaskCompletionListState();
}

class _TaskCompletionListState extends State<TaskCompletionList> {
  Recommendation newRec = new Recommendation();

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

  void _showAddNewRecommendationModal() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: AddNewRecommendationModal(
              onRecommendationAdded: (value) {
                setState(() {
                  newRec = value;
                  widget.onRecommendationAdded(newRec);
                });
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = new ScrollController();

    if (minigames == null) {
      _getMinigames();
    }

    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Header
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 18, right: 10, top: 10, bottom: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Row of information
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // x tasks completed out of y text
                            SelectableText(
                              widget.patient
                                      .getTotalTaskCompleted()
                                      .toString() +
                                  " tasks completed out of " +
                                  widget.patient.recommendations.length
                                      .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(fontSize: 16),
                            ),
                            // Show ["all", "completed", "in progress", "expired"] tasks
                            // Sort by ["Due date", "Completed date", "Progress", "Minigame"]
                          ]),
                      // Add new task/recommendation button
                      widget.personalPage
                          ? Container() // Empty if personalPage
                          : PlusButton(
                              onPressed: _showAddNewRecommendationModal,
                            ),
                    ]),
              ),
              // Progress bar
              Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
                child: GFProgressBar(
                  percentage: widget.patient.getTotalTaskCompleted() /
                      widget.patient.recommendations.length,
                  progressBarColor: Colors.green,
                ),
              ),
              // Diviver
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
                children: (widget.patient.recommendations.map(
                  (recommendation) => Container(
                    padding: EdgeInsets.all(8),
                    child: Card(
                      child: FlatButton(
                        onPressed: (() => Alerts.showWarning(
                            "Method not implemented yet")), // TODO: Open specific session here
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4),
                                  child: _loading
                                      ? CircularProgressIndicator()
                                      : SelectableText(
                                          minigames
                                              .singleWhere((element) =>
                                                  element.id ==
                                                  recommendation.minigameId)
                                              .name, // TODO: Replace with correct function
                                          // recommendation.minigameId] // dont know if this will work now
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(4),
                                  child: SelectableText(
                                    "Due date: " +
                                        intl.DateFormat(Constants.dateFormat)
                                            .format(DateTime.parse(
                                                recommendation.deadline)),
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(4),
                                  child: SelectableText(
                                    "Progress: " + "60%",
                                    // TODO: This progress needs to be retrieved from data backend,
                                    // or do some magic with the data we have goals vs. results
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(bottom: 14, left: 4),
                                  child: SelectableText(
                                    "Task",
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: 4, left: 4, top: 14),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // TODO: Edit button for when the page is not widget.personalPage
                                        // TODO: Delete button for when the page is not widget.personalPage
                                        // Card displaying ["Completed", "Not Started", "Expired", "In Progress"]
                                        Card(
                                          color: (recommendation.completedAt !=
                                                  null
                                              ? Colors.green
                                              : Colors.grey),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                top: 4,
                                                bottom: 4,
                                                right: 8,
                                                left: 8),
                                            child: Text(
                                              (recommendation.completedAt !=
                                                      null
                                                  ? "Completed"
                                                  : "Not Started"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button
                                                  .copyWith(fontSize: 12),
                                            ),
                                          ),
                                        )
                                      ]),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
