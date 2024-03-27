import '../firebase.dart';
import 'package:flutter/material.dart';
import 'package:investing_tool/api.dart';
import 'package:investing_tool/crypolist/model.dart';

import '../time_series_model.dart';
import '../util.dart';
import 'firebase_crypto_object.dart';
import 'last30DaysPerformance.dart';

class CryptoListItem extends StatefulWidget {
  final CryptoPair cryptoPair;

  const CryptoListItem({super.key, required this.cryptoPair});

  @override
  State<CryptoListItem> createState() => _CryptoListItemState();
}

class _CryptoListItemState extends State<CryptoListItem> {
  bool isRefreshing = false;
  FirebaseCryptoObject? cryptoObject;
  List<PerformanceObject>? dailyArray;
  List<PerformanceObject>? weeklyArray;
  List<PerformanceObject>? monthlyArray;

  @override
  void initState() {
    super.initState();
    fetchCoinDetails();
    fetchHistoricalData();
  }

  void fetchHistoricalData() async {
    var data = await FirebaseUtil()
        .fetchHistoricalData(widget.cryptoPair.id.toString(), freq: '1week', limit: 30);
    setState(() {
      dailyArray = data;
    });
  }

  void fetchCoinDetails() async {
    FirebaseCryptoObject doc =
        await FirebaseUtil().fetchCoinDetails(widget.cryptoPair.id ?? "");
    setState(() {
      cryptoObject = doc;
    });
  }

  void refreshLogo() async {
    setState(() {
      isRefreshing = true;
    });
    String logo = await API().fetchLogo(widget.cryptoPair.symbol ?? "");
    FirebaseUtil().updateLogo(widget.cryptoPair.id ?? "", logo);
    Future.delayed(const Duration(seconds: 2), () {
      fetchCoinDetails();
    });
    setState(() {
      isRefreshing = false;
    });
  }

  void refreshMarketData() async {
    setState(() {
      isRefreshing = true;
    });
    var summary = await API().fetchSummary(widget.cryptoPair.symbol ?? "");
    FirebaseUtil().updateSummary(widget.cryptoPair.id ?? "", summary);
    setState(() {
      isRefreshing = false;
    });
  }

  void refreshPerformanceData() async {
    print('Fetching daily performance data from API...');
    StockData? data = await API().fetchTimeSeriesFor(
        symbol: widget.cryptoPair.symbol ?? "",
        interval: '1day',
        outputSize: 365);
    if (data != null) {
      print('Updating daily performance data on Firebase...');
      List<PerformanceObject> array = Utils().getPercentageChanges(data);
      FirebaseUtil().updateDailyPerformance(widget.cryptoPair, array);
    }
  }

  void refreshWeeklyPerformanceData() async {
    print('Fetching weekly performance data from API...');
    StockData? data = await API().fetchTimeSeriesFor(
        symbol: widget.cryptoPair.symbol ?? "",
        interval: '1week',
        outputSize: 520);
    if (data != null) {
      print('Updating weekly performance data on Firebase...');
      List<PerformanceObject> array = Utils().getPercentageChanges(data);
      FirebaseUtil().updateWeeklyPerformance(widget.cryptoPair, array);
    }
  }

  void refreshMonthlyPerformanceData() async {
    print('Fetching monthly performance data from API...');
    StockData? data = await API().fetchTimeSeriesFor(
        symbol: widget.cryptoPair.symbol ?? "",
        interval: '1month',
        outputSize: 120);
    if (data != null) {
      print('Updating monthly performance data on Firebase...');
      List<PerformanceObject> array = Utils().getPercentageChanges(data);
      FirebaseUtil().updateMonthlyPerformance(widget.cryptoPair, array);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cryptoObject?.logo != '') {
      print(cryptoObject?.logo);
    }
    return ListTile(
        leading: cryptoObject?.logo != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(cryptoObject?.logo ?? ""),
              )
            : CircleAvatar(
                child: Text(widget.cryptoPair.symbol?[0] ?? ""),
              ),
        title: Row(
          children: [
            Row(
              children: [
                Text(widget.cryptoPair.symbol ?? ""),
                const SizedBox(width: 8),
                IconButton(
                    onPressed: () {
                      refreshLogo();
                      // refreshMarketData();
                      refreshPerformanceData();
                      refreshWeeklyPerformanceData();
                      refreshMonthlyPerformanceData();
                    },
                    icon: isRefreshing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator())
                        : const Icon(Icons.refresh)),
              ],
            ),
          ],
        ),
        subtitle: Text(widget.cryptoPair.currencyBase ?? ""),);
        // trailing: Text(dailyArray==null?"Loading...":"${dailyArray?.length.toString()}"),
        // trailing: dailyArray==null?const Text('Loading...'):Last30DaysPerformance(array: dailyArray ?? []));
  }
}
