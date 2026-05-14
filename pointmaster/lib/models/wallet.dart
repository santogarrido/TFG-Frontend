class Wallet {

  int id;
  int ownerId; // userId o facilityId
  bool isUser; // true = user, false = facility
  double amount;

  Wallet({
    required this.id,
    required this.ownerId,
    required this.isUser,
    required this.amount,
  });

  factory Wallet.fromWalletJson(Map<String, dynamic> json) => Wallet(
    id: json['id'],
    ownerId: json['userId'] ?? json['facilityId'],
    isUser: json['userId'] != null,
    amount: (json['amount'] as num).toDouble(),
  );

}