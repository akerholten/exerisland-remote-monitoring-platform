import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/alerts.dart';
import '../constants/constants.dart';
import '../handlers/debugTools.dart';
import 'buttons/smallButtons.dart';
import 'testForm.dart';

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
  Metric tempSelectedMetric = new Metric();
  int tempMetricValue = 0;

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

  void _resetTempData() {
    // TODO: More has to be done? The forms has to be reset as well and stuff?
    newRec = new Recommendation();
    tempSelectedMetric = new Metric();
    tempMetricValue = 0;
    newRec.goals = new List<Metric>();
    miniGameSelected =
        false; // TODO: Maybe redo so we keep the mini game selected as a variable, and maybe do set state here?
    // TODO: could also arguably just not reset the minigameSelected variable, but all the others and call setState()
  }

  void _addMetric() {
    // TODO: have a check for when pressing + button to add new metric, that if that metric already has been added
    // do not add duplicate
    var contains = newRec.goals.where((e) => e.id == tempSelectedMetric.id);
    // If we do have this metric added already
    if (contains.isNotEmpty) {
      Alerts.showWarning(
          "Metric " + tempSelectedMetric.name + " is already added");
      return;
    }

    if (tempMetricValue <= 0) {
      Alerts.showWarning(
          "Metric value must be above 0, was: " + tempMetricValue.toString());
      return;
    }

    setState(() {
      tempSelectedMetric.value = tempMetricValue;
      newRec.goals.add(tempSelectedMetric);
    });
  }

  void _removeMetric(Metric metric) {
    setState(() {
      newRec.goals.remove(metric);
    });
  }

  void _addRecommendation() {
    // TODO: Upload to db and stuff
    if (_isDataFilled() == false) {
      return;
    }

    widget.onRecommendationAdded(newRec);
    Navigator.of(context).pop();
    Alerts.showInfo("Recommendation added succesfully");

    Alerts.showWarning("Method not implemented yet, TODO: upload to db");
  }

  @override
  Widget build(BuildContext context) {
    if (newRec.deadline == null) {
      newRec.deadline = DateTime.now(); // It needs a temp value
    }
    if (newRec.goals == null) {
      newRec.goals = new List<Metric>(); // temp value
    }

    double widgetWidth = 900;
    double widgetHeight = 800;

    double formWidth = widgetWidth / 2;
    double formHeight = widgetHeight * 0.6;

    Widget _form() {
      ScrollController _controller = new ScrollController();

      return Container(
        width: formWidth,
        height: formHeight,
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
              child: SizedBox(
                width:
                    formWidth, // TODO: Improve this, and add scrolling list of all the metrics added
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header saying goals
                      Container(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 8, right: 8),
                        child: SelectableText(
                          "Goals",
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontSize: 18),
                        ),
                      ),
                      // If minigame select, show dropdown of the different possible metrics that have not been added yet
                      // Should be row with -> Dropdown(Metric) -> FieldInput(int value) -> + button to add
                      (miniGameSelected
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                  // Dropdown(Metric)
                                  Container(
                                    width: formWidth / 2.1,
                                    child: DropdownButtonFormField(
                                      items: availableMinigames
                                          .firstWhere(
                                              (e) => e.id == newRec.minigameId)
                                          .availableMetrics
                                          .map(
                                            (metric) => DropdownMenuItem(
                                              child: Text(metric.nameAndUnit()),
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
                                          // Selecting metric from the (value) which should map to the ID // TODO: verify that it does map to the id
                                          tempSelectedMetric =
                                              availableMinigames
                                                  .firstWhere((e) =>
                                                      e.id == newRec.minigameId)
                                                  .availableMetrics
                                                  .firstWhere(
                                                      (m) => m.id == value);
                                        });
                                      },
                                    ),
                                  ),
                                  // TextFormField(int value)
                                  Container(
                                    width: formWidth / 4.1,
                                    child: TextFormField(
                                        decoration: InputDecoration(
                                          hintText: 'Value',
                                          labelText: 'Value',
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]')),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            tempMetricValue = int.parse(value);
                                          });
                                        }),
                                  ),
                                  // + button to add
                                  Container(
                                    padding: EdgeInsets.only(top: 4, right: 4),
                                    child: PlusButton(
                                      onPressed: _addMetric,
                                    ),
                                  ),
                                ])
                          : Container()),
                      // Show list of the selected metrics and with their selected values
                      Container(
                        child: SizedBox(
                          width: formWidth,
                          height: formHeight * 0.50,
                          child: Scrollbar(
                            controller: _controller,
                            isAlwaysShown: true,
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _controller,
                              shrinkWrap: true,
                              children: newRec.goals
                                  .map(
                                    (metric) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Text(Metric)
                                          Container(
                                            width: formWidth / 2.1,
                                            child: SelectableText(
                                                metric.nameAndUnit()),
                                          ),
                                          // Text(int value)
                                          Container(
                                            width: formWidth / 4.1,
                                            child: SelectableText(
                                                metric.value.toString()),
                                          ),
                                          // garbage button to remove
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 4, right: 4),
                                            child: TrashcanButton(
                                              onPressed: (() =>
                                                  _removeMetric(metric)),
                                            ),
                                          )
                                        ]),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
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
            width: 250,
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
            width: 250,
            height: 50,
            child: FlatButton(
              child: Text(
                'Add recommendation',
                style:
                    Theme.of(context).textTheme.button.copyWith(fontSize: 16),
              ),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: _addRecommendation,
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
                                style: Theme.of(context).textTheme.headline5,
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
