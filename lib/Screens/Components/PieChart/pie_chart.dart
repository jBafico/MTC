
import 'package:flutter/cupertino.dart';
import 'package:pie_chart/pie_chart.dart';

class StatisticsPieChart extends StatelessWidget {
  final Map<String, double> dataMap;
  final String chartTitle;
  const StatisticsPieChart({super.key, required this.dataMap, required this.chartTitle});

  @override
  Widget build(BuildContext context) {
    const options = ChartValuesOptions(showChartValuesInPercentage: true);
    return PieChart(
      dataMap: dataMap,
      chartType: ChartType.disc,
      chartValuesOptions: options,
      centerText: chartTitle,
    );
  }
}
