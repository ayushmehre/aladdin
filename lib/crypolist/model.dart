class CryptoPair {
  String? symbol;
  List<String>? availableExchanges;
  String? currencyBase;
  String? currencyQuote;

  CryptoPair({
    this.symbol,
    this.availableExchanges,
    this.currencyBase,
    this.currencyQuote,
  });

  CryptoPair.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    if (json['available_exchanges'] != null) {
      availableExchanges = List<String>.from(json['available_exchanges']);
    }
    currencyBase = json['currency_base'];
    currencyQuote = json['currency_quote'];
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
