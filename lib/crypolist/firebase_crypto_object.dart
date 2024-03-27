class FirebaseCryptoObject {
  final String? id;
  final String? symbol;
  final String? name;
  final String? logo;

  FirebaseCryptoObject({
    this.id,
    this.symbol,
    this.name,
    this.logo,
  });

  factory FirebaseCryptoObject.fromMap(Map<String, dynamic> map) {
    return FirebaseCryptoObject(
      id: map['id'],
      symbol: map['symbol'],
      name: map['name'],
      logo: map['logo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'logo': logo,
    };
  }
}