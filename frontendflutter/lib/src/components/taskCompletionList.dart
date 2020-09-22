import 'package:flutter/material.dart';
import '../handlers/loginHandler.dart';
import '../components/alerts.dart';
import '../constants/route_names.dart';
import '../constants/constants.dart';
import '../handlers/debugTools.dart';

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
          Scrollbar(
              controller: _controller,
              isAlwaysShown: true,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _controller,
                shrinkWrap: true,
                children: (widget.patient.recommendations.map(
                  (recommendation) => Card(
                    child: FlatButton(
                      onPressed: (() => Alerts.showWarning(
                          context,
                          widget.scaffoldKey,
                          "Method not implemented yet")), // TODO: Open specific session here
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SelectableText(
                                  DebugTools.getListOfMinigames()[
                                          recommendation.minigameId]
                                      .name,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                SelectableText(
                                  "Due date: " +
                                      recommendation.deadline.toString(),
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                SelectableText(
                                  "Progress: " + "60%",
                                  // TODO: This progress needs to be retrieved from data backend,
                                  // or do some magic with the data we have goals vs. results
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SelectableText(
                                  "Task",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Card(
                                        color:
                                            (recommendation.completedAt != null
                                                ? Colors.green
                                                : Colors.grey),
                                        child: Text(
                                          (recommendation.completedAt != null
                                              ? "Completed"
                                              : "Not started"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .button,
                                        ),
                                      )
                                    ]),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )).toList(),
              ))
        ],
      ),
    );
  }
}
