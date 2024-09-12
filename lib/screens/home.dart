import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_expense_tracker/model/transaction_model.dart';
import 'package:smart_expense_tracker/screens/transaction.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double availableBalance = 0.0;
  double totalIncome = 0.0;
  double totalExpense = 0.0;

  List<TransactionModel> recentTransactions = [];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // Enables full-screen immersive mode
  }

  // Load saved data from SharedPreferences
  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? transactionsData = prefs.getString('transactions');

    if (transactionsData != null) {
      setState(() {
        List<dynamic> decodedData = json.decode(transactionsData);
        recentTransactions = decodedData.map((item) => TransactionModel.fromJson(item as Map<String, dynamic>)).toList();
        availableBalance = prefs.getDouble('availableBalance') ?? 0.0;
        totalIncome = prefs.getDouble('totalIncome') ?? 0.0;
        totalExpense = prefs.getDouble('totalExpense') ?? 0.0;
      });
    }
  }

  // Save transaction data to SharedPreferences
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String transactionsData = json.encode(recentTransactions.map((item) => item.toJson()).toList());

    await prefs.setString('transactions', transactionsData);
    await prefs.setDouble('availableBalance', availableBalance);
    await prefs.setDouble('totalIncome', totalIncome);
    await prefs.setDouble('totalExpense', totalExpense);
  }

  //function to update the transactions for Income and Expense
  void _updateTransaction(String title, double amount, bool isIncome, DateTime transactionDate, [int? index]) {
    setState(() {
      if(index == null){
      recentTransactions.insert(0, TransactionModel(title, amount, isIncome, transactionDate));
      } else {
        TransactionModel oldTransaction = recentTransactions[index];
        availableBalance += oldTransaction.isIncome ? -oldTransaction.amount : oldTransaction.amount;
        totalIncome += oldTransaction.isIncome ? -oldTransaction.amount : 0;
        totalExpense += oldTransaction.isIncome ? 0 : -oldTransaction.amount;
        recentTransactions[index] = TransactionModel(title, amount, isIncome, transactionDate);
      }

      if (isIncome) {
        totalIncome += amount;
        availableBalance += amount;
      } else {
        totalExpense += amount;
        availableBalance -= amount;
      }
      _saveData();
    });
  }

  // Delete a transaction
  void _deleteTransaction(int index) {
    setState(() {
      TransactionModel transaction = recentTransactions[index];
      availableBalance += transaction.isIncome ? -transaction.amount : transaction.amount;
      totalIncome += transaction.isIncome ? -transaction.amount : 0;
      totalExpense += transaction.isIncome ? 0 : -transaction.amount;
      recentTransactions.removeAt(index);
      _saveData(); // Save after deletion
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          // Available balance
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Available Balance',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[800],
              ),
            ),
          ),
          Text(
            '\u{20B9}${availableBalance.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),

          // Income and Expense cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IncomeExpenseCard(
                title: 'Income',
                amount: totalIncome,
                color: Colors.green,
                onPressed: () {
                  // Navigate to the Income page
                  Navigator.push(context,MaterialPageRoute(builder: (context) => AddTransactionPage(
                        isIncome: true,
                        onSave: _updateTransaction,
                      ),
                    ),
                  );
                },
              ),
              IncomeExpenseCard(
                title: 'Expense',
                amount: totalExpense,
                color: Colors.red,
                onPressed: () {
                  // Navigate to the Expense page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTransactionPage(
                        isIncome: false,
                        onSave: _updateTransaction,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Transaction(transactions: recentTransactions),
                      ),
                    );
                  },
                  child: Text('View All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 2,
                  ),
                ),
              ],
            ),
          ),

          // Recent transactions list
          Expanded(
            child: recentTransactions.isEmpty
              ? Center(
              child: Text(
                'No transactions yet',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[600],
                ),
              ),
            )
            : Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: ListView.builder(
                itemCount: recentTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = recentTransactions[index];
                  // Format the transaction date in 'dd/MM/yyyy' format
                  final formattedDate = _formatDate(transaction.transactionDate);
                  return Card(
                    color: Color.alphaBlend(Colors.white, Colors.blue),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: Icon(
                        transaction.isIncome
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: transaction.isIncome ? Colors.green : Colors.red,
                      ),
                      title: Text(transaction.title),
                      subtitle: Text('${transaction.isIncome ? 'Income' : 'Expense'}\n$formattedDate'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children:[
                          Text(
                            '\u{20B9}${transaction.amount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 15,
                              color:
                              transaction.isIncome ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  AddTransactionPage(
                                    isIncome: transaction.isIncome,
                                    onSave: (title, amount, isIncome, transactionDate) => _updateTransaction(title, amount, isIncome, transactionDate, index),
                                  ),
                              ));
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTransaction(index),
                          ),
                        ]
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  // Helper function to format date in 'dd/MM/yyyy' format
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}



// Widget for the income and expense cards
class IncomeExpenseCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final VoidCallback onPressed;

  IncomeExpenseCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.35,
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: title == 'Income'
                  ? [Colors.green.shade300, Colors.green.shade700] // Green gradient for Income
                  : [Colors.red.shade300, Colors.red.shade700], // Red gradient for Expense
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '\u{20B9}${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Page for adding income or expense
class AddTransactionPage extends StatefulWidget {
  final bool isIncome;
  final Function(String, double, bool, DateTime) onSave;

  AddTransactionPage({required this.isIncome, required this.onSave});

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController(); // Controller for date input
  DateTime? _selectedDate;

  // Method to pick a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue, // Primary color for header and selected date
            hintColor: Colors.blue, // Accent color for controls (buttons)
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary), // Button text color
            dialogBackgroundColor: Colors.white, // Background color of the dialog
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Color of the text on buttons
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Update the _dateController with the selected date
        _dateController.text = _formatDate(picked); // Format the picked date
      });
    }
  }

  // Helper function to format the date in 'dd/MM/yyyy' format
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isIncome ? 'Add Income' : 'Add Expense', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.white, // Change back arrow color to white
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),

            // TextField to show the selected date and allow choosing a date
            TextField(
              controller: _dateController,
              readOnly: true, // User cannot manually edit the date
              decoration: InputDecoration(
                labelText: 'Select Date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context), // Show DatePicker
                ),
              ),
              onTap: () => _selectDate(context), // Show DatePicker on tap
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text;
                final amount = double.tryParse(_amountController.text) ?? 0.0;
                final transactionDate = _selectedDate ?? DateTime.now(); // Use selected date or current date

                if (title.isNotEmpty && amount > 0) {
                  widget.onSave(title, amount, widget.isIncome, transactionDate);
                  Navigator.pop(context); // Navigate back to the home page
                }
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



