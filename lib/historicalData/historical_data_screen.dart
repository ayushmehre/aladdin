import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api.dart';
import '../time_series_model.dart';

class HistoricalDataScreen extends StatefulWidget {
  const HistoricalDataScreen({super.key});

  @override
  State<HistoricalDataScreen> createState() => _HistoricalDataScreenState();
}

class _HistoricalDataScreenState extends State<HistoricalDataScreen> {
  StockData? stockData;
  String interval = '1day';
  String clickedDate = '';
  int gridCount = 7;

  @override
  void initState() {
    super.initState();
    // fetch();
  }

  void fetch() async {
    final api = API();
    final data = await api.fetchTimeSeriesFor(
        symbol: 'SOL/USD', outputSize: 30, interval: interval);
    data?.values = data.values.reversed.toList();
    setState(() {
      stockData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        SizedBox(
          width: 300,
          height: 793, // Adjust height as needed
          child: buildSideNav(),
        ),
        SizedBox(
          width: 1380,
          height: 793, // Adjust height as needed
          child: buildMainContent(),
        ),
      ],
    );
  }

  Widget buildMainContent() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridCount,
      ),
      itemCount: stockData?.values.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        final value = stockData!.values[index];
        final percentageChange = (value.close - value.open) / value.open * 100;
        var color = percentageChange > 0 ? Colors.green : Colors.red;
        return GestureDetector(
          onTap: () {
            print('Tapped on $value');
            setState(() {
              clickedDate = value.datetime;
            });
          },
          child: Container(
            color: color
                .withAlpha(100 + ((percentageChange.abs() * 2.55).toInt())),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${percentageChange.toStringAsFixed(2)}%',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 12.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  value.getUserFriendlyDate(),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildSideNav() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.blue.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text('Historical Data',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (stockData != null) Text('Symbol: ${stockData!.meta.symbol}'),
              if (stockData != null)
                Text('Currency: ${stockData!.meta.currency}'),
              if (stockData != null)
                Text('Exchange: ${stockData!.meta.exchange}'),
              if (stockData != null)
                Text('Exchange Timezone: ${stockData!.meta.exchangeTimezone}'),
              if (stockData != null)
                Text('Interval: ${stockData!.meta.interval}'),
              if (stockData != null)
                Text('MIC Code: ${stockData!.meta.micCode}'),
              if (stockData != null) Text('Type: ${stockData!.meta.type}'),
              if (stockData != null) Text('Status: ${stockData!.status}'),
              if (stockData != null)
                Text('Values: ${stockData!.values.length}'),
              buildIntervalDropdown(),
              buildFetchButton(),
              if (clickedDate.isNotEmpty) Text('Clicked Date: $clickedDate'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFetchButton() {
    return ElevatedButton(
      onPressed: () {
        fetch();
      },
      child: const Text('Fetch'),
    );
  }

  Widget buildIntervalDropdown() {
    return DropdownButton<String>(
      value: interval,
      items: <String>[
        '1min',
        '5min',
        '15min',
        '30min',
        '45min',
        '1h',
        '2h',
        '4h',
        '1day',
        '1week',
        '1month'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        print(newValue);
        setState(() {
          interval = newValue ?? '1day';
          if (interval == '1min' ||
              interval == '5min' ||
              interval == '15min' ||
              interval == '30min' ||
              interval == '45min') {
            gridCount = 12;
          } else if (interval == '1h' || interval == '2h' || interval == '4h') {
            gridCount = 24;
          } else if (interval == '1day') {
            gridCount = 7;
          } else if (interval == '1week') {
            gridCount = 4;
          } else if (interval == '1month') {
            gridCount = 12;
          }
        });
      },
    );
  }
}
