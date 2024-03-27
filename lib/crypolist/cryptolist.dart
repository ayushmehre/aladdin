import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:investing_tool/api.dart';
import 'package:investing_tool/crypolist/model.dart';
import 'package:investing_tool/firebase.dart';

import '../time_series_model.dart';
import '../util.dart';
import 'crypto_list_item.dart';
import 'last30DaysPerformance.dart';

class CryptoList extends StatefulWidget {
  const CryptoList({super.key});

  @override
  State<CryptoList> createState() => _CryptoListState();
}

class _CryptoListState extends State<CryptoList> {
  List<CryptoPair> cryptoList = [];
  List<CryptoPair> cryptoListFiltered = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    FirebaseUtil().fetchCryptoList().then((value) {
      setState(() {
        cryptoList = value;
      });
      // feed();
    });
  }

  void feed() async {
    await feed1dayChange();
    await feed1WeekChange();
    await feed1MonthChange();
  }

  feed1dayChange() async {
    for (CryptoPair cryptoPair in cryptoList) {
      StockData? data = await API().fetchTimeSeriesFor(
          symbol: cryptoPair.symbol ?? "", interval: '1day', outputSize: 365);
      if (data != null) {
        List<PerformanceObject> array = Utils().getPercentageChanges(data);
        FirebaseUtil().updateDailyPerformance(cryptoPair, array);
      }
    }
  }

  feed1WeekChange() async {
    for (CryptoPair cryptoPair in cryptoList) {
      StockData? data = await API().fetchTimeSeriesFor(
          symbol: cryptoPair.symbol ?? "", interval: '1week', outputSize: 520);
      if (data != null) {
        List<PerformanceObject> array = Utils().getPercentageChanges(data);
        FirebaseUtil().updateWeeklyPerformance(cryptoPair, array);
      }
    }
  }

  feed1MonthChange() async {
    for (CryptoPair cryptoPair in cryptoList) {
      StockData? data = await API().fetchTimeSeriesFor(
          symbol: cryptoPair.symbol ?? "", interval: '1month', outputSize: 120);
      if (data != null) {
        List<PerformanceObject> array = Utils().getPercentageChanges(data);
        FirebaseUtil().updateMonthlyPerformance(cryptoPair, array);
      }
    }
  }

  void fetchCryptoList() async {
    // List<CryptoPair> data = await API().fetchCryptoList();
    // setState(() {
    //   cryptoList = data;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 768,
      child: Column(
        children: [
          Container(
            color: Colors.blueGrey.shade100,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  query.isEmpty
                      ? 'All Cryptos (${cryptoList.length} Coins)'
                      : 'Search results for "$query" (${cryptoListFiltered.length} Coins)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextField(
                        onChanged: (value) {
                          print('Search: $value');
                          setState(() {
                            query = value;
                            cryptoListFiltered = cryptoList
                                .where((element) =>
                                    element.symbol
                                        ?.toLowerCase()
                                        .contains(value.toLowerCase()) ??
                                    false)
                                .toList();
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
              height: 700,
              child: cryptoList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : buildListView()),
        ],
      ),
    );
  }

  Widget buildListView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var cryptoPair
              in query.isEmpty ? cryptoList : cryptoListFiltered)
            CryptoListItem(cryptoPair: cryptoPair),
        ],
      ),
    );
  }
//   return ListView.separated(
//     separatorBuilder: (ctx, i) => const Divider(),
//     itemCount: query.isEmpty ? cryptoList.length : cryptoListFiltered.length,
//     itemBuilder: (context, index) {
//       return CryptoListItem(
//           cryptoPair:
//               query.isEmpty ? cryptoList[index] : cryptoListFiltered[index]);
//     },
//   );
// }
}
