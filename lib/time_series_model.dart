class StockData {
  Meta meta;
  List<Value> values;
  String status;

  StockData({required this.meta, required this.values, required this.status});

  factory StockData.fromJson(Map<String, dynamic> json) {
    return StockData(
      meta: Meta.fromJson(json['meta'] ?? {}),
      values: List<Value>.from(
          (json['values'] ?? []).map((x) => Value.fromJson(x ?? {}))),
      status: json['status'] ?? '',
    );
  }
}

class Meta {
  String symbol;
  String interval;
  String currency;
  String exchangeTimezone;
  String exchange;
  String micCode;
  String type;

  Meta({
    required this.symbol,
    required this.interval,
    required this.currency,
    required this.exchangeTimezone,
    required this.exchange,
    required this.micCode,
    required this.type,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      symbol: json['symbol'] ?? '',
      interval: json['interval'] ?? '',
      currency: json['currency'] ?? '',
      exchangeTimezone: json['exchange_timezone'] ?? '',
      exchange: json['exchange'] ?? '',
      micCode: json['mic_code'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class Value {
  String datetime;
  double open;
  double high;
  double low;
  double close;
  int volume;

  Value({
    required this.datetime,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory Value.fromJson(Map<String, dynamic> json) {
    try {
      return Value(
        datetime: json['datetime'] ?? '',
        open: double.tryParse(json['open']?.toString() ?? '0.0') ?? 0.0,
        high: double.tryParse(json['high']?.toString() ?? '0.0') ?? 0.0,
        low: double.tryParse(json['low']?.toString() ?? '0.0') ?? 0.0,
        close: double.tryParse(json['close']?.toString() ?? '0.0') ?? 0.0,
        volume: json['volume'] ?? 0,
      );
    } catch (e) {
      print(e);
      return Value(
        datetime: '',
        open: 0.0,
        high: 0.0,
        low: 0.0,
        close: 0.0,
        volume: 0,
      );
    }
  }

  String getUserFriendlyDate() {
    //return date like '12 Jan 2022'
    try {
      final date = DateTime.parse(datetime);
      return '${date.day} ${getMonthNameByNumber(date.month)} \n ${date.year}';
    } catch (e) {
      print(e);
      return '';
    }
  }

  getMonthNameByNumber(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}
