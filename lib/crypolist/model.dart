class CryptoPair {
  late String? id;
  String? symbol;
  List<String>? availableExchanges;
  String? currencyBase;
  String? currencyQuote;

  CryptoPair({
    this.symbol,
    this.availableExchanges,
    this.currencyBase,
    this.currencyQuote,
  }) {
    id = symbol?.replaceAll('/', '_');
  }

  CryptoPair.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    if (json['available_exchanges'] != null) {
      availableExchanges = List<String>.from(json['available_exchanges']);
    }
    currencyBase = json['currency_base'];
    currencyQuote = json['currency_quote'];
    id = symbol?.replaceAll('/', '_');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['available_exchanges'] = availableExchanges;
    data['currency_base'] = currencyBase;
    data['currency_quote'] = currencyQuote;
    return data;
  }
}
