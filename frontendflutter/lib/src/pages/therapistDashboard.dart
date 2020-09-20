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
  // final _formKey = GlobalKey<FormState>(); // is this needed?
  int patientCount = 0;
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
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(Constants.applicationName),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 130, right: 130, top: 30, bottom: 30),
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Patients',
                  style: Theme.of(context).textTheme.headline4,
                ),
                FlatButton(
                  padding:
                      EdgeInsets.only(left: 54, right: 54, bottom: 20, top: 20),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: _debugFillwithData,
                  // Alerts.showWarning(context, "method not implemented yet"),
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
            patients.length == 0
                ? Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 250),
                    child: Text(
                      'You have no patients yet',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: DataTable(
                      columns: (columnTitles.map(
                        (item) => DataColumn(
                          label: Text(
                            item,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      )).toList(),
                      rows: (patients.map(
                        (patient) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(
                                patient.firstName + " " + patient.lastName)),
                            DataCell(Text(patient.email)),
                            DataCell(Text(patient.issue)),
                            DataCell(Text(patient.age.toString())),
                            DataCell(Text(
                                patient.recommendationsCompleted.toString() +
                                    "/" +
                                    patient.recommendations.toString())),
                            DataCell(Text(patient.recentActivity)),
                          ],
                        ),
                      )).toList(),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
