import 'package:flutter/material.dart';
import 'package:frontendflutter/src/model_classes/metric.dart';
import '../../components/alerts.dart';

class MetricList extends StatefulWidget {
  @required
  final List<Metric> metrics;

  @required
  final double dataTableMaxWidth;

  MetricList({this.metrics, this.dataTableMaxWidth});

  @override
  _MetricListState createState() => _MetricListState();
}

class _MetricListState extends State<MetricList> {
  List<String> columnTitles = [
    'Metric',
    'Value',
  ];

  @override
  Widget build(BuildContext context) {
    double tableItemWidth =
        (widget.dataTableMaxWidth * 0.75) / columnTitles.length;
    double tableItemHeight = 70;

    ScrollController _controller = new ScrollController();

    Widget tableHeader() {
      return Container(
        // padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: (columnTitles.map(
                (item) => Container(
                  alignment: Alignment.center,
                  height: tableItemHeight,
                  width: tableItemWidth,
                  child: SelectableText(
                    item,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 16),
                  ),
                ),
              )).toList(),
            ),
            Container(
              height: 1,
              width: double.maxFinite,
              color: Theme.of(context).dividerColor,
            ),
          ],
        ),
      );
    }

    Widget tableRows() {
      return Expanded(
        child: Scrollbar(
          controller: _controller,
          isAlwaysShown: true,
          child: widget.metrics == null
              ? Center(
                  child:
                      SelectableText("Select an activity to see its metrics"),
                ) // TODO: Possibly add more options here (select all, etc)
              : ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _controller,
                  shrinkWrap: true,
                  children: (widget.metrics
                      .map((metric) => FlatButton(
                            // TODO: Possibly remove flatbutton?
                            onPressed: (() {
                              Alerts.showWarning(
                                  "Not implemented yet, or uncertain if this even should do anything?");
                            }),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: tableItemHeight,
                                      width: tableItemWidth,
                                      child: SelectableText(metric.name),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      height: tableItemHeight,
                                      width: tableItemWidth,
                                      child: SelectableText(
                                          metric.value.toString() +
                                              " " +
                                              metric.unit),
                                      // TODO: Possibly make a helper function that creates a better text
                                      // based on the metric.unit type (e.g. duration, completion, etc etc)
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 1,
                                  width: double.maxFinite,
                                  color: Theme.of(context).dividerColor,
                                ),
                              ],
                            ),
                          ))
                      .toList()),
                ),
        ),
      );
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [tableHeader(), tableRows()]);
  }
}
