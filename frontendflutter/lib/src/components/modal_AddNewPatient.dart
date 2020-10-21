import 'package:flutter/material.dart';
import 'package:frontendflutter/src/handlers/observerHandler.dart';
import 'package:frontendflutter/src/model_classes/addPatientForm.dart';
import 'package:frontendflutter/src/model_classes/patient.dart';

import '../components/alerts.dart';
import 'testForm.dart';

class AddNewPatientModal extends StatefulWidget {
  // final Patient newPatient;
  // final DateTime newPatientDateOfBirth;
  final ValueChanged onPatientAdded;

  AddNewPatientModal({this.onPatientAdded});

  @override
  AddNewPatientModalState createState() => AddNewPatientModalState();
}

class AddNewPatientModalState extends State<AddNewPatientModal> {
  Patient newPatient = new Patient();

  DateTime _chosenDateTime;

  bool _loading = false;

  void _tryAddNewPatient() async {
    if (_isDataFilled() == false) {
      return;
    }
    bool _patientAdded = false;

    AddPatientForm form = new AddPatientForm(
        firstName: newPatient.firstName,
        lastName: newPatient.lastName,
        email: newPatient.email,
        birthDate: newPatient.birthDate,
        note: newPatient.note);

    setState(() {
      _loading = true;
    });

    _patientAdded = await ObserverHandler.addPatient(form);

    setState(() {
      _loading = false;
    });

    if (_patientAdded == false) {
      return;
    }

    Navigator.of(context).pop();
    // TODO: also must retrieve the data of patients over again, such that the new patient is seen in list
  }

  bool _isDataFilled() {
    if (newPatient.firstName == null || newPatient.firstName == "") {
      Alerts.showError("First name field must be entered");
      return false;
    }
    if (newPatient.lastName == null || newPatient.lastName == "") {
      Alerts.showError("Last name field must be entered");
      return false;
    }
    if (newPatient.email == null || newPatient.email == "") {
      Alerts.showError("Email field must be entered");
      return false;
    }
    if (newPatient.note == null || newPatient.note == "") {
      Alerts.showError("Issue field must be entered");
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (newPatient.birthDate == null) {
      newPatient.birthDate =
          DateTime.utc(1990).toIso8601String(); // It needs a temp value
    }

    return Container(
      padding: EdgeInsets.all(16),
      child: SizedBox(
        width: 600,
        height: 600,
        child: Form(
          child: Scrollbar(
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: EdgeInsets.only(left: 32, right: 32),
                    child: Column(
                      children: [
                        ...[
                          Container(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: SelectableText(
                                'Register new patient',
                                style: Theme.of(context).textTheme.headline4,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 8),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter first name',
                                labelText: 'First name',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  newPatient.firstName = value;
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 8),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter last name',
                                labelText: 'Last name',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  newPatient.lastName = value;
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 8),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter email',
                                labelText: 'Email',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  newPatient.email = value;
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 8),
                            child: FormDatePicker(
                              date: DateTime.parse(newPatient.birthDate),
                              title: "Date of birth",
                              onChanged: (value) {
                                setState(() {
                                  newPatient.birthDate =
                                      (value as DateTime).toIso8601String();
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 8),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter issue',
                                labelText: 'Issue',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  newPatient.note = value;
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 16, bottom: 16),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 180,
                                    height: 50,
                                    child: FlatButton(
                                      child: Text(
                                        'Cancel',
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            .copyWith(fontSize: 16),
                                      ),
                                      color: Theme.of(context).errorColor,
                                      textColor: Colors.white,
                                      onPressed: (() =>
                                          {Navigator.of(context).pop()}),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    height: 50,
                                    child: _loading
                                        ? CircularProgressIndicator()
                                        : FlatButton(
                                            child: Text(
                                              'Register patient',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button
                                                  .copyWith(fontSize: 16),
                                            ),
                                            color:
                                                Theme.of(context).primaryColor,
                                            textColor: Colors.white,
                                            onPressed: (() =>
                                                _tryAddNewPatient()),
                                          ),
                                  ),
                                ]),
                          ),
                        ]
                      ],
                    ),
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
