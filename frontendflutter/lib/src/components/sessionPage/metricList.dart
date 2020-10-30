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
  @override
  Widget build(BuildContext context) {
    double tableItemWidth =
        (widget.dataTableMaxWidth * 0.75) / 2; // 2 == columnTitles.length
    double tableItemHeight = 70;

    ScrollController _controller = new ScrollController();

    Widget tableHeader() {
      return Container(
        // padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 5),
                height: tableItemHeight,
                width: tableItemWidth,
                child: SelectableText(
                  "Metric",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 16),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 5),
                height: tableItemHeight,
                width: tableItemWidth,
                child: SelectableText(
                  "Value",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 16),
                ),
              ),
            ]),
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
      return Container(
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
                      .map((metric) => Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // METRIC NAME
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 5),
                                    height: tableItemHeight,
                                    width: tableItemWidth,
                                    child: SelectableText(metric.name),
                                  ),
                                  // METRIC VALUE
                                  Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(right: 5),
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
