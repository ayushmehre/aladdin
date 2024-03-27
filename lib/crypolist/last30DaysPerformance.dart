import 'package:flutter/material.dart';
import 'package:investing_tool/api.dart';
import 'package:investing_tool/time_series_model.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Last30DaysPerformance extends StatefulWidget {
  final String symbol;

  const Last30DaysPerformance({super.key, required this.symbol});

  @override
  State<Last30DaysPerformance> createState() => _Last30DaysPerformanceState();
}

class _Last30DaysPerformanceState extends State<Last30DaysPerformance> {
  StockData? stockData;
  int totalDays = 30;
  int profitDays = 0;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() async {
    var data =
        await API().fetchTimeSeriesFor(symbol: widget.symbol, outputSize: 30);
    setState(() {
      stockData = data;
      totalDays = data?.values.length ?? 30;
      profitDays = data?.values
              .where((element) => element.close > element.open)
              .length ??
          0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1000,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Profit Days: $profitDays/$totalDays'),
          const SizedBox(width: 16),
          SizedBox(
              width: 500,
              height: 100,
              child: SfSparkWinLossChart(
                color: Colors.green,
                data: stockData?.values.map((e) {
                      return ((e.close - e.open) / e.open) * 100;
                    }).toList() ??
                    [],
              )),
        ],
      ),
    );
  }
}
