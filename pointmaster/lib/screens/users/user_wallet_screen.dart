import 'package:flutter/material.dart';
import 'package:pointmaster/models/user.dart';
import 'package:pointmaster/models/wallet_transaction.dart';
import 'package:pointmaster/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UserWalletScreen extends StatefulWidget {
  final User user;

  const UserWalletScreen({
    super.key,
    required this.user,
  });

  @override
  State<UserWalletScreen> createState() => _UserWalletScreenState();
}

class _UserWalletScreenState extends State<UserWalletScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_loadWalletData);
  }

  Future<void> _loadWalletData() async {
    final userId = widget.user.id;
    if (userId == null) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.userWallet(userId);
    await userProvider.userWalletTransactions(userId);
  }

  Future<void> _showAddMoneyDialog() async {
    final userId = widget.user.id;
    if (userId == null) return;

    final amountController = TextEditingController();
    final messenger = ScaffoldMessenger.of(context);
    final provider = Provider.of<UserProvider>(context, listen: false);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Anadir dinero'),
          content: TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              hintText: 'Cantidad en EUR',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final normalized = amountController.text.trim().replaceAll(',', '.');
                final parsedAmount = double.tryParse(normalized);
                if (parsedAmount == null || parsedAmount <= 0) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Introduce una cantidad valida'),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext);
                final added = await provider.addMoneyToUserWallet(userId, parsedAmount);
                await provider.userWallet(userId);
                await provider.userWalletTransactions(userId);

                if (!mounted) return;
                if (provider.errorMessage != null) {
                  messenger.showSnackBar(
                    SnackBar(content: Text(provider.errorMessage!)),
                  );
                } else if (added) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Dinero anadido correctamente')),
                  );
                } else {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('No se actualizo el saldo. Revisa backend/API.'),
                    ),
                  );
                }
              },
              child: const Text('Anadir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final wallet = userProvider.wallet;
    final transactions = [...userProvider.walletTransactions]
      ..sort((a, b) => b.id.compareTo(a.id));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        shadowColor: Colors.black26,
        surfaceTintColor: Colors.white,
        title: const Text('Cartera'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadWalletData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFC4AD55),
                    Color(0xFF8B6F2C),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saldo actual',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(wallet?.amount ?? 0).toStringAsFixed(2)} EUR',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton.small(
                      heroTag: 'add-wallet-money',
                      onPressed: _showAddMoneyDialog,
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFC4AD55),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Transacciones',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            if (userProvider.loading && wallet == null)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (userProvider.errorMessage != null && wallet == null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  userProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (transactions.isEmpty && !userProvider.loading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No hay transacciones todavia'),
              ),
            ...transactions.map(_buildFloatingTransactionButton),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingTransactionButton(WalletTransaction tx) {
    final delta = tx.balanceAfter - tx.balanceBefore;
    final isPositive = delta > 0;
    final isNegative = delta < 0;
    final amountColor = isPositive
        ? Colors.green
        : isNegative
            ? Colors.red
            : Colors.grey;
    final sign = isPositive
        ? '+'
        : isNegative
            ? '-'
            : '';
    final amountLabel = '$sign${delta.abs().toStringAsFixed(2)} EUR';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_long),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx.description,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Saldo: ${tx.balanceAfter.toStringAsFixed(2)} EUR',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  amountLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: amountColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
