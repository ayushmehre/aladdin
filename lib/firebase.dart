import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:investing_tool/crypolist/model.dart';
import 'package:investing_tool/util.dart';

import 'api.dart';
import 'crypolist/firebase_crypto_object.dart';

class FirebaseUtil {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> refreshCryptoList() async {
    final List<CryptoPair> cryptoList = await API().fetchCryptoList();
    print('Fetched crypto list: ${cryptoList.length}');
    print('Saving crypto list to Firestore...');
    for (int i = 0; i < cryptoList.length; i++) {
      var cryptoPair = cryptoList[i];
      try {
        await _firestore.collection('cryptoList').doc(cryptoPair.id).set({
          'symbol': cryptoPair.symbol,
          'availableExchanges': cryptoPair.availableExchanges,
          'currencyBase': cryptoPair.currencyBase,
          'currencyQuote': cryptoPair.currencyQuote,
        });
        print('Saved ${cryptoPair.id} crypto list to Firestore');
      } catch (e) {
        print('Failed to save crypto list to Firestore: $e');
      }
    }
  }

  Future<List<CryptoPair>> fetchCryptoList() async {
    List<CryptoPair> cryptoList = [];

    // Await the Firestore querySnapshot
    QuerySnapshot querySnapshot = await _firestore
        .collection('cryptoList')
        .where('availableExchanges', arrayContains: 'Binance')
        .get();

    // Iterate over documents
    for (var doc in querySnapshot.docs) {
      cryptoList.add(CryptoPair(
        // id: doc.id,
        symbol: doc['symbol'],
        // availableExchanges: doc['availableExchanges'],
        currencyBase: doc['currencyBase'],
        currencyQuote: doc['currencyQuote'],
      ));
      // print('Fetched crypto list: ${doc['symbol']}');
    }

    print('Fetched crypto list: ${cryptoList.length}');
    return cryptoList;
  }

  void updateLogo(String symbol, String logo) {
    print('Updating logo for $symbol...');
    _firestore.collection('cryptoList').doc(symbol).update({
      'logo': logo,
    });
  }

  Future<FirebaseCryptoObject> fetchCoinDetails(String s) async {
    var doc = await _firestore.collection('cryptoList').doc(s).get();
    return FirebaseCryptoObject.fromMap(doc.data()!);
  }

  void updateSummary(String symbol, summary) {
    print('Updating summary for $symbol...');
    _firestore.collection('cryptoList').doc(symbol).update({
      'summary': summary,
    });
  }

  void updateDailyPerformance(
      CryptoPair cryptoPair, List<PerformanceObject> array) {
    print('Updating daily performance for ${cryptoPair.symbol}');
    for (var element in array) {
      var string = cryptoPair.id.toString();
      _firestore
          .collection('cryptoList')
          .doc(string)
          .collection('1day')
          .doc(
              '${element.dateTime.year}-${element.dateTime.month}-${element.dateTime.day}')
          .set({
        'change': element.percentageChange,
        'date': element.dateTime.toIso8601String()
      });
    }
  }

  void updateWeeklyPerformance(
      CryptoPair cryptoPair, List<PerformanceObject> array) {
    print('Updating weekly performance for ${cryptoPair.symbol}');
    for (var element in array) {
      var string = cryptoPair.id.toString();
      _firestore
          .collection('cryptoList')
          .doc(string)
          .collection('1week')
          .doc(
              '${element.dateTime.year}-${element.dateTime.month}-${element.dateTime.day}')
          .set({
        'change': element.percentageChange,
        'date': element.dateTime.toIso8601String()
      });
    }
  }

  void updateMonthlyPerformance(
      CryptoPair cryptoPair, List<PerformanceObject> array) {
    print('Updating monthly performance for ${cryptoPair.symbol}');
    for (var element in array) {
      var string = cryptoPair.id.toString();
      _firestore
          .collection('cryptoList')
          .doc(string)
          .collection('1month')
          .doc(
              '${element.dateTime.year}-${element.dateTime.month}-${element.dateTime.day}')
          .set({
        'change': element.percentageChange,
        'date': element.dateTime.toIso8601String()
      });
    }
  }

  Future<List<PerformanceObject>> fetchHistoricalData(String id,
      {required String freq, required int limit}) async {
    List<PerformanceObject> array = [];
    var data = await _firestore
        .collection('cryptoList')
        .doc(id)
        .collection(freq)
        .orderBy('date', descending: true)
        .limit(limit)
        .get();
    for (DocumentSnapshot snapshot in data.docs) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      array.add(PerformanceObject(
          percentageChange: data['change'],
          dateTime: DateTime.parse(data['date'])));
      // print('data: $data');
    }
    return array;
  }
}
