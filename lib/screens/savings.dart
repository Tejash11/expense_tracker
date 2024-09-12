import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_expense_tracker/model/transaction_model.dart';

class Savings extends StatefulWidget {
  const Savings({super.key});

  @override
  State<Savings> createState() => _SavingsState();
}

class _SavingsState extends State<Savings> {
  double _monthlySavings = 0.0;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  // Generate month names for dropdown
  final List<String> _months = List.generate(12, (index) {
    final date = DateTime(2020, index + 1); // Use a dummy year (2020) to generate months
    return DateFormat('MMM').format(date); // Returns 'Jan', 'Feb', etc.
  });

  // Generate list of years for dropdown
  final List<int> _years = List.generate(10, (index) => DateTime.now().year - index);

  @override
  void initState() {
    super.initState();
    _calculateMonthlySavings();
  }

  Future<void> _calculateMonthlySavings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? transactionsData = prefs.getString('transactions');

    if (transactionsData != null) {
      List<dynamic> decodedData = json.decode(transactionsData);
      List<TransactionModel> transactions = decodedData
          .map((item) => TransactionModel.fromJson(item as Map<String, dynamic>))
          .toList();

      double monthlyIncome = transactions
          .where((tx) =>
      tx.transactionDate.year == _selectedYear &&
          tx.transactionDate.month == _selectedMonth &&
          tx.isIncome)
          .fold(0.0, (sum, tx) => sum + tx.amount);

      double monthlyExpense = transactions
          .where((tx) =>
      tx.transactionDate.year == _selectedYear &&
          tx.transactionDate.month == _selectedMonth &&
          !tx.isIncome)
          .fold(0.0, (sum, tx) => sum + tx.amount);

      setState(() {
        _monthlySavings = monthlyIncome - monthlyExpense;
      });
    }
  }

  void _onMonthChanged(String? selectedMonth) {
    if (selectedMonth != null) {
      final monthIndex = _months.indexOf(selectedMonth) + 1; // Map month name to month index
      setState(() {
        _selectedMonth = monthIndex;
        _calculateMonthlySavings();
      });
    }
  }

  void _onYearChanged(int? selectedYear) {
    if (selectedYear != null) {
      setState(() {
        _selectedYear = selectedYear;
        _calculateMonthlySavings();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Savings', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Month and Year Dropdowns
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.blueAccent),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _months[_selectedMonth - 1],
                      items: _months.map((month) {
                        return DropdownMenuItem<String>(
                          value: month,
                          child: Text(month),
                        );
                      }).toList(),
                      onChanged: _onMonthChanged,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.blueAccent),
                    ),
                    child: DropdownButtonFormField<int>(
                      value: _selectedYear,
                      items: _years.map((year) {
                        return DropdownMenuItem<int>(
                          value: year,
                          child: Text('$year'),
                        );
                      }).toList(),
                      onChanged: _onYearChanged,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Savings Display
            Card(
              color: Colors.blue.shade50,
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total Savings for Selected Month',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '\u{20B9}${_monthlySavings.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
