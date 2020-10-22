import 'package:flutter/material.dart';
import 'package:frontendflutter/src/model_classes/activity.dart';
import 'package:frontendflutter/src/model_classes/metric.dart';
import 'package:frontendflutter/src/model_classes/patient.dart';
import 'package:frontendflutter/src/model_classes/recommendation.dart';
import 'package:frontendflutter/src/model_classes/session.dart';
import '../handlers/tools.dart';
import '../components/taskCompletionList.dart';
import '../components/sessionInformationList.dart';
import '../components/activityGraph.dart';
import '../constants/constants.dart';

class PatientDashboard extends StatefulWidget {
  @required
  final String patientId;

  PatientDashboard({this.patientId});

  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int patientCount = 0;
  double pageMaxWidth =
      1600; // TODO: change into consts and use from somewhere else? same as in therapistDashboard
  double pageMaxHeight = 900;

  Patient currentPatient = new Patient();

  void _addRecommendationToDatabase(Recommendation newRec) {
    setState(() {
      // TODO: actually implement
      // Upload recommendation to db
      // Refresh recommendation list after that is done
      currentPatient.recommendations.add(newRec);
    });
  }

  void _debugFillData() {
    currentPatient.firstName = "FirstName" + patientCount.toString();
    currentPatient.lastName = "LastName" + patientCount.toString();
    currentPatient.email = "email" + patientCount.toString() + "@emailer.com";
    currentPatient.note = "Knee pain";
    currentPatient.age = patientCount;
    currentPatient.recommendationsCount = patientCount;
    currentPatient.recommendationsCompleted = patientCount - 1;
    currentPatient.recentActivityDate = DateTime.now().toIso8601String();
    currentPatient.recommendations = new List<Recommendation>();
    currentPatient.sessions = new List<Session>();

    // Add debug recommendations list
    for (int i = 0; i <= 10; i++) {
      Recommendation newRec = new Recommendation();
      newRec.minigameId = i.toString();
      newRec.id = i.toString();
      newRec.observerId = "1";
      newRec.deadline =
          DateTime.now().subtract(new Duration(days: i)).toIso8601String();
      if (i % 2 == 0) {
        newRec.completedAt = DateTime.now()
            .subtract(new Duration(days: i * 2))
            .toIso8601String();
      }
      currentPatient.recommendations.add(newRec);
    }

    // Add debug sessions list
    for (int i = 0; i <= 10; i++) {
      Session newSession = new Session();
      newSession.id = i.toString();
      newSession.createdAt =
          DateTime.now().subtract(new Duration(days: i)).toString();
      newSession.duration =
          new Duration(hours: i, minutes: i + 1, seconds: i + 2).toString();

      newSession.activities = new List<Activity>();
      for (int j = 0; j <= i; j++) {
        Activity debugActivity = new Activity();
        debugActivity.id = j.toString();
        debugActivity.createdAt = DateTime.now()
            .subtract(new Duration(days: i, hours: j))
            .toIso8601String();
        debugActivity.minigameId = j.toString();
        debugActivity.metrics = new List<Metric>();

        for (int k = 0; k <= 5; k++) {
          Metric debugMetric = new Metric();
          debugMetric.id = k.toString();
          debugMetric.name = "Metric " + k.toString();
          debugMetric.unit = "Unit " + k.toString();
          debugMetric.value = k * 17;
          debugActivity.metrics.add(debugMetric);
        }

        newSession.activities.add(debugActivity);
      }

      currentPatient.sessions.add(newSession);
    }
  }

  @override
  Widget build(BuildContext context) {
    // double tableItemWidth = (dataTableMaxWidth * 0.75) / columnTitles.length;
    // double tableItemHeight = 70;
    // final PatientDashboardArguments args =
    //     ModalRoute.of(context).settings.arguments;

    print("Args id were: " + widget.patientId);
    if (currentPatient.recommendations == null) {
      _debugFillData();
    }

    ScrollController _controller = new ScrollController();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(Constants.applicationName),
        actions: [
          // LOGOUT ICON
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Tools.promptUserLogout(context),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: pageMaxWidth, maxHeight: pageMaxHeight * 1.3),
                child: Flexible(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Task completion list
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                alignment: Alignment.topCenter,
                                height: pageMaxHeight * 0.9,
                                width: (pageMaxWidth * 0.9) / 2,
                                child: TaskCompletionList(
                                  patient: currentPatient,
                                  onRecommendationAdded: (value) =>
                                      _addRecommendationToDatabase(value),
                                ),
                              ),
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                // SessionList
                                padding: EdgeInsets.all(8),
                                height: (pageMaxHeight * 0.9) / 2,
                                width: (pageMaxWidth * 0.9) / 2,
                                child: Card(
                                  child: SessionInformationList(
                                    patient: currentPatient,
                                    dataTableMaxWidth: (pageMaxWidth * 0.9) / 2,
                                  ),
                                ),
                              ),
                              Container(
                                // ActivityGraph
                                padding: EdgeInsets.all(8),
                                height: (pageMaxHeight * 0.9) / 2,
                                width: (pageMaxWidth * 0.9) / 2,
                                child: Card(
                                  child: ActivityGraph(
                                    patient: currentPatient,
                                  ),
                                ),
                              ),
                            ])
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
