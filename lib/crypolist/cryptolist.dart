import 'package:flutter/material.dart';
import 'package:investing_tool/api.dart';
import 'package:investing_tool/crypolist/model.dart';

import 'last30DaysPerformance.dart';

class CryptoList extends StatefulWidget {
  const CryptoList({super.key});

  @override
  State<CryptoList> createState() => _CryptoListState();
}

class _CryptoListState extends State<CryptoList> {
  List<String> cryptoList = [
    'BTC/USD',
    'ETH/USD',
    // 'LTC/USD',
    // 'XRP/USD',
    // 'DOGE/USD',
    // 'ADA/USD',
    // 'DOT/USD',
    // 'UNI/USD',
    // 'LINK/USD',
    // 'BNB/USD',
    // 'XLM/USD',
    // 'USDT/USD',
    // 'USDC/USD',
    // 'WBTC/USD',
    // 'AAVE/USD',
    // 'SUSHI/USD',
    // 'SNX/USD',
    // 'YFI/USD',
    // 'COMP/USD',
    // 'MKR/USD',
    // 'UMA/USD',
    // 'CRV/USD',
    // 'REN/USD',
    // 'BAL/USD',
    // 'FIL/USD',
    // 'ZRX/USD',
    // 'KNC/USD',
    // 'BNT/USD',
    // 'GRT/USD',
    // '1INCH/USD',
    // 'ENJ/USD',
    // 'MANA/USD',
    // 'SAND/USD',
    // 'CHZ/USD',
    // 'ANKR/USD',
    // 'RLC/USD',
    // 'LRC/USD',
    // 'SKL/USD',
    // 'BAND/USD',
    // 'OCEAN/USD',
    // 'MTL/USD',
    // 'CVC/USD',
    // 'STORJ/USD',
    // 'RLY/USD',
    // 'TRB/USD',
    // 'BOND/USD',
    // 'MLN/USD',
    // 'LPT/USD',
    // 'NU/USD',
    // 'GNO/USD',
  ];

  @override
  void initState() {
    super.initState();
    // fetchCryptoList();
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
      child: ListView.builder(
        itemCount: cryptoList.length,
        itemBuilder: (context, index) {
          return ListTile(
              title: Text(cryptoList[index]),
              // subtitle: Text(cryptoList[index].currencyBase ?? ""),
              trailing: Last30DaysPerformance(
                symbol: cryptoList[index],
              ));
        },
      ),
    );
  }
}
