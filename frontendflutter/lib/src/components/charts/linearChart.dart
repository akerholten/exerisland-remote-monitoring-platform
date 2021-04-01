import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontendflutter/src/constants/constants.dart';
import 'package:frontendflutter/src/handlers/tools.dart';
import 'package:frontendflutter/src/model_classes/metric.dart';
import 'package:frontendflutter/src/model_classes/minigame.dart';
import 'package:frontendflutter/src/model_classes/patient.dart';
import 'package:intl/intl.dart' as intl;

class LinearChart extends StatelessWidget {
  final Patient patient;
  final Metric chosenMetric;
  final Minigame chosenMinigame;
  final String chosenTimeFrame;

  LinearChart(
      {this.patient,
      this.chosenMetric,
      this.chosenMinigame,
      this.chosenTimeFrame});

  @override
  Widget build(BuildContext context) {
    // Receiving the datapoints existing on graph
    List<FlSpot> dataPoints;
    List<String> bottomTitles;
    int currentMaxValue = 0;

    // STYLING
    List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];

    getData() {
      dataPoints = new List<FlSpot>();
      bottomTitles = new List<String>();

      int count = 0;
      int sameDateCount = 0;
      DateTime prevDate;
      int currentTotalValue = 0;

      checkAndUpdateMaxValue(int newValue) {
        if (newValue > currentMaxValue) {
          currentMaxValue = newValue;
        }
      }

      switch (chosenTimeFrame) {
        case "Activity":
          {
            patient.sessions?.forEach((session) {
              session.activities?.forEach((activity) {
                // If the minigameID is a match we check if it has the metric we are looking for
                if (activity.minigameID == chosenMinigame.id) {
                  activity.metrics?.forEach((metric) {
                    // If metric exist, we append it to the list of points that will be drawn
                    if (metric.id == chosenMetric.id) {
                      count++;

                      checkAndUpdateMaxValue(metric.value);

                      dataPoints.add(
                          FlSpot(count.toDouble(), metric.value.toDouble()));
                      bottomTitles.add(count
                          .toString()); //intl.DateFormat(Constants.dateFormat).format(DateTime.parse(session.createdAt))
                      //TODO: Consider using date or not
                    }
                  });
                }
              });
            });
            break;
          }
        case "Daily total":
          {
            {
              patient.sessions?.forEach((session) {
                DateTime currentSessionDate = DateTime.parse(session.createdAt);
                session.activities?.forEach((activity) {
                  // If the minigameID is a match we check if it has the metric we are looking for
                  if (activity.minigameID == chosenMinigame.id) {
                    activity.metrics?.forEach((metric) {
                      // If metric exist, we append it to the list of points that will be drawn
                      if (metric.id == chosenMetric.id) {
                        // If it is the same date, we update the existing datapoint with the added value
                        if (prevDate != null &&
                            currentSessionDate.day == prevDate.day &&
                            currentSessionDate.month == prevDate.month &&
                            currentSessionDate.year == prevDate.year) {
                          currentTotalValue += metric.value;

                          checkAndUpdateMaxValue(currentTotalValue);

                          dataPoints[count - 1] = dataPoints[count - 1]
                              .copyWith(y: currentTotalValue.toDouble());
                        } else {
                          // They are not same date, this is a new datapoint
                          prevDate = currentSessionDate;
                          currentTotalValue = metric.value;
                          count++;

                          dataPoints.add(FlSpot(
                              count.toDouble(), currentTotalValue.toDouble()));
                          bottomTitles.add(intl.DateFormat(Constants.dateFormat)
                              .format(DateTime.parse(session.createdAt)));
                        }
                      }
                    });
                  }
                });
              });
            }
            break;
          }
        case "Activity average (daily)":
          {
            {
              patient.sessions?.forEach((session) {
                DateTime currentSessionDate = DateTime.parse(session.createdAt);
                session.activities?.forEach((activity) {
                  // If the minigameID is a match we check if it has the metric we are looking for
                  if (activity.minigameID == chosenMinigame.id) {
                    activity.metrics?.forEach((metric) {
                      // If metric exist, we append it to the list of points that will be drawn
                      if (metric.id == chosenMetric.id) {
                        // If it is the same date, we update the existing datapoint with the added value
                        if (prevDate != null &&
                            currentSessionDate.day == prevDate.day &&
                            currentSessionDate.month == prevDate.month &&
                            currentSessionDate.year == prevDate.year) {
                          currentTotalValue += metric.value;
                          sameDateCount += 1;

                          checkAndUpdateMaxValue(
                              (currentTotalValue / sameDateCount).toInt());

                          dataPoints[count - 1] = dataPoints[count - 1]
                              .copyWith(
                                  y: (currentTotalValue / sameDateCount)
                                      .toDouble());
                        } else {
                          // They are not same date, this is a new datapoint
                          sameDateCount = 1;
                          prevDate = currentSessionDate;
                          currentTotalValue = metric.value;
                          count++;

                          dataPoints.add(FlSpot(
                              count.toDouble(), currentTotalValue.toDouble()));
                          bottomTitles.add(intl.DateFormat(Constants.dateFormat)
                              .format(DateTime.parse(session.createdAt)));
                        }
                      }
                    });
                  }
                });
              });
            }
            break;
          }
        case "Weekly total":
          {
            {
              int prevWeek;
              int prevYear;
              patient.sessions?.forEach((session) {
                DateTime currentSessionDate = DateTime.parse(session.createdAt);
                session.activities?.forEach((activity) {
                  // If the minigameID is a match we check if it has the metric we are looking for
                  if (activity.minigameID == chosenMinigame.id) {
                    activity.metrics?.forEach((metric) {
                      // If metric exist, we append it to the list of points that will be drawn
                      if (metric.id == chosenMetric.id) {
                        // If it is the same date, we update the existing datapoint with the added value
                        if (prevWeek != null &&
                            Tools.weekNumber(currentSessionDate) == prevWeek &&
                            currentSessionDate.year == prevYear) {
                          currentTotalValue += metric.value;

                          checkAndUpdateMaxValue(currentTotalValue);

                          dataPoints[count - 1] = dataPoints[count - 1]
                              .copyWith(y: currentTotalValue.toDouble());
                        } else {
                          // They are not same date, this is a new datapoint
                          prevWeek = Tools.weekNumber(currentSessionDate);
                          prevYear = currentSessionDate.year;
                          currentTotalValue = metric.value;
                          count++;

                          dataPoints.add(FlSpot(
                              count.toDouble(), currentTotalValue.toDouble()));
                          bottomTitles.add("Week " +
                              prevWeek.toString() +
                              " " +
                              currentSessionDate.year.toString());
                        }
                      }
                    });
                  }
                });
              });
            }
            break;
          }
        case "Activity average (weekly)":
          {
            {
              int prevWeek;
              int prevYear;
              patient.sessions?.forEach((session) {
                DateTime currentSessionDate = DateTime.parse(session.createdAt);
                session.activities?.forEach((activity) {
                  // If the minigameID is a match we check if it has the metric we are looking for
                  if (activity.minigameID == chosenMinigame.id) {
                    activity.metrics?.forEach((metric) {
                      // If metric exist, we append it to the list of points that will be drawn
                      if (metric.id == chosenMetric.id) {
                        // If it is the same date, we update the existing datapoint with the added value
                        if (prevWeek != null &&
                            Tools.weekNumber(currentSessionDate) == prevWeek &&
                            currentSessionDate.year == prevYear) {
                          currentTotalValue += metric.value;
                          sameDateCount += 1;

                          checkAndUpdateMaxValue(
                              (currentTotalValue / sameDateCount).toInt());

                          dataPoints[count - 1] = dataPoints[count - 1]
                              .copyWith(
                                  y: (currentTotalValue / sameDateCount)
                                      .toDouble());
                        } else {
                          // They are not same date, this is a new datapoint
                          sameDateCount = 1;
                          prevWeek = Tools.weekNumber(currentSessionDate);
                          prevYear = currentSessionDate.year;
                          currentTotalValue = metric.value;
                          count++;

                          dataPoints.add(FlSpot(
                              count.toDouble(), currentTotalValue.toDouble()));
                          bottomTitles.add("Week " +
                              prevWeek.toString() +
                              " " +
                              currentSessionDate.year.toString());
                        }
                      }
                    });
                  }
                });
              });
            }
            break;
          }
        case "Monthly total":
          {
            {
              int prevMonth;
              int prevYear;
              patient.sessions?.forEach((session) {
                DateTime currentSessionDate = DateTime.parse(session.createdAt);
                session.activities?.forEach((activity) {
                  // If the minigameID is a match we check if it has the metric we are looking for
                  if (activity.minigameID == chosenMinigame.id) {
                    activity.metrics?.forEach((metric) {
                      // If metric exist, we append it to the list of points that will be drawn
                      if (metric.id == chosenMetric.id) {
                        // If it is the same date, we update the existing datapoint with the added value
                        if (prevMonth != null &&
                            currentSessionDate.month == prevMonth &&
                            currentSessionDate.year == prevYear) {
                          currentTotalValue += metric.value;

                          checkAndUpdateMaxValue(currentTotalValue);

                          dataPoints[count - 1] = dataPoints[count - 1]
                              .copyWith(y: currentTotalValue.toDouble());
                        } else {
                          // They are not same date, this is a new datapoint
                          prevMonth = currentSessionDate.month;
                          prevYear = currentSessionDate.year;
                          currentTotalValue = metric.value;
                          count++;

                          dataPoints.add(FlSpot(
                              count.toDouble(), currentTotalValue.toDouble()));
                          bottomTitles.add(prevMonth.toString() +
                              "/" +
                              currentSessionDate.year.toString());
                        }
                      }
                    });
                  }
                });
              });
            }
            break;
          }
        case "Activity average (monthly)":
          {
            {
              int prevMonth;
              int prevYear;
              patient.sessions?.forEach((session) {
                DateTime currentSessionDate = DateTime.parse(session.createdAt);
                session.activities?.forEach((activity) {
                  // If the minigameID is a match we check if it has the metric we are looking for
                  if (activity.minigameID == chosenMinigame.id) {
                    activity.metrics?.forEach((metric) {
                      // If metric exist, we append it to the list of points that will be drawn
                      if (metric.id == chosenMetric.id) {
                        // If it is the same date, we update the existing datapoint with the added value
                        if (prevMonth != null &&
                            currentSessionDate.month == prevMonth &&
                            currentSessionDate.year == prevYear) {
                          currentTotalValue += metric.value;
                          sameDateCount += 1;

                          checkAndUpdateMaxValue(
                              (currentTotalValue / sameDateCount).toInt());

                          dataPoints[count - 1] = dataPoints[count - 1]
                              .copyWith(
                                  y: (currentTotalValue / sameDateCount)
                                      .toDouble());
                        } else {
                          // They are not same date, this is a new datapoint
                          sameDateCount = 1;
                          prevMonth = currentSessionDate.month;
                          prevYear = currentSessionDate.year;
                          currentTotalValue = metric.value;
                          count++;

                          dataPoints.add(FlSpot(
                              count.toDouble(), currentTotalValue.toDouble()));
                          bottomTitles.add(prevMonth.toString() +
                              "/" +
                              currentSessionDate.year.toString());
                        }
                      }
                    });
                  }
                });
              });
            }
            break;
          }

        default:
          {
            break;
          }
      }
    }

