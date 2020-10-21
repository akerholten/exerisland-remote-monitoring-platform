import 'package:flutter/material.dart';
import 'package:frontendflutter/src/model_classes/patient.dart';
import '../handlers/tools.dart';
import '../components/modal_AddNewPatient.dart';
import '../constants/route_names.dart';
import '../constants/constants.dart';

class TherapistDashboard extends StatefulWidget {
  @override
  _TherapistDashboardState createState() => _TherapistDashboardState();
}

class _TherapistDashboardState extends State<TherapistDashboard> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int patientCount = 0;
  double dataTableMaxWidth = 1600;
  double dataTableMaxHeight = 900;

  Patient newPatient = new Patient();

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
      temp.note = "Knee pain";
      // temp.age = patientCount;
      // temp.recommendationsCount = patientCount;
      // temp.recommendationsCompleted = patientCount - 1;
      temp.recentActivityDate = DateTime.now().toIso8601String();

      patients.add(temp);
    });
  }

  _addPatientToDatabase() {
    // TODO: Actually implement this
    setState(() {
      patientCount++;

      Patient temp = new Patient();
      temp.firstName = newPatient.firstName;
      temp.lastName = newPatient.lastName;
      temp.email = newPatient.email;
      temp.note = newPatient.note;
      temp.age = DateTime.now()
              .difference(DateTime.parse(newPatient.birthDate))
              .inDays ~/
          365; // TODO: Rework as this is dumb and not accurate/correct
      temp.recommendationsCount = patientCount;
      temp.recommendationsCompleted = patientCount - 1;
      temp.recentActivityDate = DateTime.now().toIso8601String();

      patients.add(temp);
    });
  }

  void _showAddNewPatientModal() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: AddNewPatientModal(
              onPatientAdded: (value) {
                setState(() {
                  newPatient = value;
                  _addPatientToDatabase();
                });
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double tableItemWidth = (dataTableMaxWidth * 0.75) / columnTitles.length;
    double tableItemHeight = 70;

    ScrollController _controller = new ScrollController();

    Widget tableHeader() {
      return Container(
        padding: EdgeInsets.only(left: 16, right: 16),
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
                    style: Theme.of(context).textTheme.headline6,
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
      return Container(
        padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
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
                        onPressed: () => Navigator.of(context).pushNamed(Routes
                            .SpecificPersonDashboard), // TODO: make this actually go to the id of the person
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
                                  child: SelectableText(patient.firstName +
                                      " " +
                                      patient.lastName),
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
                                  child: SelectableText(patient.note),
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
                                  child: SelectableText(patient
                                          .recommendationsCompleted
                                          .toString() +
                                      "/" +
                                      patient.recommendationsCount.toString()),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: tableItemHeight,
                                  width: tableItemWidth,
                                  child: SelectableText(DateTime.now()
                                          .difference(DateTime.parse(
                                              patient.recentActivityDate))
                                          .inHours
                                          .toString() +
                                      " hours ago"), // TODO: Implement helper tool that will calculate whether to show days/hours etc here, show better information
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
        ),
      );
    }

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
                              onPressed: _showAddNewPatientModal,
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
