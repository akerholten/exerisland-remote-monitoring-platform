import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontendflutter/src/model_classes/metric.dart';
import 'package:frontendflutter/src/model_classes/minigame.dart';
import 'package:frontendflutter/src/model_classes/recommendation.dart';

import '../components/alerts.dart';
import '../handlers/debugTools.dart';
import 'buttons/smallButtons.dart';
import 'testForm.dart';

class AddNewRecommendationModal extends StatefulWidget {
  // final Patient newPatient;
  // final DateTime newPatientDateOfBirth;
  final ValueChanged onRecommendationAdded;

  final GlobalKey<FormFieldState> _metricKey = GlobalKey();

  AddNewRecommendationModal({this.onRecommendationAdded});

  @override
  AddNewRecommendationModalState createState() =>
      AddNewRecommendationModalState();
}

class AddNewRecommendationModalState extends State<AddNewRecommendationModal> {
  Recommendation newRec = new Recommendation();
  Metric tempSelectedMetric = new Metric();
  int _tempMetricValue;
  String _metricDropdownValue =
      ""; // hack for now, could not make this value reset properly when choosing new minigame

  var _metricValueInputController = TextEditingController();

  bool miniGameSelected = false;

  List<Minigame> availableMinigames = DebugTools
      .getListOfMinigames(); // TODO: Change to proper getting possible minigames

  bool _isDataFilled() {
    if (newRec.minigameId == null || newRec.minigameId == "") {
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
    newRec.goals = new List<Metric>();
    _metricDropdownValue = null;
    _tempMetricValue = null;
    _metricValueInputController.clear();
  }

  void _addMetric() {
    var contains = newRec.goals.where((e) => e.id == tempSelectedMetric.id);
    // If we do have this metric added already
    if (contains.isNotEmpty) {
      Alerts.showWarning(
          "Metric " + tempSelectedMetric.name + " is already added");
      return;
    }

    if (_tempMetricValue <= 0) {
      Alerts.showWarning(
          "Metric value must be above 0, was: " + _tempMetricValue.toString());
      return;
    }

    setState(() {
      tempSelectedMetric.value = _tempMetricValue;
      newRec.goals.add(tempSelectedMetric);
      _metricValueInputController.clear();
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
      newRec.deadline =
          DateTime.now().toIso8601String(); // It needs a temp value
    }
    if (newRec.goals == null) {
      newRec.goals = new List<Metric>(); // temp value
    }

    double widgetWidth = 900;
    double widgetHeight = 800;

    double formWidth = widgetWidth / 2.3;
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
                  if (value == newRec.minigameId) {
                    // if we select the same as we already had before, don't do anything
                    return;
                  }
                  _resetTempData();
                  newRec.minigameId = value;
                  miniGameSelected = true;
                  // ----- UGLY hack for now to make sure the selected metric type is available -----
                  // TODO: Make a way to workaround for this so ID can be string (evaluate if this now works)
                  _metricDropdownValue = availableMinigames
                      .firstWhere((e) => e.id == newRec.minigameId)
                      .availableMetrics[0]
                      .id;
                  tempSelectedMetric = availableMinigames
                      .firstWhere((e) => e.id == newRec.minigameId)
                      .availableMetrics
                      .firstWhere((m) => m.id == _metricDropdownValue);
                  // ----- end of UGLY hack for now to make sure the selected metric type is available -----
                });
              },
            ),
          ),
          // GOALS
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Card(
              child: SizedBox(
                width: formWidth,
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
                                      key: widget._metricKey,
                                      value: _metricDropdownValue,
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
                                        controller: _metricValueInputController,
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
                                            _tempMetricValue = int.parse(value);
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
              date: DateTime.parse(newRec.deadline),
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

    Widget _miniGameInformation() {
      return Container(
        width: formWidth,
        height: formHeight,
        // padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MINIGAME TITLE
            miniGameSelected
                ? Container(
                    padding: EdgeInsets.only(top: 4, bottom: 4),
                    child: SelectableText(
                        availableMinigames
                            .firstWhere((e) => e.id == newRec.minigameId)
                            .name,
                        style: Theme.of(context).textTheme.headline6),
                  )
                : Container(),
            // DESCRIPTION
            miniGameSelected
                ? Container(
                    padding: EdgeInsets.only(top: 4, bottom: 4),
                    child: SelectableText(
                        "Description: " +
                            availableMinigames
                                .firstWhere((e) => e.id == newRec.minigameId)
                                .description,
                        style: Theme.of(context).textTheme.bodyText1),
                  )
                : Container(),
            // TAGS
            miniGameSelected
                ? Container(
                    padding: EdgeInsets.only(top: 4, bottom: 4),
                    child: SelectableText(
                        "Tags: " +
                            availableMinigames
                                .firstWhere((e) => e.id == newRec.minigameId)
                                .getTagsAsStringList(),
                        style: Theme.of(context).textTheme.bodyText1),
                  )
                : Container(),
          ],
        ),
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
                              // Form to fill in about recommendation
                              _form(),
                              // Information about minigame
                              _miniGameInformation(),
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
