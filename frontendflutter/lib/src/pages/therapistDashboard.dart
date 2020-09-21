import 'package:flutter/material.dart';
import '../handlers/loginHandler.dart';
import '../components/alerts.dart';
import '../constants/route_names.dart';
import '../constants/constants.dart';

class TherapistDashboard extends StatefulWidget {
  @override
  _TherapistDashboardState createState() => _TherapistDashboardState();
}

class Patient {
  String firstName,
      lastName,
      email,
      issue,
      recentActivity; // TODO: change recent activity to be date
  int age, recommendations, recommendationsCompleted;
}

class _TherapistDashboardState extends State<TherapistDashboard> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int patientCount = 0;
  double dataTableMaxWidth = 1600;
  double dataTableMaxHeight = 900;

  List<Patient> patients = new List<Patient>();
  List<String> columnTitles = [
    'Name',
    'Email',
    'Issue',
    'Age',
    'Goals',
    'Recent activity'
  ];

  void _debugFillwithData() {
    setState(() {
      patientCount++;

      Patient temp = new Patient();
      temp.firstName = "FirstName" + patientCount.toString();
      temp.lastName = "LastName" + patientCount.toString();
      temp.email = "email" + patientCount.toString() + "@emailer.com";
      temp.issue = "Knee pain";
      temp.age = patientCount;
      temp.recommendations = patientCount;
      temp.recommendationsCompleted = patientCount - 1;
      temp.recentActivity = patientCount.toString() + " hours ago";

      patients.add(temp);
    });
  }

  @override
  Widget build(BuildContext context) {
    double tableItemWidth = (dataTableMaxWidth * 0.75) / columnTitles.length;
    double tableItemHeight = 50;

    ScrollController _controller = new ScrollController();

    Widget tableHeader() {
      return Container(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: (columnTitles.map(
            (item) => Container(
              alignment: Alignment.center,
              height: tableItemHeight,
              width: tableItemWidth,
              child: SelectableText(
                item,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          )).toList(),
        ),
      );
    }

    Widget tableRows() {
      return Container(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          height: dataTableMaxHeight,
          width: dataTableMaxWidth,
          child: Scrollbar(
            controller: _controller,
            isAlwaysShown: true,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _controller,
              shrinkWrap: true,
              children: (patients
                  .map((patient) => FlatButton(
                        onPressed: () => Alerts.showWarning(
                            context, scaffoldKey, "method not implemented yet"),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: tableItemHeight,
                              width: tableItemWidth,
                              child: SelectableText(
                                  patient.firstName + " " + patient.lastName),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: tableItemHeight,
                              width: tableItemWidth,
                              child: SelectableText(patient.email),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: tableItemHeight,
                              width: tableItemWidth,
                              child: SelectableText(patient.issue),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: tableItemHeight,
                              width: tableItemWidth,
                              child: SelectableText(patient.age.toString()),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: tableItemHeight,
                              width: tableItemWidth,
                              child: SelectableText(
                                  patient.recommendationsCompleted.toString() +
                                      "/" +
                                      patient.recommendations.toString()),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: tableItemHeight,
                              width: tableItemWidth,
                              child: SelectableText(patient.recentActivity),
                            ),
                          ],
                        ),
                      ))
                  .toList()),
            ),
          ),
        ),
      );
    }

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
              padding:
                  EdgeInsets.only(left: 130, right: 130, top: 30, bottom: 30),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: dataTableMaxWidth,
                    maxHeight: dataTableMaxHeight * 1.3),
                child: Flexible(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SelectableText(
                              'Patients',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            FlatButton(
                              padding: EdgeInsets.only(
                                  left: 54, right: 54, bottom: 20, top: 20),
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              onPressed: _debugFillwithData,
                              child: Text(
                                'Add patient',
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      patients.length == 0
                          ? Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 250),
                              child: SelectableText(
                                'You have no patients yet',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            )
                          : Card(
                              child: Column(children: [
                                tableHeader(),
                                tableRows(),
                              ]),
                            ),
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
