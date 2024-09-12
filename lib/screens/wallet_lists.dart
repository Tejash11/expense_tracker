import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_expense_tracker/screens/add_wallet.dart';

class WalletLists extends StatefulWidget {
  const WalletLists({super.key});

  @override
  State<WalletLists> createState() => _WalletListsState();
}

class _WalletListsState extends State<WalletLists> {
  List<Map<String, dynamic>> wallets = []; // List to hold wallet data

  @override
  void initState() {
    super.initState();
    _loadWallets(); // Load wallets from SharedPreferences on init
  }

  // Load wallet data from SharedPreferences
  Future<void> _loadWallets() async {
    final prefs = await SharedPreferences.getInstance();
    final walletData = prefs.getString('wallets');
    if (walletData != null) {
      final List<dynamic> jsonList = json.decode(walletData);
      setState(() {
        wallets = jsonList.map((item) => Map<String, dynamic>.from(item)).toList();
      });
    }
  }

  // Save wallet data to SharedPreferences
  Future<void> _saveWallets() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = json.encode(wallets);
    await prefs.setString('wallets', jsonList);
  }

  void _addWallet(Map<String, dynamic> newWallet) {
    setState(() {
      wallets.add(newWallet); // Add new wallet to the list
      _saveWallets(); // Save the updated wallet list to SharedPreferences
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Wallet',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: wallets.isEmpty
          ? Center(
        child: Text(
          'No wallet found',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: wallets.length,
        itemBuilder: (context, index) {
          final wallet = wallets[index];
          return ListTile(
            title: Text(wallet['name']),
            subtitle: Text('Amount: ${wallet['amount']}'),
            // Customize the ListTile as needed
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddWallet(), // Page for adding wallet details
            ),
          );

          if (result != null) {
            _addWallet(result); // Update the wallet list with new wallet details
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
