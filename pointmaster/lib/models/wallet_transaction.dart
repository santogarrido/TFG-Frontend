class WalletTransaction {

  int id;
  int walletId;
  double amount;
  double balanceBefore;
  double balanceAfter;
  String description;

  WalletTransaction({
    required this.id,
    required this.walletId,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.description,
  });

  factory WalletTransaction.fromWalletTransactionJson(Map<String, dynamic> json) => WalletTransaction(
    id: json['id'],
    walletId: json['walletId'],
    amount: (json['amount'] as num).toDouble(),
    balanceBefore: (json['balanceBefore'] as num).toDouble(),
    balanceAfter: (json['balanceAfter'] as num).toDouble(),
    description: json['description'],
  );

}