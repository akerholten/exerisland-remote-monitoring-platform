import 'package:flutter/material.dart';
import 'package:frontendflutter/src/constants/route_names.dart';
import 'package:frontendflutter/src/model_classes/patient.dart';
import '../components/alerts.dart';
import '../constants/constants.dart';
import 'package:intl/intl.dart' as intl;
import '../handlers/tools.dart';

class SessionInformationList extends StatefulWidget {
  @required
  final bool personalPage;

  @required
  final Patient patient;

  @required
  final double dataTableMaxWidth;

  SessionInformationList(
      {this.patient, this.dataTableMaxWidth, this.personalPage});

  @override
  _SessionInformationListState createState() => _SessionInformationListState();
}

class _SessionInformationListState extends State<SessionInformationList> {
  List<String> columnTitles = [
    'Session',
    'Duration',
    'Activities',
    'Date',
  ];

  @override
  Widget build(BuildContext context) {
    double tableItemWidth =
        (widget.dataTableMaxWidth * 0.75) / columnTitles.length;
    double tableItemHeight = 70;

    ScrollController _controller = new ScrollController();

    Widget tableHeader() {
      return Container(
        // padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: (columnTitles.map(
                (item) => Container(
                  alignment: Alignment.center,
                  height: tableItemHeight,
                  width: tableItemWidth,
                  child: SelectableText(
                    item,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 16),
                  ),
                ),
              )).toList(),
            ),
            Container(
              height: 1,
              width: double.maxFinite,
              color: Theme.of(context).dividerColor,
            ),
          ],
        ),
      );
    }

    Widget tableRows() {
      return
          // Column(
          // children: [
          Expanded(
        child: Scrollbar(
          controller: _controller,
          isAlwaysShown: true,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _controller,
            shrinkWrap: true,
            children: (widget.patient.sessions
                .map((session) => FlatButton(
                      onPressed: (() {
                        if (widget.personalPage) {
                          Navigator.of(context).pushNamed(
                              Routes.Dashboard +
                                  "/" +
                                  Routes.SpecificSessionDashboard,
                              arguments: PatientSessionArguments(
                                  widget.patient.shortID, session.id));
                        } else {
                          Navigator.of(context).pushNamed(
                              Routes.SpecificSessionDashboard +
                                  "?user=" +
                                  widget.patient.shortID +
                                  "&session=" +
                                  session.id.toString(),
                              arguments: PatientSessionArguments(
                                  widget.patient.shortID, session.id));
                        }
                      }), // TODO: make this go to the session id page
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: tableItemHeight,
                                width: tableItemWidth,
                                child: SelectableText(
                                    "Session " + session.id.toString()),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: tableItemHeight,
                                width: tableItemWidth,
                                child: (session.duration == null ||
                                        session.duration == "")
                                    ? SelectableText("No data")
                                    : SelectableText(Tools.printDuration(
                                        Tools.parseDuration(session.duration))),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: tableItemHeight,
                                width: tableItemWidth,
                                child: SelectableText(
                                    session.activities.length.toString()),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: tableItemHeight,
                                width: tableItemWidth,
                                child: SelectableText(intl.DateFormat(
                                        Constants.dateFormat)
                                    .format(DateTime.parse(session.createdAt))),
                              ),
                            ],
                          ),
                          Container(
                            height: 1,
                            width: double.maxFinite,
                            color: Theme.of(context).dividerColor,
                          ),
                        ],
                      ),
                    ))
                .toList()),
          ),
        ),
        //   )
        // ],
      );
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [tableHeader(), tableRows()]);
  }
}
