



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'bar_chart_data.dart';

class NetworthBarChart extends StatelessWidget{
  final List<BarChartData> chartDataList;
  const NetworthBarChart({Key? key,required this.chartDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          ColumnSeries<BarChartData, dynamic>(
            //ancho de columna es inversamente proporcional al spacing
              spacing: 0.7,
              dataSource: chartDataList,
              xValueMapper: ( data, _) => data.category,
              yValueMapper: ( data, _) => data.total,
              pointColorMapper: ( data, _) => data.category == "Ingresos" ? Colors.green:Colors.red,
              borderRadius: const BorderRadius.all(Radius.circular(15)
              )
          )
        ]
    );
  }
}
