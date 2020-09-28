import 'package:flutter/material.dart';
import '../constants/constants.dart';
import 'testForm.dart';
import '../components/alerts.dart';
import '../handlers/debugTools.dart';

class AddNewRecommendationModal extends StatefulWidget {
  // final Patient newPatient;
  // final DateTime newPatientDateOfBirth;
  final ValueChanged onRecommendationAdded;

  AddNewRecommendationModal({this.onRecommendationAdded});

  @override
  AddNewRecommendationModalState createState() =>
      AddNewRecommendationModalState();
}

class AddNewRecommendationModalState extends State<AddNewRecommendationModal> {
  Recommendation newRec = new Recommendation();

  bool miniGameSelected = false;

  List<Minigame> availableMinigames = DebugTools
      .getListOfMinigames(); // TODO: Change to proper getting possible minigames

  bool _isDataFilled() {
    if (newRec.minigameId == null || newRec.minigameId == -1) {
      Alerts.showError("Minigame must be chosen");
      return false;
    }
    if (newRec.deadline == null) {
      Alerts.showError("Deadline must be entered");
      return false;
    }
    if (newRec.goals == null || newRec.goals.length <= 0) {
      Alerts.showError("Atleast 1 goal must be added");
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (newRec.deadline == null) {
      newRec.deadline = DateTime.now(); // It needs a temp value
    }

    double widgetWidth = 900;
    double widgetHeight = 800;

    Widget _form() {
      return Container(
        width: widgetWidth / 2.2,
        height: widgetHeight / 2.2,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          // MINIGAME
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: DropdownButtonFormField(
              items: availableMinigames
                  .map(
                    (minigame) => DropdownMenuItem(
                      child: Text(minigame.name),
                      value: minigame.id,
                    ),
                  )
                  .toList(),
              decoration: InputDecoration(
                hintText: 'Select minigame',
                labelText: 'Minigame',
              ),
              onChanged: (value) {
                setState(() {
                  newRec.minigameId = value;
                  miniGameSelected = true;
                });
              },
            ),
          ),
          // GOALS
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Card(
              child: miniGameSelected
                  ? DropdownButtonFormField(
                      items: availableMinigames
                          .firstWhere((e) => e.id == newRec.minigameId)
                          .availableMetrics
                          .map(
                            (metric) => DropdownMenuItem(
                              child: Text(metric.name),
                              value: metric.id,
                            ),
                          )
                          .toList(),
                      decoration: InputDecoration(
                        hintText: 'Add metric',
                        labelText: 'Metric',
                      ),
                      onChanged: (value) {
                        setState(() {
                          newRec.minigameId = value;
                        });
                      },
                    )
                  : Container(),
            ),
          ),
          // DEADLINE
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: FormDatePicker(
              date: newRec.deadline,
              title: "Deadline",
              onChanged: (value) {
                setState(() {
                  newRec.deadline = value;
                });
              },
            ),
          ),
        ]),
      );
    }

    Widget _buttons() {
      return Container(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
            width: 180,
            height: 50,
            child: FlatButton(
              child: Text(
                'Cancel',
                style:
                    Theme.of(context).textTheme.button.copyWith(fontSize: 16),
              ),
              color: Theme.of(context).errorColor,
              textColor: Colors.white,
              onPressed: (() => {Navigator.of(context).pop()}),
            ),
          ),
          SizedBox(
            width: 180,
            height: 50,
            child: FlatButton(
              child: Text(
                'Register patient',
                style:
                    Theme.of(context).textTheme.button.copyWith(fontSize: 16),
              ),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: (() {
                if (_isDataFilled()) {
                  widget.onRecommendationAdded(newRec);
                  Navigator.of(context).pop();
                  Alerts.showInfo("Patient added succesfully");
                }
              }),
            ),
          ),
        ]),
      );
    }

    return Container(
      padding: EdgeInsets.all(16),
      child: SizedBox(
        width: widgetWidth,
        height: widgetHeight,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // HEADER
                          Container(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: SelectableText(
                                'Add recommendation',
                                style: Theme.of(context).textTheme.headline4,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          // FORM
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _form(),
                              Text("test2"),
                            ],
                          ),
                          _buttons(),
                        ]),
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
