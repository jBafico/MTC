



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'bar_chart_data.dart';


class NetworthBarChart extends StatefulWidget {
  final List<BarChartData> chartDataList;
  final String title;

  const NetworthBarChart(
      {Key? key, required this.chartDataList, required this.title})
      : super(key: key);

  MaterialColor getColor(String category) {
    return category == "Ingresos" ? Colors.green : Colors.red;
  }


  @override
  State<StatefulWidget> createState() => _BarChartState();
}








class _BarChartState extends State<NetworthBarChart> {


  bool dataVisible = false;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        title: ChartTitle(text: widget.title,
            textStyle: const TextStyle(decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                decorationColor: Colors.green)),
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          ColumnSeries<BarChartData, dynamic>(
              //ancho de columna es inversamente proporcional al spacing
              spacing: 0.7,
              dataSource: widget.chartDataList,
              xValueMapper: (data, _) => data.category,
              yValueMapper: (data, _) => data.total,
              dataLabelSettings: DataLabelSettings(isVisible: dataVisible),
              pointColorMapper: (data, _) => widget.getColor(data.category),
              onPointTap: (e) => setState( () => dataVisible = !dataVisible),
              borderRadius: const BorderRadius.all(Radius.circular(15)
              )
          )
        ]

    );
  }
}
