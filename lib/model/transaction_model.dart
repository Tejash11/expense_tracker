class TransactionModel {
  String title;
  double amount;
  bool isIncome;
  DateTime transactionDate; // New field for transaction date and time

  TransactionModel(this.title, this.amount, this.isIncome, this.transactionDate);

  // Convert JSON to TransactionModel
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      json['title'],
      json['amount'],
      json['isIncome'],
      DateTime.parse(json['transactionDate']), // Parse DateTime from string
    );
  }

  // Convert TransactionModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'isIncome': isIncome,
      'transactionDate': transactionDate.toIso8601String(), // Convert DateTime to string
    };
  }
}