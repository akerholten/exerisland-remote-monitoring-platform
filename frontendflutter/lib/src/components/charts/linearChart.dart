import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontendflutter/src/constants/constants.dart';
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

    // STYLING
    List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];

    getData() {
      dataPoints = new List<FlSpot>();
      bottomTitles = new List<String>();

      int count = 0;

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
                      dataPoints.add(
                          FlSpot(count.toDouble(), metric.value.toDouble()));
                      bottomTitles.add(intl.DateFormat(Constants.dateFormat)
                          .format(DateTime.parse(session.createdAt)));
                    }
                  });
                }
              });
            });
            break;
          }
        case "Daily":
          {
            // TODO: Similar as "Activity"
            break;
          }
        case "Weekly":
          {
            // TODO: Similar as "Activity"
            break;
          }
        case "Monthly":
          {
            // TODO: Similar as "Activity"
            break;
          }
        default:
          {
            break;
          }
      }
      if (chosenTimeFrame == "Activity") {}
    }

    // calling the getData functionality
    getData();

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
              return bottomTitles.elementAt(value.toInt());
            }),
        leftTitles: SideTitles(
          showTitles: true,
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
