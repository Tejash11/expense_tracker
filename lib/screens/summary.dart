import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_expense_tracker/model/transaction_model.dart';

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  Map<String, Map<String, double>> monthlyData = {};
  List<TransactionModel> transactions = [];

  final double minPercentageThreshold = 1.0; // Set a minimum percentage threshold

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  // Load saved data from SharedPreferences
  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? transactionsData = prefs.getString('transactions');

    if (transactionsData != null) {
      setState(() {
        List<dynamic> decodedData = json.decode(transactionsData);
        transactions = decodedData
            .map((item) => TransactionModel.fromJson(item as Map<String, dynamic>))
            .toList();
        _calculateMonthlySummary();
      });
    }
  }

  // Group transactions by month and calculate totals
  void _calculateMonthlySummary() {
    monthlyData.clear();

    for (var transaction in transactions) {
      // Format the date to get the month and year (e.g., "Jan 2024")
      String month = DateFormat('MMM yyyy').format(transaction.transactionDate);

      if (!monthlyData.containsKey(month)) {
        monthlyData[month] = {'income': 0.0, 'expense': 0.0, 'savings': 0.0};
      }

      if (transaction.isIncome) {
        monthlyData[month]!['income'] =
            monthlyData[month]!['income']! + transaction.amount;
      } else {
        monthlyData[month]!['expense'] =
            monthlyData[month]!['expense']! + transaction.amount;
      }

      // Calculate savings for each month (income - expense)
      monthlyData[month]!['savings'] =
          monthlyData[month]!['income']! - monthlyData[month]!['expense']!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Summary', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.white, // Change back arrow color to white
        ),
      ),
      body: ListView.builder(
        itemCount: monthlyData.length,
        itemBuilder: (context, index) {
          String month = monthlyData.keys.elementAt(index);
          double income = monthlyData[month]!['income']!;
          double expense = monthlyData[month]!['expense']!;
          double savings = monthlyData[month]!['savings']!;

          // Calculate total including both income and expense
          double total = income + expense;

          // Ensure sections are visible even if very small (set minimum percentage)
          double expensePercentage = (expense * 100 / total).clamp(minPercentageThreshold, 100.0);
          double incomePercentage = (income * 100 / total).clamp(minPercentageThreshold, 100.0);
          double savingsPercentage = (savings * 100 / total).clamp(minPercentageThreshold, 100.0);

          // Pie chart sections
          List<PieChartSectionData> sections = [];

          // Ensure the expense, savings, and income are always visible
          sections.add(
            PieChartSectionData(
              color: Colors.green,
              value: income,
              title: 'Income ${(incomePercentage).toStringAsFixed(1)}%',
              radius: 30,
              titleStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );

          sections.add(
            PieChartSectionData(
              color: Colors.red,
              value: expense,
              title: 'Expense ${(expensePercentage).toStringAsFixed(1)}%',
              radius: 30,
              titleStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );

          // Only add savings if it’s positive
          if (savings > 0) {
            sections.add(
              PieChartSectionData(
                color: Colors.blue,
                value: savings,
                title: 'Savings ${(savingsPercentage).toStringAsFixed(1)}%',
                radius: 30,
                titleStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          }

          return Card(
            color: Colors.white,
            shadowColor: Colors.grey,
            margin: const EdgeInsets.all(16.0),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Pie chart on the left side
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1.5,
                      child: PieChart(
                        PieChartData(
                          sections: sections,
                          sectionsSpace: 2,
                          centerSpaceRadius: 30,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Income, Expense, and Savings on the right side
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(month,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text('Total Income: \u{20B9}${income.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 14, color: Colors.green)),
                        const SizedBox(height: 8),
                        Text('Total Expense: \u{20B9}${expense.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 14, color: Colors.red)),
                        const SizedBox(height: 8),
                        Text('Total Savings: \u{20B9}${savings.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 14, color: Colors.blue)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
