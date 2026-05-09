import 'package:flutter/material.dart';
import 'package:pointmaster/models/response_api.dart';
import 'package:pointmaster/models/user.dart';
import 'package:pointmaster/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService userService;
  User? activeUser;
  String? errorMessage;
  bool loading = false;
  List<User> userList = [];

  UserProvider(this.userService);

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
}
