import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Model/Budget.dart';
import 'package:maneja_tus_cuentas/Model/Movement.dart';
import 'package:maneja_tus_cuentas/Screens/Components/BarChart/achievments_bar_chart.dart';
import 'package:maneja_tus_cuentas/Screens/Components/BarChart/achievments_worth_bar_chart.dart';
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
  List<BarChartData> barChartDataList = [];
  Map<String, double> pieChartDataSpending = {};
  Map<String, double> pieChartDataIncome = {};

  Map<String, double> pieChartAchievmentsDone = {};
  Map<String, double> pieChartAchievmentsInProgress = {};
  List<BarChartData> amountAndSpendingList = [];
  List<BarChartData> achievmentsList = [];

  bool isLoadingAchievments = true;
  bool isLoadingHistory = true;
  List<Widget> widgetArray = [];
  var currentScreenIndex = 0;
  List<String> titles = ["Historial", "Metas"];

  final DatabaseService _databaseService =
      DatabaseService(uid: AuthService().currentUser!.uid);

  void addHistoryElements(List<Movement> l) {
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
      isLoadingHistory = false;
    });
  }

  void addAchievmentsElements(List<Budget> budgets) {
    var completed = 0;
    var uncompleted = 0;
    var totalAmount = 0.0;
    var totalSpent = 0.0;
    var mapDone = <String, double>{};
    var mapInProgress = <String, double>{};
    for (var b in budgets) {
      if (b.completed == true) {
        completed++;
        mapDone.update(b.category.name, (value) => 1 + value,
            ifAbsent: () => 1);
      } else {
        uncompleted++;
        mapInProgress.update(b.category.name, (value) => 1 + value,
            ifAbsent: () => 1);
      }
      totalAmount += b.amount;
      totalSpent += b.spent;
    }

    var totalGoals = BarChartData(
        category: "Metas totales", total: (completed + uncompleted).toDouble());
    var unAchievedGoals = BarChartData(
        category: "Metas en progreso", total: uncompleted.toDouble());
    var achievedGoals =
        BarChartData(category: "Metas logradas", total: completed.toDouble());

    var totalSpentData =
        BarChartData(category: "Monto invertido", total: totalSpent);
    var totalAmountData =
        BarChartData(category: "Monto total", total: totalAmount);

    setState(() {
      pieChartAchievmentsDone = mapDone;
      pieChartAchievmentsInProgress = mapInProgress;
      achievmentsList = [totalGoals, unAchievedGoals, achievedGoals];
      amountAndSpendingList = [totalAmountData, totalSpentData];
      widgetArray = [renderHistoryScreen(), renderAchievmentsScreen()];
      isLoadingAchievments = false;
    });
  }

  void setInitialData() {
    _databaseService.movements
        .forEach((element) => addHistoryElements(element));
    _databaseService.budgets
        .forEach((element) => addAchievmentsElements(element));
  }

  @override
  void initState() {
    super.initState();
    setInitialData();
  }

  Widget renderHistoryScreen() {
    var childrenArray = <Widget>[];
    if (pieChartDataSpending.isNotEmpty) {
      childrenArray.add(StatisticsPieChart(
          dataMap: pieChartDataSpending, chartTitle: "Gastos"));
    }

    if (pieChartDataIncome.isNotEmpty) {
      childrenArray.add(StatisticsPieChart(
          dataMap: pieChartDataIncome, chartTitle: "Ingresos"));
    }

    childrenArray.addAll([
      NetworthBarChart(
          chartDataList: barChartDataList, title: "Patrimonio Neto"),
      const SizedBox(height: 100)
    ]);
    return ListView(
      padding: const EdgeInsets.all(10),
      children: childrenArray,
    );
  }

  Widget renderAchievmentsScreen() {
    var childrenArray = <Widget>[];

    if (pieChartAchievmentsDone.isNotEmpty) {
      childrenArray.add(StatisticsPieChart(
          dataMap: pieChartAchievmentsDone, chartTitle: "Metas\nAlcanzadas"));
    }

    if (pieChartAchievmentsInProgress.isNotEmpty) {
      childrenArray.add(StatisticsPieChart(
          dataMap: pieChartAchievmentsInProgress,
          chartTitle: "Metas\nEn Progreso"));
    }

    childrenArray.addAll([
      AchievmentsBarChart(
        chartDataList: achievmentsList,
        title: "Progreso De Metas",
      ),
      AchievmentsWorthBarChart(
        chartDataList: amountAndSpendingList,
        title: "Dinero Invertido En Metas",
      ),
      const SizedBox(height: 100)
    ]);

    return ListView(
      padding: const EdgeInsets.all(10),
      children: childrenArray,
    );
  }


  @override
  Widget build(BuildContext context) {
    if (isLoadingAchievments || isLoadingHistory) {
      return const Center(child : CircularProgressIndicator());
    }

    return DefaultTabController(
        length: titles.length,
        initialIndex: 0,
        child: Scaffold(
            appBar: TabBar(
              tabs: [Tab(text: titles[0]), Tab(text: titles[1])],
              indicatorColor: Colors.green,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
            ),
            body: TabBarView(
                children: [renderHistoryScreen(), renderAchievmentsScreen()])));
  }
}
