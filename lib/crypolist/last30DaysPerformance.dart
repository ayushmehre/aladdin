import 'package:flutter/material.dart';
import 'package:investing_tool/api.dart';
import 'package:investing_tool/time_series_model.dart';
import 'package:investing_tool/util.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Last30DaysPerformance extends StatefulWidget {
  final List<PerformanceObject> array;

  const Last30DaysPerformance({super.key, required this.array});

  @override
  State<Last30DaysPerformance> createState() => _Last30DaysPerformanceState();
}

class _Last30DaysPerformanceState extends State<Last30DaysPerformance> {
  StockData? stockData;
  int totalDays = 30;
  int profitDays = 0;
  double avgProfitPercentage = 0;
  double avgLossPercentage = 0;
  double profitSum = 0;
  double lossSum = 0;

  @override
  void initState() {
    super.initState();
    // fetch();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      int totalDaysLocal = 0;
      int profitDaysLocal = 0;
      for (PerformanceObject obj in widget.array) {
        totalDaysLocal += 1;
        if (obj.percentageChange > 0) {
          profitDaysLocal += 1;
          profitSum += obj.percentageChange;
        }else{
          lossSum += obj.percentageChange;
        }
      }

      setState(() {
        totalDays = totalDaysLocal;
        profitDays = profitDaysLocal;
        avgProfitPercentage = (profitSum/profitDays).toPrecision(2);
        avgLossPercentage = (lossSum/(totalDaysLocal-profitDaysLocal)).toPrecision(2);
      });
    });
  }

  void fetch() async {
    // var data =
    //     await API().fetchTimeSeriesFor(symbol: widget.symbol, outputSize: 30);
    // setState(() {
    //   stockData = data;
    //   totalDays = data?.values.length ?? 30;
    //   profitDays = data?.values
    //           .where((element) => element.close > element.open)
    //           .length ??
    //       0;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1000,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            children: [
              Text('Profit Days%: ${((profitDays / totalDays) * 100).toPrecision(2)}'),
              Text('Avg Profit%: $avgProfitPercentage'),
              Text('Avg Loss%: $avgLossPercentage'),
            ],
          ),
          const SizedBox(width: 16),
          SizedBox(
              width: 500,
              height: 100,
              child: SfSparkWinLossChart(
                color: Colors.green,
                data: widget.array.map((e) => e.percentageChange).toList(),
              )),
        ],
      ),
    );
  }
}
