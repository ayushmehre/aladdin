import '../firebase.dart';
import 'package:flutter/material.dart';
import 'package:investing_tool/api.dart';
import 'package:investing_tool/crypolist/model.dart';

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

  @override
  void initState() {
    super.initState();
    fetchCoinDetails();
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
        subtitle: Text(widget.cryptoPair.currencyBase ?? ""),
        trailing: Last30DaysPerformance(
          symbol: widget.cryptoPair.symbol ?? "",
        ));
  }
}
