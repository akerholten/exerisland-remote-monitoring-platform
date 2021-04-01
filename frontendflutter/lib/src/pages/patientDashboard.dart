import 'package:flutter/material.dart';
import 'package:frontendflutter/src/components/alerts.dart';
import 'package:frontendflutter/src/components/statistics/statCard.dart';
import 'package:frontendflutter/src/constants/hwsession.dart';
import 'package:frontendflutter/src/handlers/observerHandler.dart';
import 'package:frontendflutter/src/handlers/patientHandler.dart';
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
import 'errorPage.dart';

class PatientDashboard extends StatefulWidget {
  final bool personalPage;

  final String shortId;

  PatientDashboard({this.shortId, this.personalPage = false});

  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int patientCount = 0;

  Patient patient;
  bool _loading;
  bool _patientNotFound = false;

  void _fillWithTempData() {
    patient = new Patient();
  }

  void _getPatientDataAsync() async {
    setState(() {
      _loading = true;
    });

    Patient tempPatient = new Patient();

    if (widget.personalPage) {
      tempPatient = await HWSession().getPersonalInfo();
    } else {
      tempPatient = await HWSession().getPatient(widget.shortId);
    }

    setState(() {
      _loading = false;
      // if not found
      if (tempPatient == null) {
        _patientNotFound = true;
        return;
      }
      patient = tempPatient;
    });
  }

  void _addRecommendationToDatabase(Recommendation newRec) {
    setState(() {
      // TODO: actually implement
      // Upload recommendation to db
      // Refresh recommendation list after that is done
      patient.recommendations.add(newRec);
    });
  }

