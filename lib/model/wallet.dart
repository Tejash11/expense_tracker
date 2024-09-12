class Wallet {
  final String name;
  final String description;
  final double amount;

  Wallet({
    required this.name,
    required this.description,
    required this.amount,
  });

  // Convert a Wallet object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'amount': amount,
    };
  }
}