// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontendflutter/src/handlers/tools.dart';
import 'package:frontendflutter/src/model_classes/minigame.dart';
import 'package:frontendflutter/src/model_classes/patient.dart';

class StatCard extends StatelessWidget {
  @required
  final double height;

  @required
  final double width;

  @required
  final Patient patient;

  @required
  final String metricID;

  @required
  final String cardTitle;

  // Stat type can be: Average, Highest, Lowest, Total // TODO: more?
  @required
  final String statType;

  @required
  final bool includeAllMinigames;

  final String chosenMinigameId;

  // Convert value can be: Time, Length (meters/kilometers), ms, more?
  final String convertValue;

  // These below could be added and optional in the future for more different type of stats
  // final Minigame chosenMinigame;
  // final String chosenTimeFrame;

  StatCard(
      {this.height,
      this.width,
      this.patient,
      this.metricID,
      this.cardTitle,
      this.statType,
      this.includeAllMinigames: true,
      this.chosenMinigameId,
      this.convertValue: "No"});

  @override
  Widget build(BuildContext context) {
    // Data to be received
    int currentValue = 0;
    String outputString = "";
    bool valueAdded = false;

    getData() {
      int count = 0;
      // int sameDateCount = 0;
      // DateTime prevDate;
      // int currentTotalValue = 0;

      switch (statType) {
        case "Total":
          {
            patient.sessions?.forEach((session) {
              session.activities?.forEach((activity) {
                // If the minigameID is a match, or we use all minigames we check if it has the metric we are looking for
                if (includeAllMinigames ||
                    activity.minigameID == chosenMinigameId) {
                  activity.metrics?.forEach((metric) {
                    // If metric exist, we append it to the list of points that will be drawn
                    if (metric.id == metricID) {
                      valueAdded = true;
                      currentValue += metric.value;
                    }
                  });
                }
              });
            });
            break;
          }
        case "Highest":
          {
            patient.sessions?.forEach((session) {
              session.activities?.forEach((activity) {
                // If the minigameID is a match, or we use all minigames we check if it has the metric we are looking for
                if (includeAllMinigames ||
                    activity.minigameID == chosenMinigameId) {
                  activity.metrics?.forEach((metric) {
                    // If metric exist, we append it to the list of points that will be drawn
                    if (metric.id == metricID) {
                      if (metric.value > currentValue) {
                        valueAdded = true;
                        currentValue = metric.value;
                      }
                    }
                  });
                }
              });
            });
            break;
          }
        case "Lowest":
          {
            // setting value to 'infinity' before starting this because we are supposed to find lowest value
            currentValue = 9999999;

            patient.sessions?.forEach((session) {
              session.activities?.forEach((activity) {
                // If the minigameID is a match, or we use all minigames we check if it has the metric we are looking for
                if (includeAllMinigames ||
                    activity.minigameID == chosenMinigameId) {
                  activity.metrics?.forEach((metric) {
                    // If metric exist, we append it to the list of points that will be drawn
                    if (metric.id == metricID) {
                      if (metric.value != 0) {
                        // Avoiding values that have not been set by mistake
                        if (metric.value < currentValue) {
                          valueAdded = true;
                          currentValue = metric.value;
                        }
                      }
                    }
                  });
                }
              });
            });
            break;
          }
        case "Average":
          {
            patient.sessions?.forEach((session) {
              session.activities?.forEach((activity) {
                // If the minigameID is a match, or we use all minigames we check if it has the metric we are looking for
                if (includeAllMinigames ||
                    activity.minigameID == chosenMinigameId) {
                  activity.metrics?.forEach((metric) {
                    // If metric exist, we append it to the list of points that will be drawn
                    if (metric.id == metricID) {
                      valueAdded = true;
                      count++;
                      currentValue += metric.value;
                    }
                  });
                }
              });
            });

            if (valueAdded) {
              currentValue = currentValue ~/ count;
            }
            break;
          }
        default:
          {
            break;
          }
      }

      outputString = currentValue.toString();

      if (convertValue == "Time") {
        outputString = Tools.secondsToHHMMSS(currentValue);
      }
      if (convertValue == "Length") {
        outputString = Tools.metersToStringLength(currentValue);
      }
      if (convertValue == "ms") {
        outputString = currentValue.toString() + " ms";
      }
    }

    // Calling get data to update value
    getData();

    return Container(
      padding: EdgeInsets.all(4),
      height: height,
      width: width,
      child: Card(
        // color: Colors.lightBlue,
        shadowColor: Colors.black,
        // elevation: 2,
        // TODO: potentially think about and consider changing colors of the card to make it pop more
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withAlpha(20),
                Colors.white,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: height / 3.1,
                // padding: EdgeInsets.only(top: 20),
                child: SelectableText(cardTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 16)),
              ),
              Container(
                height: height / 3.1,
                // padding: EdgeInsets.only(bottom: 48),
                child: SelectableText(outputString,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 18)),
              ),
              // Empty container for styling
              Container(
                  // height: height / 3.1,
                  )
            ],
          ),
        ),
      ),
    );
  }
}
