import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  int selectedCurrencyIndex = 19;
  List<String> currenciesPerCard = [];
  List<String> ratesByType = [];
  int cryptoTypeIndex = 0;
  void setRatesAndCurrencies() {
    for (String type in cryptoList) {
      ratesByType.add('?');
      currenciesPerCard.add(selectedCurrency);
    }
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> currencyItems = currenciesList
        .map(
          (e) => DropdownMenuItem(
            child: Text(e),
            value: e,
          ),
        )
        .toList();
    return DropdownButton<String>(
      value: selectedCurrency,
      items: currencyItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value as String;
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Widget> pickerItems =
        currenciesList.map((currency) => Text(currency)).toList();
    return CupertinoPicker(
      scrollController:
          FixedExtentScrollController(initialItem: selectedCurrencyIndex),
      backgroundColor: Colors.lightGreen,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrencyIndex = selectedIndex;
        });
      },
      children: pickerItems,
    );
  }

  @override
  void initState() {
    super.initState();
    updateAllCards();
  }

  @override
  Widget build(BuildContext context) {
    setRatesAndCurrencies();
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildCryptoCardList(
                  cryptoTypesList: cryptoList, onTapFunction: updateTickerCard),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 18),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  elevation: 6,
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              onPressed: updateAllCards,
              child: Text(
                'Update All',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightGreen,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }

  List<Widget> buildCryptoCardList(
      {required cryptoTypesList, required onTapFunction}) {
    List<Widget> cryptoTypesList = cryptoList
        .asMap()
        .entries
        .map(
          (cryptoType) => Builder(builder: (context) {
            int rateKey = cryptoType.key;
            String type = cryptoType.value;
            return Card(
              color: Colors.lightGreen,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: EdgeInsets.only(bottom: 25),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 28.0),
                child: GestureDetector(
                  onTap: () => onTapFunction(
                      inheritedCryptoType: type, rateKey: rateKey),
                  child: Text(
                    '1 $type = ${ratesByType[rateKey]} ${currenciesPerCard[rateKey]}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }),
        )
        .toList();
    return cryptoTypesList;
  }

  void updateTickerCard(
      {required String inheritedCryptoType, required int rateKey}) async {
    var newCurrency = currenciesList[selectedCurrencyIndex];
    CoinData coinData =
        CoinData(currency: newCurrency, cryptoType: inheritedCryptoType);
    var data = await coinData.getCoinData();
    var rateString = data['rate'].toInt().toString();
    setState(() {
      selectedCurrency = newCurrency;
      currenciesPerCard[rateKey] = newCurrency;
      ratesByType[rateKey] = rateString;
    });
  }

  void updateAllCards() async {
    int idx = 0;
    for (var coin in cryptoList) {
      updateTickerCard(inheritedCryptoType: coin, rateKey: idx);
      idx++;
    }
  }
}
