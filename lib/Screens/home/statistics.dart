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
  late Map<String,double> pieChartData;
  bool isLoading = true;

  final DatabaseService _databaseService = DatabaseService(uid: AuthService().currentUser!.uid);

  void addElements(List<Movement> l){
    var income = 0.0;
    var spend = 0.0;
    var pieChartDataMap = <String,double>{};
    for ( var mov in l){
      if ( mov.type == "spending"){
        pieChartDataMap.update(mov.category.name, (value) => value + mov.amount,ifAbsent:  () => mov.amount);
        spend += mov.amount;
      } else {
        income += mov.amount;
      }
    }
    var incomeData = BarChartData(category: "Ingresos", total: income);
    var spendData = BarChartData(category: "Gastos", total: spend);
    setState(() {
      pieChartData = pieChartDataMap;
      barChartDataList = [spendData,incomeData];
      isLoading = false;
    });
  }

  void setInitialData(){
    _databaseService.movements.forEach((element) => addElements(element) );
  }

  @override
  Widget build(BuildContext context) {
    setInitialData();

    if ( isLoading ){
      return const Text("Loading statistics Data");
    }

    var childrenArray =  <Widget>[NetworthBarChart(chartDataList: barChartDataList)];
    if (pieChartData.isNotEmpty ) {
      childrenArray.add(StatisticsPieChart(dataMap: pieChartData, chartTitle: "Gastos"));
    }
    return Column(
      children: childrenArray,
    );
  }
}

