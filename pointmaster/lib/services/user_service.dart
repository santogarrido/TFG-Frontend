import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pointmaster/models/response_api.dart';

class UserService {

  static const String _baseUrl = 'http://149.202.58.58:8080';


  //register
  Future<ResponseApi> register(
    String name,
    String secondName,
    String email,
    String username,
    String password
  ) async {
    Uri url = Uri.parse('$_baseUrl/auth/register');

    final response = await http.post(
      url,
      body: jsonEncode({
        'name': name,
        'secondName': secondName,
        'email': email,
        'username': username,
        'password': password
      }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
    );

    final responseApi = ResponseApi.fromJson(json.decode(response.body));
    return responseApi;
  }

  //login
  Future<ResponseApi> login(String username, String password) async {
    Uri url = Uri.parse('$_baseUrl/auth/login');

    final response = await http.post(
      url,
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    final responseApi = ResponseApi.fromJson(json.decode(response.body));
    return responseApi;
  }

  //get all Users
  Future<ResponseApi> getAllUsers(String token) async {
    Uri url = Uri.parse('$_baseUrl/users');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responseApi = ResponseApi.fromJson(json.decode(response.body));
    return responseApi;
  }

  //get User by Id
  Future<ResponseApi> getUserById(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/users/$id');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responseApi = ResponseApi.fromJson(json.decode(response.body));
    return responseApi;
  }

  //Update User
  Future<ResponseApi> updateUser(int id, String name, String secondName, String token) async {
    Uri url = Uri.parse('$_baseUrl/users/$id');

    final response = await http.put(
      url,
      body: jsonEncode({
        'name': name,
        'secondName': secondName
      }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responseApi = ResponseApi.fromJson(json.decode(response.body));
    return responseApi;
  }

  //Activate
  Future<ResponseApi> activateUser(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/users/$id/activate');

    final response = await http.put(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responseApi = ResponseApi.fromJson(json.decode(response.body));
    return responseApi;
  }

  //Deactivate
  Future<ResponseApi> deactivateUser(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/users/$id/deactivate');

    final response = await http.put(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responseApi = ResponseApi.fromJson(json.decode(response.body));
    return responseApi;
  }

  //Delete
  Future<ResponseApi> deleteUser(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/users/$id');

    final response = await http.delete(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }
    );

    final responseApi = ResponseApi.fromJson(json.decode(response.body));
    return responseApi;
  }

  //Wallet 
  Future<ResponseApi> getUserWallet(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/users/wallet/$id'); 

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }
    );

    final responseApi = ResponseApi.fromJson(json.decode(response.body));
    return responseApi;
  }


  //Wallet 
  Future<ResponseApi> addMoneyToUserWallet(int id, String token, double amount) async {
    Uri url = Uri.parse('$_baseUrl/users/wallet/$id/addMoney?amount=$amount'); 

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }
    );

    final responseApi = ResponseApi.fromJson(json.decode(response.body));
    return responseApi;
  }

  //Wallet 
  Future<ResponseApi> getUserWalletTransactions(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/users/wallet/$id/transactions'); 

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }
    );

    final responseApi = ResponseApi.fromJson(json.decode(response.body));
    return responseApi;
  }

}
