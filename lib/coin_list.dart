import 'package:flutter/material.dart';
import 'coin_data.dart';

class CoinList extends StatelessWidget {
  final Map<String, CoinData> coinData;
  final List<String> filteredCoins;

  const CoinList({
    Key? key,
    required this.coinData,
    required this.filteredCoins,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: filteredCoins.length,
      itemBuilder: (context, index) {
        final coinSymbol = filteredCoins[index];
        final coinInfo = coinData[coinSymbol];
        return Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple,
                child: Text(coinSymbol[0]),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(coinSymbol),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹${coinInfo!.currentPrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(width: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            coinInfo.percentChange >= 0
                                ? '+${coinInfo.percentChange.toStringAsFixed(2)}%'
                                : '${coinInfo.percentChange.toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: coinInfo.percentChange >= 0 ? Colors.green : Colors.red,
                            ),
                          ),
                          Icon(
                            coinInfo.percentChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                            color: coinInfo.percentChange >= 0 ? Colors.green : Colors.red,
                            size: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(), // Divider below each coin
          ],
        );
      },
    );
  }
}
