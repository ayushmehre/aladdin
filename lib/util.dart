import 'package:investing_tool/time_series_model.dart';

class Utils {
  List<PerformanceObject> getPercentageChanges(StockData data) {
    List<PerformanceObject> array = [];
    for (Value v in data.values) {
      double percentageChange = ((v.close - v.open) / v.open) * 100;
      array.add(PerformanceObject(
          percentageChange: percentageChange.toPrecision(2),
          dateTime: DateTime.parse(v.datetime)));
    }
    // print('returning array: $array');
    return array;
  }
}

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

class PerformanceObject {
  double percentageChange;
  DateTime dateTime;

  PerformanceObject({required this.percentageChange, required this.dateTime});
}
