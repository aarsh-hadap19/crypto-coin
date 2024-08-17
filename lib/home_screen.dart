import 'package:flutter/material.dart';
import 'package:ai_bharata/AmpiyWebSocket.dart';
import 'coin_data.dart';
import 'coin_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _ampiyWebSocket = AmpiyWebSocket();
  TextEditingController _searchController = TextEditingController();
  Map<String, CoinData> _coinData = {};
  List<String> _filteredCoins = [];
  int _selectedIndex = 1; // Set initial selected index to Coins

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _filterCoins(String query) {
    if (query.isEmpty) {
      _filteredCoins = _coinData.keys.toList();
    } else {
      // Filter coins based on symbol starting with the query
      List<String> filteredCoins = _coinData.keys
          .where((coinSymbol) => coinSymbol.toLowerCase().startsWith(query.toLowerCase()))
          .toList();

      // Sort filtered coins alphabetically
      filteredCoins.sort((a, b) => a.compareTo(b));

      _filteredCoins = filteredCoins;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _ampiyWebSocket.coinDataStream.listen(_processData);
  }

  void _processData(List<dynamic> coinData) {
    coinData.forEach((coin) {
      final symbol = coin['s'];
      final currentPrice = double.parse(coin['c']);
      final percentChange = double.parse(coin['p']);

      _coinData[symbol] = CoinData(
        symbol: symbol,
        currentPrice: currentPrice,
        percentChange: percentChange,
      );
    });
    _filterCoins(_searchController.text); // Update filtered coins based on the current search query
  }

  @override
  void dispose() {
    _ampiyWebSocket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Text('Home'),
      Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Name", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Price & Change", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                    // SizedBox(width:64 ,),
                    // Text("Change", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Divider(), // Divider below the header
          Expanded(
            child: CoinList(coinData: _coinData, filteredCoins: _filteredCoins),
          ),
        ],
      ),
      Text("icon"),
      Text('Wallet'),
      Text('You'),
    ];

    return Scaffold(
      appBar: _selectedIndex == 1
          ? AppBar(
        centerTitle: true,
        title: Text("Coins", style: TextStyle(color: Colors.white)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey),
              color: Colors.black12,
            ),
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterCoins,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      hintText: "Search",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Handle search icon press (optional)
                  },
                ),
              ],
            ),
          ),
        ),
        surfaceTintColor: Colors.black,
      )
          : AppBar(
        title: Text('App Name'), // Replace with your app name
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Coins',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8.0), // Adjust padding to control circle size
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber[800], // Circle background color
              ),
              child: Icon(
                Icons.compare_arrows,
                size: 50,
                color: Colors.white, // Icon color
              ),
            ),
            label: '', // Empty label or customize as needed
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'You',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Use fixed type for better layout
      ),
    );
  }
}
