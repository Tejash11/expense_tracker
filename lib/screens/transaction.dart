import 'package:flutter/material.dart';
import 'package:smart_expense_tracker/model/transaction_model.dart';

class Transaction extends StatefulWidget {
  final List<TransactionModel> transactions; // Receive the list of transactions
  Transaction({required this.transactions});


  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  DateTime? _selectedDate;
  int? _selectedMonth;
  int? _selectedYear;

  List<TransactionModel> filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    filteredTransactions = widget.transactions;
  }

  // Method to pick a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _filterTransactionsByDate();
      });
    }
  }

  // Filter transactions by exact date
  void _filterTransactionsByDate() {
    if (_selectedDate != null) {
      setState(() {
        filteredTransactions = widget.transactions
            .where((transaction) => transaction.transactionDate.day == _selectedDate!.day &&
            transaction.transactionDate.month == _selectedDate!.month &&
            transaction.transactionDate.year == _selectedDate!.year)
            .toList();
      });
    }
  }

  // Filter transactions by month
  void _filterTransactionsByMonth() {
    if (_selectedMonth != null && _selectedYear != null) {
      setState(() {
        filteredTransactions = widget.transactions
            .where((transaction) =>
        transaction.transactionDate.month == _selectedMonth &&
            transaction.transactionDate.year == _selectedYear)
            .toList();
      });
    }
  }

  // Filter transactions by year
  void _filterTransactionsByYear() {
    if (_selectedYear != null) {
      setState(() {
        filteredTransactions = widget.transactions
            .where((transaction) => transaction.transactionDate.year == _selectedYear)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.white, // Change back arrow color to white
        ),
      ),
      body: Column(
        children: [
          // Tabs for filtering
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Filter by Date'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 5,
                  ),
                ),
                DropdownButton<int>(
                  hint: Text('Month'),
                  value: _selectedMonth,
                  items: List.generate(12, (index) => DropdownMenuItem<int>(
                    child: Text('${index + 1}'),
                    value: index + 1,
                  )),
                  onChanged: (value) {
                    setState(() {
                      _selectedMonth = value;
                      _filterTransactionsByMonth();
                    });
                  },
                ),
                DropdownButton<int>(
                  hint: Text('Year'),
                  value: _selectedYear,
                  items: List.generate(25, (index) => DropdownMenuItem<int>(
                    child: Text('${2000 + index}'),
                    value: 2000 + index,
                  )),
                  onChanged: (value) {
                    setState(() {
                      _selectedYear = value;
                      _filterTransactionsByMonth(); // Call for filtering by month if both month and year are selected
                    });
                  },
                ),
                DropdownButton<int>(
                  hint: Text('Year Only'),
                  value: _selectedYear,
                  items: List.generate(25, (index) => DropdownMenuItem<int>(
                    child: Text('${2000 + index}'),
                    value: 2000 + index,
                  )),
                  onChanged: (value) {
                    setState(() {
                      _selectedYear = value;
                      _filterTransactionsByYear();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredTransactions.isEmpty
                ? Center(
                child: Text(
                  'No transactions found',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ))
                : Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              constraints: BoxConstraints(
                maxWidth: 550, // Set a maximum width if desired
              ),
                  child: ListView.builder(
                                itemCount: filteredTransactions.length,
                                itemBuilder: (context, index) {
                  final transaction = filteredTransactions[index];
                  // bool isIncome = transaction.amount > 0; // Assuming positive amounts are income
                  // Format the transaction date in 'dd/MM/yyyy' format
                  final formattedDate = _formatDate(transaction.transactionDate);

                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                    color: transaction.isIncome ? Colors.green[50] : Colors.red[50], // Card background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    child: Container(constraints: BoxConstraints(
                      maxHeight: 80, // Set a maximum height for the card
                    ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Reduced padding
                        leading: Icon(
                          transaction.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                          color: transaction.isIncome ? Colors.green : Colors.red, // Arrow icon color
                        ),
                        title: Text(
                          transaction.title,
                        ),
                        subtitle: Text(
                          '${transaction.isIncome ? 'Income' : 'Expense'}\n$formattedDate',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600], // Subtle subtitle color
                          ),
                        ),
                        trailing: Text(
                          '\u{20B9}${transaction.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: transaction.isIncome ? Colors.green : Colors.red, // Amount color
                          ),
                        ),
                      ),
                    ),
                  );
                                },
                              ),
                ),
          )
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
