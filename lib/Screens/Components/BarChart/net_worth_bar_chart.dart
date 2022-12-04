



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'bar_chart_data.dart';

class NetworthBarChart extends StatelessWidget{
  final List<BarChartData> chartDataList;
  final String title;
  const NetworthBarChart({Key? key,required this.chartDataList, required this.title}) : super(key: key);

  MaterialColor getColor(String category){
    return category == "Ingresos" ? Colors.green:Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        title: ChartTitle(text: title,textStyle: const TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, decorationColor: Colors.green)),
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          ColumnSeries<BarChartData, dynamic>(
            //ancho de columna es inversamente proporcional al spacing
              spacing: 0.7,
              dataSource: chartDataList,
              xValueMapper: ( data, _) => data.category,
              yValueMapper: ( data, _) => data.total,
              pointColorMapper: ( data, _) => getColor(data.category),
              borderRadius: const BorderRadius.all(Radius.circular(15)
              )
          )
        ]
    );
  }
}
