import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Screens/Components/BarChart/bar_chart_data.dart';
import 'package:maneja_tus_cuentas/Screens/Components/BarChart/net_worth_bar_chart.dart';
import '../Components/PieChart/pie_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var map = {"pizza": 2.0, "sushi": 1.0, "pasta": 3.0};
    var barChartList = [
      BarChartData(category: "Ingresos", total: 100),
      BarChartData(category: "Gastos", total: 200)
    ];
    return Column(
      children: [
        NetworthBarChart(chartDataList: barChartList),
        StatisticsPieChart(dataMap: map, chartTitle: "Gastos")
      ],
    );
  }
}
