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
        // print(selectedIndex);
        selectedCurrencyIndex = selectedIndex;
      },
      children: pickerItems,
    );
  }

  @override
  Widget build(BuildContext context) {
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
            child: Card(
              color: Colors.lightGreen,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = ? USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
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
}
