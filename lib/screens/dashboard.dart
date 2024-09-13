import 'package:flutter/material.dart';
import 'package:smart_expense_tracker/model/transaction_model.dart';
import 'package:smart_expense_tracker/screens/add_wallet.dart';
import 'package:smart_expense_tracker/screens/budget_calculator.dart';
import 'package:smart_expense_tracker/screens/home.dart';
import 'package:smart_expense_tracker/screens/profile.dart';
import 'package:smart_expense_tracker/screens/savings.dart';
import 'package:smart_expense_tracker/screens/summary.dart';
import 'package:smart_expense_tracker/screens/transaction.dart';
import 'package:smart_expense_tracker/screens/wallet_lists.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _pageIndex = 0;

  final List<TransactionModel> recentTransactions = [];

  final List<Widget> _pages = [
    const Home(),
    const Summary(),
    const Savings(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.cabin_sharp,  // Add icon for the action button
              color: Colors.white,
            ),
            backgroundColor:
            Colors.blue,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BudgetCalculatorPage()));
            }),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: (index) {
            setState(() {
              _pageIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,  // Fixes the size of items
          selectedItemColor: Colors.blue,  // Color for selected icon and text
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,// Light grey for unselected
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.summarize),
              label: 'Summary',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.savings),
              label: 'Savings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
        body: _pages[_pageIndex],
      ),
    );
  }
}
