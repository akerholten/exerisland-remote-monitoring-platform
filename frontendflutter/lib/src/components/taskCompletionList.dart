import 'package:flutter/material.dart';
import '../handlers/loginHandler.dart';
import '../components/alerts.dart';
import '../constants/route_names.dart';
import '../constants/constants.dart';
import '../handlers/debugTools.dart';
import 'package:intl/intl.dart' as intl;
import 'package:getwidget/getwidget.dart';

class TaskCompletionList extends StatefulWidget {
  @required
  final Patient patient;
  @required
  final GlobalKey<ScaffoldState> scaffoldKey;

  TaskCompletionList({this.patient, this.scaffoldKey});

  @override
  _TaskCompletionListState createState() => _TaskCompletionListState();
}

class _TaskCompletionListState extends State<TaskCompletionList> {
  @override
  Widget build(BuildContext context) {
    ScrollController _controller = new ScrollController();

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
                      Container(
                        child: SizedBox(
                          height: 36,
                          width: 36,
                          child: FlatButton(
                            onPressed: () => Alerts.showWarning(
                                context,
                                widget.scaffoldKey,
                                "method not implemented yet"),
                            child: Container(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
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
                            context,
                            widget.scaffoldKey,
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
                                  child: SelectableText(
                                    DebugTools.getListOfMinigames()[
                                            recommendation.minigameId]
                                        .name, // TODO: Replace with correct function
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(4),
                                  child: SelectableText(
                                    "Due date: " +
                                        intl.DateFormat.yMd()
                                            .format(recommendation.deadline),
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
                                        // TODO: Edit button
                                        // TODO: Delete button
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
