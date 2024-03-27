import 'package:flutter/material.dart';

import '../firebase.dart';

class OverView extends StatefulWidget {
  const OverView({super.key});

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Markets Overview',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          ElevatedButton(
              onPressed: () {
                FirebaseUtil().refreshCryptoList();
              },
              child: const Text('Fetch Crypto List')),
        ],
      ),
    );
  }
}
