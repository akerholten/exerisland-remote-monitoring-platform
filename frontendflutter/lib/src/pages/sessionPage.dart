import 'package:flutter/material.dart';
import 'package:frontendflutter/src/components/alerts.dart';
import 'package:frontendflutter/src/components/sessionPage/activityList.dart';
import 'package:frontendflutter/src/components/sessionPage/metricList.dart';
import 'package:frontendflutter/src/components/taskCompletionList.dart';
import 'package:frontendflutter/src/constants/constants.dart';
import 'package:frontendflutter/src/constants/hwsession.dart';
import 'package:frontendflutter/src/handlers/tools.dart';
import 'package:frontendflutter/src/model_classes/activity.dart';
import 'package:frontendflutter/src/model_classes/patient.dart';
import 'package:frontendflutter/src/model_classes/session.dart';
import 'package:frontendflutter/src/pages/errorPage.dart';

class SessionPage extends StatefulWidget {
  final bool personalPage;

  final String patientShortId;

  final int sessionId;

  SessionPage({this.sessionId, this.patientShortId, this.personalPage = false});

  @override
  _SessionPageState createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  Session session;
  Patient patient;
  Activity _selectedActivity;
  bool _loading = false;
  bool _sessionNotFound = false;

  void _getSessionDataAsync() async {
    setState(() {
      _loading = true;
    });

    Patient tempPatient = new Patient();

    if (widget.personalPage) {
      tempPatient = await HWSession().getPersonalInfo();
    } else {
      tempPatient = await HWSession().getPatient(widget.patientShortId);
    }

    // if not found
    if (tempPatient == null) {
      setState(() {
        _loading = false;
        _sessionNotFound = true;
        return;
      });
    }

    Session tempSession = new Session();

    tempSession = tempPatient.sessions
        .firstWhere((element) => element.id == widget.sessionId);

    setState(() {
      _loading = false;
      // if not found
      if (tempSession == null) {
        _sessionNotFound = true;
        return;
      }
      session = tempSession;
      patient = tempPatient;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_sessionNotFound) {
      return ErrorPage(title: "404 page not found");
    }

    if (session == null) {
      _getSessionDataAsync();
    }

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: _loading
            ? Text(Constants.applicationName)
            : Text(patient.firstName + " " + patient.lastName),
        actions: [
          // LOGOUT ICON
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Tools.promptUserLogout(context),
          )
        ],
      ),
      body: Center(
        child: _loading // if we are loading the session data currently
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: Constants.pageMaxWidth,
                          maxHeight: Constants.pageMaxHeight * 1.3),
                      child: Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Recent activity list -- minigames, etc
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    alignment: Alignment.topCenter,
                                    height: Constants.pageMaxHeight * 0.9,
                                    width: (Constants.pageMaxWidth * 0.9) / 2,
                                    child: ActivityList(
                                        // TODO: change to RecentActivityList when that is created
                                        activities: session.activities,
                                        onActivityChosen: (value) =>
                                            setState(() {
                                              _selectedActivity = value;
                                            })),
                                  ),
                                ]),
                            // Metric list of selected activity
                            // TODO: This could potentially have a "button" in the future
                            // to view all metrics over all activities combined also
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    alignment: Alignment.topCenter,
                                    height: Constants.pageMaxHeight * 0.9,
                                    width: (Constants.pageMaxWidth * 0.9) / 2,
                                    child: Card(
                                      child: MetricList(
                                        metrics:
                                            _selectedActivity?.metrics ?? null,
                                        dataTableMaxWidth:
                                            (Constants.pageMaxWidth * 0.9) / 2,
                                      ),
                                    ),
                                  ),
                                ]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
