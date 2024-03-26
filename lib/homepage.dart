import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:investing_tool/historicalData/historical_data_screen.dart';
import 'package:investing_tool/overview/overview.dart';
import 'package:investing_tool/time_series_model.dart';

import 'api.dart';
import 'crypolist/cryptolist.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StockData? stockData;
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildAppBar(),
        buildSubAppBar(),
        getTab(),
      ],
    ));
  }

  Widget getTab() {
    switch (currentTab) {
      case 0:
        return const OverView();
      case 1:
        return const CryptoList();
      case 2:
        return Container();
      default:
        return Container();
    }
  }

  Widget buildSubAppBar() {
    return Container(
      color: Colors.blue.shade800,
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          MaterialButton(
              onPressed: () {
                print('Pressed');
                setState(() {
                  currentTab = 0;
                });
              },
              child: Text(
                'OverView',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        currentTab == 0 ? FontWeight.bold : FontWeight.normal),
              )),
          MaterialButton(
              onPressed: () {
                print('Pressed');
                setState(() {
                  currentTab = 1;
                });
              },
              child: Text(
                'Crypto',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        currentTab == 1 ? FontWeight.bold : FontWeight.normal),
              )),
          MaterialButton(
              onPressed: () {
                print('Pressed');
                setState(() {
                  currentTab = 2;
                });
              },
              child: Text(
                'Stocks',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        currentTab == 2 ? FontWeight.bold : FontWeight.normal),
              )),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    return Container(
      color: Colors.blue.shade900,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Aladdin',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              SizedBox(width: 8.0),
              Text(
                'Find Trading Opportunities in Historical Market Data',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.webhook,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
