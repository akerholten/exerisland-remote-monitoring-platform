import 'package:flutter/material.dart';
import '../handlers/loginHandler.dart';
import '../components/alerts.dart';
import '../constants/route_names.dart';
import '../constants/constants.dart';
import '../handlers/debugTools.dart';
import 'package:intl/intl.dart' as intl;

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
            children: [],
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
                                  padding: EdgeInsets.only(bottom: 16, left: 4),
                                  child: SelectableText(
                                    "Task",
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: 4, left: 4, top: 16),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Card(
                                          color: (recommendation.completedAt !=
                                                  null
                                              ? Colors.green
                                              : Colors.grey),
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            child: Text(
                                              (recommendation.completedAt !=
                                                      null
                                                  ? "Completed"
                                                  : "Not started"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button,
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