    getInterval() {
      if (currentMaxValue >= 50000) {
        return 5000;
      }
      if (currentMaxValue >= 10000) {
        return 2000;
      }
      if (currentMaxValue >= 5000) {
        return 500;
      }
      if (currentMaxValue >= 1000) {
        return 200;
      }
      if (currentMaxValue >= 500) {
        return 50;
      }
      if (currentMaxValue >= 100) {
        return 20;
      }
      if (currentMaxValue >= 50) {
        return 5;
      }
      if (currentMaxValue >= 10) {
        return 2;
      }
      return 1;
    }

    // calling the getData functionality
    getData();

    if (dataPoints.length <= 0) {
      return Center(child: SelectableText("No data found"));
    }
    // The lines to be drawn on chart
    List<LineChartBarData> lines = [
      LineChartBarData(
        spots: dataPoints,
        isCurved: true,
        colors: [
          ColorTween(
                  begin: Theme.of(context).primaryColor,
                  end: Theme.of(context).primaryColor)
              .lerp(0.2),
          ColorTween(
                  begin: Theme.of(context).primaryColor,
                  end: Theme.of(context).primaryColor)
              .lerp(0.2),
        ],
        dotData: FlDotData(
          show: true,
        ),
        barWidth: 3,
        // isStrokeCapRound: true,
        belowBarData: BarAreaData(show: true, colors: [
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2)
              .withOpacity(0.04),
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.6)
              .withOpacity(0.08),
        ]),
      )
    ];

    // The overall chartData as input
    LineChartData chartData = new LineChartData(
      minY: 0,
      lineBarsData: lines,
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 18,
            getTextStyles: (value) =>
                Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 12),
            getTitles: (value) {
              return bottomTitles.elementAt(value.toInt() -
                  1); // it is offset by 1 because value starts at 1 and not 0
            }),
        leftTitles: SideTitles(
          showTitles: true,
          interval: getInterval().toDouble(),
          getTextStyles: (value) =>
              Theme.of(context).textTheme.subtitle1.copyWith(
                    // color: Theme.of(context).hintColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
          getTitles: (value) {
            return value.toString();
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      axisTitleData: FlAxisTitleData(
        topTitle: AxisTitle(
            showTitle: true,
            textStyle:
                Theme.of(context).textTheme.headline6.copyWith(fontSize: 14),
            titleText: chosenMetric.name +
                " in " +
                chosenMetric.unit +
                " for " +
                chosenMinigame.name,
            margin: 4),
        leftTitle: AxisTitle(
            showTitle: true,
            textStyle:
                Theme.of(context).textTheme.headline6.copyWith(fontSize: 14),
            titleText: chosenMetric.unit,
            margin: 4),
        bottomTitle: AxisTitle(
            showTitle: true,
            margin: 0,
            textStyle:
                Theme.of(context).textTheme.headline6.copyWith(fontSize: 14),
            titleText: chosenTimeFrame,
            textAlign: TextAlign.right),
      ),
    );

    return new LineChart(chartData);
  }
}
