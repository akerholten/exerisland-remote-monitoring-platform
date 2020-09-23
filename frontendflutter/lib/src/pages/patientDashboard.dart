import 'package:flutter/material.dart';
import '../handlers/loginHandler.dart';
import '../components/alerts.dart';
import '../components/testForm.dart';
import '../components/taskCompletionList.dart';
import '../components/modal_AddNewPatient.dart';
import '../constants/route_names.dart';
import '../constants/constants.dart';

class PatientDashboard extends StatefulWidget {
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

  void _debugFillData() {
    currentPatient.firstName = "FirstName" + patientCount.toString();
    currentPatient.lastName = "LastName" + patientCount.toString();
    currentPatient.email = "email" + patientCount.toString() + "@emailer.com";
    currentPatient.issue = "Knee pain";
    currentPatient.age = patientCount;
    currentPatient.recommendationsCount = patientCount;
    currentPatient.recommendationsCompleted = patientCount - 1;
    currentPatient.recentActivity = patientCount.toString() + " hours ago";
    currentPatient.recommendations = new List<Recommendation>();

    for (int i = 0; i <= 10; i++) {
      Recommendation newRec = new Recommendation();
      newRec.minigameId = i;
      newRec.id = i;
      newRec.observerId = 1;
      newRec.deadline = DateTime.now().subtract(new Duration(days: i));
      if (i % 2 == 0) {
        newRec.completedAt = DateTime.now().subtract(new Duration(days: i * 2));
      }
      currentPatient.recommendations.add(newRec);
    }
  }

  @override
  Widget build(BuildContext context) {
    // double tableItemWidth = (dataTableMaxWidth * 0.75) / columnTitles.length;
    // double tableItemHeight = 70;
    _debugFillData();

    ScrollController _controller = new ScrollController();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(Constants.applicationName),
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
                                  scaffoldKey: scaffoldKey,
                                  patient: currentPatient,
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
                                child: Card(),
                              ),
                              Container(
                                // TotalActivityGraph
                                padding: EdgeInsets.all(8),
                                height: (pageMaxHeight * 0.9) / 2,
                                width: (pageMaxWidth * 0.9) / 2,
                                child: Card(),
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
