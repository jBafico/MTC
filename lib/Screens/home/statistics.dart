import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Model/Movement.dart';
import 'package:maneja_tus_cuentas/Screens/Components/BarChart/bar_chart_data.dart';
import 'package:maneja_tus_cuentas/Screens/Components/BarChart/net_worth_bar_chart.dart';
import 'package:maneja_tus_cuentas/Services/auth.dart';
import 'package:maneja_tus_cuentas/Services/database.dart';
import '../Components/PieChart/pie_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {

  late List<BarChartData> barChartDataList;
  late Map<String, double> pieChartDataSpending;
  late Map<String, double> pieChartDataIncome;
  bool isLoading = true;

  final DatabaseService _databaseService = DatabaseService(
      uid: AuthService().currentUser!.uid);

  void addElements(List<Movement> l) {
    var income = 0.0;
    var spend = 0.0;
    var pieChartDataMapSpending = <String, double>{};
    var pieChartDataMapIncome = <String, double>{};

    for (var mov in l) {
      if (mov.type == "spending") {
        pieChartDataMapSpending.update(
            mov.category.name, (value) => value + mov.amount,
            ifAbsent: () => mov.amount);
        spend += mov.amount;
      } else {
        pieChartDataMapIncome.update(
            mov.category.name, (value) => value + mov.amount,
            ifAbsent: () => mov.amount);
        income += mov.amount;
      }
    }
    var incomeData = BarChartData(category: "Ingresos", total: income);
    var spendData = BarChartData(category: "Gastos", total: spend);
    setState(() {
      pieChartDataSpending = pieChartDataMapSpending;
      pieChartDataIncome = pieChartDataMapIncome;
      barChartDataList = [spendData, incomeData];
      isLoading = false;
    });
  }

  void setInitialData() {
    _databaseService.movements.forEach((element) => addElements(element));
  }

  @override
  Widget build(BuildContext context) {
    setInitialData();

    if (isLoading) {
      return const Text("Loading statistics Data");
    }

    var childrenArray = <Widget>[
      NetworthBarChart(chartDataList: barChartDataList)
    ];
    if (pieChartDataSpending.isNotEmpty) {
      childrenArray.add(StatisticsPieChart(
          dataMap: pieChartDataSpending, chartTitle: "Gastos"));
    }

    if (pieChartDataIncome.isNotEmpty) {
      childrenArray.add(StatisticsPieChart(
          dataMap: pieChartDataIncome, chartTitle: "Ingresos"));
    }
    return ListView(
        children: childrenArray,
      );
  }
}

