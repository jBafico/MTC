



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Screens/Components/BarChart/net_worth_bar_chart.dart';

import 'bar_chart_data.dart';


class AchievmentsWorthBarChart extends NetworthBarChart {

  const AchievmentsWorthBarChart({Key? key,required List<BarChartData> chartDataList, required String title }) : super(key: key, chartDataList: chartDataList,title: title);

  @override
  MaterialColor getColor(String category){
    return category == "Monto total" ? Colors.grey:Colors.green;
  }

}
