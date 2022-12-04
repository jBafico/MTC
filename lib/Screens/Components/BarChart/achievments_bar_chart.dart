




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Screens/Components/BarChart/net_worth_bar_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'bar_chart_data.dart';

class AchievmentsBarChart extends NetworthBarChart {

  const AchievmentsBarChart({Key? key,required List<BarChartData> chartDataList, required String title}) : super(key: key, chartDataList: chartDataList,title: title);

  @override
  MaterialColor getColor(String category){
     return category == "Metas totales" ? Colors.grey: category == "Metas logradas" ? Colors.green:Colors.red;
  }

}