  @override
  Widget build(BuildContext context) {
    // double tableItemWidth = (dataTableMaxWidth * 0.75) / columnTitles.length;
    // double tableItemHeight = 70;
    // final PatientDashboardArguments args =
    //     ModalRoute.of(context).settings.arguments;

    if (_patientNotFound) {
      return ErrorPage(title: "404 page not found");
    }

    // data cannot be null
    if (patient == null) {
      _fillWithTempData();
      // Asynchronously collecting all patients
      _getPatientDataAsync();
    }
    // if (patient.recommendations == null) {
    //   _debugFillData();
    // }

    // ScrollController _controller = new ScrollController();

    double height = (Constants.pageMaxHeight * 0.57);
    double width = (Constants.pageMaxWidth * 0.6);

    // TODO: can potentially remove this, as I don't think they are being utilized really
    int statCardHorizontalCount = 6;
    double statCardWidth = (Constants.pageMaxWidth / statCardHorizontalCount);
    double statCardHeight = (height * 0.7) * 0.47;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: _loading
            ? Text(Constants.applicationName)
            : Text(patient.firstName + " " + patient.lastName),
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
        child: _loading // if we are loading the patients data currently
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(
                        left: 130, right: 130, top: 30, bottom: 30),
                    child: Container(
                      width: Constants.pageMaxWidth,
                      // height: Constants.pageMaxHeight * 1.3,
                      child: Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // //Task completion list
                              // Column(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     children: [
                              //       Container(
                              //         padding: EdgeInsets.all(8),
                              //         alignment: Alignment.topCenter,
                              //         height: Constants.pageMaxHeight * 0.9,
                              //         width: (Constants.pageMaxWidth * 0.9) / 2,
                              //         child: TaskCompletionList(
                              //           patient: patient,
                              //           personalPage: widget.personalPage,
                              //           onRecommendationAdded: (value) =>
                              //               _addRecommendationToDatabase(value),
                              //         ),
                              //       ),
                              //     ]),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // ActivityGraph
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          height: height,
                                          width: width,
                                          child: Card(
                                            child: ActivityGraph(
                                              patient: patient,
                                              height: height * 0.8,
                                              width: width *
                                                  0.95, // TODO: look at this
                                            ),
                                          ),
                                        ),
                                        Container(
                                          // SessionList
                                          padding: EdgeInsets.all(8),
                                          height: height,
                                          width: (Constants.pageMaxWidth * 0.4),
                                          child: Card(
                                            child: SessionInformationList(
                                              personalPage: widget.personalPage,
                                              patient: patient,
                                              dataTableMaxWidth:
                                                  (Constants.pageMaxWidth *
                                                      0.4),
                                              dataTableMaxHeight: height,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Statistics Tab with stat cards
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      height: height * 0.7,
                                      width: Constants.pageMaxWidth,
                                      child: Card(
                                        child: GridView.count(
                                          crossAxisCount:
                                              statCardHorizontalCount,
                                          childAspectRatio:
                                              (statCardWidth / statCardHeight),
                                          shrinkWrap: true,
                                          children: [
                                            // GENERAL STATS
                                            StatCard(
                                              height: statCardHeight,
                                              width: statCardWidth,
                                              patient: patient,
                                              metricID: "Calories_Burned",
                                              cardTitle:
                                                  "Total calories burned",
                                              statType: "Total",
                                            ),
                                            StatCard(
                                              height: statCardHeight,
                                              width: statCardWidth,
                                              patient: patient,
                                              metricID: "Duration",
                                              cardTitle:
                                                  "Total time played\n(HH:MM:SS)",
                                              statType: "Total",
                                              convertValue: "Time",
                                            ),
                                            StatCard(
                                              height: statCardHeight,
                                              width: statCardWidth,
                                              patient: patient,
                                              metricID: "Arm_Movement",
                                              cardTitle: "Total arm movement",
                                              statType: "Total",
                                              convertValue: "Length",
                                            ),
                                            StatCard(
                                              height: statCardHeight,
                                              width: statCardWidth,
                                              patient: patient,
                                              metricID: "Score",
                                              cardTitle:
                                                  "Total score collected across all minigames",
                                              statType: "Total",
                                            ),
                                            // PLATFORM MINIGAME STATS
                                            StatCard(
                                              height: statCardHeight,
                                              width: statCardWidth,
                                              patient: patient,
                                              metricID: "Hittable_Hits",
                                              cardTitle:
                                                  "Hittables hit in \nPlatform Minigame",
                                              statType: "Total",
                                              chosenMinigameId:
                                                  "Platform_Minigame",
                                              includeAllMinigames: false,
                                            ),
                                            StatCard(
                                              height: statCardHeight,
                                              width: statCardWidth,
                                              patient: patient,
                                              metricID: "Score",
                                              cardTitle:
                                                  "Highscore\n(Platform Minigame)",
                                              statType: "Highest",
                                              chosenMinigameId:
                                                  "Platform_Minigame",
                                              includeAllMinigames: false,
                                            ),
                                            // REACTION TIME TRAINER STATS
                                            StatCard(
                                              height: statCardHeight,
                                              width: statCardWidth,
                                              patient: patient,
                                              metricID: "WaterBubbles_Hit",
                                              cardTitle:
                                                  "Water bubbles reacted to in Reaction Time Trainer",
                                              statType: "Total",
                                              chosenMinigameId:
                                                  "ReactionTimeTrainer_Minigame",
                                              includeAllMinigames: false,
                                            ),
                                            StatCard(
                                              height: statCardHeight,
                                              width: statCardWidth,
                                              patient: patient,
                                              metricID: "Score",
                                              cardTitle:
                                                  "Highscore\n(Reaction Time Trainer)",
                                              statType: "Highest",
                                              chosenMinigameId:
                                                  "ReactionTimeTrainer_Minigame",
                                              includeAllMinigames: false,
                                            ),
                                            StatCard(
                                              height: statCardHeight,
                                              width: statCardWidth,
                                              patient: patient,
                                              metricID: "Average_ReactionTime",
                                              cardTitle:
                                                  "Average reaction time in Reaction Time Trainer",
                                              statType: "Average",
                                              convertValue: "ms",
                                            ),
                                            StatCard(
                                              height: statCardHeight,
                                              width: statCardWidth,
                                              patient: patient,
                                              metricID: "Average_ReactionTime",
                                              cardTitle:
                                                  "Best average reaction time in Reaction Time Trainer",
                                              statType: "Lowest",
                                              convertValue: "ms",
                                            ),
                                            // DRONE SHOOTER STATS
                                            StatCard(
                                              height: statCardHeight,
                                              width: statCardWidth,
                                              patient: patient,
                                              metricID: "Duration",
                                              cardTitle:
                                                  "Time spent shooting drones\n(HH:MM:SS)",
                                              statType: "Total",
                                              convertValue: "Time",
                                              chosenMinigameId:
                                                  "DuckShooter_Minigame",
                                              includeAllMinigames: false,
                                            ),
                                            StatCard(
                                              height: statCardHeight,
                                              width: statCardWidth,
                                              patient: patient,
                                              metricID: "Drones_Hit",
                                              cardTitle:
                                                  "Drones hit in Drone Shooter",
                                              statType: "Total",
                                              chosenMinigameId:
                                                  "DuckShooter_Minigame",
                                              includeAllMinigames: false,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
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
