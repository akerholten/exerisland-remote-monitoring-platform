// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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

  final Minigame chosenMinigame;

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
      this.chosenMinigame});

  @override
  Widget build(BuildContext context) {
    // Data to be received
    int currentValue = 0;

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
                    activity.minigameID == chosenMinigame.id) {
                  activity.metrics?.forEach((metric) {
                    // If metric exist, we append it to the list of points that will be drawn
                    if (metric.id == metricID) {
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
                    activity.minigameID == chosenMinigame.id) {
                  activity.metrics?.forEach((metric) {
                    // If metric exist, we append it to the list of points that will be drawn
                    if (metric.id == metricID) {
                      if (metric.value > currentValue) {
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
                    activity.minigameID == chosenMinigame.id) {
                  activity.metrics?.forEach((metric) {
                    // If metric exist, we append it to the list of points that will be drawn
                    if (metric.id == metricID) {
                      if (metric.value < currentValue) {
                        currentValue = metric.value;
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
                    activity.minigameID == chosenMinigame.id) {
                  activity.metrics?.forEach((metric) {
                    // If metric exist, we append it to the list of points that will be drawn
                    if (metric.id == metricID) {
                      count++;
                      currentValue += metric.value;
                    }
                  });
                }
              });
            });

            currentValue = currentValue ~/ count;
            break;
          }
        default:
          {
            break;
          }
      }
    }

    // Calling get data to update value
    getData();

    return Container(
      padding: EdgeInsets.all(4),
      height: height,
      width: width,
      child: Card(
        // TODO: potentially think about and consider changing colors of the card to make it pop more
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(cardTitle, style: Theme.of(context).textTheme.subtitle1),
            Text(currentValue.toString(),
                style: Theme.of(context).textTheme.subtitle2)
          ],
        ),
      ),
    );
  }
}
