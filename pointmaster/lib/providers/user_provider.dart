import 'package:flutter/material.dart';
import 'package:pointmaster/models/response_api.dart';
import 'package:pointmaster/models/user.dart';
import 'package:pointmaster/models/wallet.dart';
import 'package:pointmaster/models/wallet_transaction.dart';
import 'package:pointmaster/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService userService;
  User? activeUser;
  String? errorMessage;
  bool loading = false;
  List<User> userList = [];
  Wallet? wallet;
  List<WalletTransaction> walletTransactions = [];

  UserProvider(this.userService);

  Wallet? _mapToWallet(dynamic data) {
    if (data is Wallet) return data;

    if (data is Map<String, dynamic>) {
      return Wallet.fromWalletJson(data);
    }

    if (data is Map) {
      return Wallet.fromWalletJson(Map<String, dynamic>.from(data));
    }

    if (data is List && data.isNotEmpty) {
      final first = data.first;
      if (first is Map<String, dynamic>) {
        return Wallet.fromWalletJson(first);
      }
      if (first is Map) {
        return Wallet.fromWalletJson(Map<String, dynamic>.from(first));
      }
    }

    return null;
  }

  List<WalletTransaction> _mapToWalletTransactions(dynamic data) {
    if (data is List<WalletTransaction>) return data;

    if (data is List) {
      return data
          .whereType<Map>()
          .map(
            (e) => WalletTransaction.fromWalletTransactionJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList();
    }

    if (data is Map<String, dynamic>) {
      return [WalletTransaction.fromWalletTransactionJson(data)];
    }

    if (data is Map) {
      return [
        WalletTransaction.fromWalletTransactionJson(
          Map<String, dynamic>.from(data),
        ),
      ];
    }

    return [];
  }

  //login
  Future<void> login(String username, String password) async {
    errorMessage = null;
    loading = true;
    notifyListeners();

    try {
      ResponseApi response = await userService.login(username, password);
      if (response.success && response.data != null) {
        activeUser = User.fromLoginJson(response.data);
      } else {
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  //logout
  Future<void> logout() async {
    activeUser = null;
    errorMessage = null;
    notifyListeners();
  }

  //register
  Future<void> register(
    String name,
    String secondName,
    String email,
    String username,
    String password,
  ) async {
    errorMessage = null;
    loading = true;
    notifyListeners();

    try {
      ResponseApi response = await userService.register(
        name,
        secondName,
        email,
        username,
        password,
      );
      if (!response.success) {
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  //Get all Users
  Future<void> getAllUsers() async {
    errorMessage = null;
    loading = true;
    notifyListeners(); //quitar?

    try {
      if (activeUser == null || activeUser!.token == null) {
        errorMessage = 'User not logged or invalid token';
        loading = false;
        notifyListeners();
        return;
      }

      ResponseApi response = await userService.getAllUsers(activeUser!.token!);

      if (response.success && response.data != null) {
        userList = (response.data as List)
            .map((u) => User.fromUserDTO(u))
            .toList();
      } else {
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  //Get user by id?

  //Update User
  Future<void> updateUser(int id, String name, String secondName) async {
    errorMessage = null;
    loading = true;
    notifyListeners();

    try {
      if (activeUser == null || activeUser!.token == null) {
        errorMessage = 'User not logged or invalid token';
        return;
      }
      ResponseApi response = await userService.updateUser(
        id,
        name,
        secondName,
        activeUser!.token!,
      );

      if (!response.success) {
        // await getAllUsers();
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Activate / deactivate
  Future<void> editActivation(int id, bool isActive) async {
    errorMessage = null;
    loading = true;
    notifyListeners();

    try {
      ResponseApi response;

      if (activeUser == null || activeUser!.token == null) {
        errorMessage = 'User not logged or invalid token';
        return;
      }

      if (isActive) {
        response = await userService.deactivateUser(id, activeUser!.token!);
      } else {
        response = await userService.activateUser(id, activeUser!.token!);
      }

      if (response.success) {
        await getAllUsers();
      } else {
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  //Delete
  Future<void> deleteUser(int id) async {
    errorMessage = null;
    loading = true;
    notifyListeners();

    try {
      if (activeUser == null || activeUser!.token == null) {
        errorMessage = 'User not logged or invalid token';
        return;
      }
      ResponseApi response = await userService.deleteUser(
        id,
        activeUser!.token!,
      );
      if (!response.success) {
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  //User's wallet
  Future<void> userWallet(int id) async {
        errorMessage = null;
    loading = true;
    notifyListeners();

    try {
      if (activeUser == null || activeUser!.token == null) {
        errorMessage = 'User not logged or invalid token';
        return;
      }
      ResponseApi response = await userService.getUserWallet(
        id,
        activeUser!.token!,
      );
      if (!response.success) {
        errorMessage = response.message;
      }else{
        wallet = _mapToWallet(response.data);
      }

    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  //Add money to wallet
  Future<bool> addMoneyToUserWallet(int id, double amount) async {
    errorMessage = null;
    loading = true;
    notifyListeners();

    try {
      if (activeUser == null || activeUser!.token == null) {
        errorMessage = 'User not logged or invalid token';
        return false;
      }
      final previousBalance = wallet?.amount ?? 0;
      ResponseApi response = await userService.addMoneyToUserWallet(
        id,
        activeUser!.token!,
        amount
      );
      if (!response.success) {
        errorMessage = response.message;
        return false;
      }else{
        wallet = _mapToWallet(response.data);
        wallet ??= await _fetchWalletAfterAdd(id);
        final newBalance = wallet?.amount ?? previousBalance;
        return newBalance > previousBalance;
      }

    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<Wallet?> _fetchWalletAfterAdd(int id) async {
    final response = await userService.getUserWallet(id, activeUser!.token!);
    if (!response.success) return null;
    return _mapToWallet(response.data);
  }

    //User's wallet transactions
  Future<void> userWalletTransactions(int id) async {
    errorMessage = null;
    loading = true;
    notifyListeners();

    try {
      if (activeUser == null || activeUser!.token == null) {
        errorMessage = 'User not logged or invalid token';
        return;
      }
      ResponseApi response = await userService.getUserWalletTransactions(
        id,
        activeUser!.token!,
      );
      if (!response.success) {
        errorMessage = response.message;
      }else{
        walletTransactions = _mapToWalletTransactions(response.data);
      }

    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

}
