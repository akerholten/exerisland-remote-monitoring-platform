import 'package:flutter/material.dart';
import 'package:frontendflutter/src/handlers/observerHandler.dart';
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
  // double dataTableMaxWidth = 1600;
  // double Constants.pageMaxHeight = 900;

  Patient newPatient = new Patient();
  List<Patient> patients;
  bool _loading = false;

  List<String> columnTitles = [
    'Name',
    'Email',
    'Note',
    'Age',
    'Goals',
    'Recent activity'
  ];

  void _fillWithTempData() {
    patients = new List<Patient>();
  }

  void _getAllPatients() async {
    setState(() {
      _loading = true;
    });

    List<Patient> tempPatients = new List<Patient>();
    tempPatients = await ObserverHandler.getAllPatients();

    setState(() {
      _loading = false;
      // In case it returns null, we don't want the screen to continuosly
      // spam the backend each update for patients it can't retrieve
      if (tempPatients == null) {
        patients = new List<Patient>();
      } else {
        patients = tempPatients;
      }
    });
  }

  void _showAddNewPatientModal() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: AddNewPatientModal(
              onPatientAdded: () {
                _getAllPatients();
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double tableItemWidth =
        (Constants.pageMaxWidth * 0.75) / columnTitles.length;
    double tableItemHeight = 70;

    ScrollController _controller = new ScrollController();

    // data cannot be null
    if (patients == null) {
      _fillWithTempData();
      // Asynchronously collecting all patients
      _getAllPatients();
    }

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
        child: Container(
          height: Constants.pageMaxHeight,
          // width: Constants.pageMaxWidth,
          child:
              //   Scrollbar(
              // controller: _controller,
              // isAlwaysShown: true,
              // child:
              ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _controller,
            shrinkWrap: true,
            children: (patients
                .map((patient) => FlatButton(
                      onPressed: () => Navigator.of(context).pushNamed(
                          Routes.SpecificPersonDashboard,
                          arguments: PatientDashboardArguments(patient
                              .shortID)), // TODO: make this actually go to the id of the person
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
                                child: SelectableText(patient.note),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: tableItemHeight,
                                width: tableItemWidth,
                                child: SelectableText(
                                    Tools.birthDateToAge(patient.birthDate)
                                        .toString()),
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
                                child: SelectableText(
                                    (patient.recentActivityDate == null ||
                                            patient.recentActivityDate == "")
                                        ? "Never"
                                        : Tools.durationAgoString(DateTime.now()
                                            .difference(DateTime.parse(
                                                patient.recentActivityDate)))),
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
        // ),
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
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              alignment: Alignment.topCenter,
              padding:
                  EdgeInsets.only(left: 130, right: 130, top: 30, bottom: 30),
              child: Container(
                // height: Constants.pageMaxHeight,
                width: Constants.pageMaxWidth,
                //   constraints: BoxConstraints(
                //       maxWidth: Constants.pageMaxWidth,
                //       maxHeight: Constants.pageMaxHeight * 1.3),
                child: Container(
                  //Flexible(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SelectableText(
                              'Users',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            FlatButton(
                              padding: EdgeInsets.only(
                                  left: 54, right: 54, bottom: 20, top: 20),
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              onPressed: _showAddNewPatientModal,
                              child: Text(
                                'Add user',
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
                              child:
                                  _loading // if loading in patients from backend
                                      ? CircularProgressIndicator()
                                      : SelectableText(
                                          'You have no users yet',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
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
      // ),
    );
  }
}
