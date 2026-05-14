import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:pointmaster/models/facility.dart';
import 'package:pointmaster/models/response_api.dart';
import 'package:pointmaster/models/wallet.dart';
import 'package:pointmaster/models/wallet_transaction.dart';
import 'package:pointmaster/providers/user_provider.dart';
import 'package:pointmaster/services/facility_service.dart';

class FacilityProvider extends ChangeNotifier{

  final FacilityService _facilityService = FacilityService();
  final UserProvider userProvider;

  List<Facility> facilities = [];
  List<Facility> facilitiesForUsers = [];
  Wallet? facilityWallet;
  List<WalletTransaction> facilityWalletTransactions = [];
  bool isLoading = false;
  String? errorMessage;

  FacilityProvider(this.userProvider);

  List<Facility> _mapToFacilityList(dynamic data) {
    if (data is List<Facility>) return data;
    if (data is Map) {
      return [
        Facility.fromFacilitiesJson(
          Map<String, dynamic>.from(data),
        ),
      ];
    }
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => Facility.fromFacilitiesJson(
                Map<String, dynamic>.from(item),
              ))
          .toList();
    }
    return [];
  }

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

  Future<void> getFacilities() async {
    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token = userProvider.activeUser?.token;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      ResponseApi response = await _facilityService.getFacilities(token);

      if(response.success == true){
        facilities = _mapToFacilityList(response.data);
      }else{
        errorMessage = response.message;
      }

    }catch(e){
      errorMessage = "Error inesperado $e";
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

    Future<void> getFacilitiesForUsers() async {
    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token = userProvider.activeUser?.token;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      ResponseApi response = await _facilityService.getFacilities(token);

      if(response.success == true){
        facilitiesForUsers = _mapToFacilityList(response.data);
        facilitiesForUsers.removeWhere((f) => f.activated != true);
      }else{
        errorMessage = response.message;
      }

    }catch(e){
      errorMessage = "Error inesperado $e";
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getFacilityById(int id) async {
    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token = userProvider.activeUser?.token;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      ResponseApi response = await _facilityService.getFacilityById(id, token);

      if(response.success == true){
        facilities = _mapToFacilityList(response.data);
      }else {
        errorMessage = response.message;
      }

    }catch(e){
      errorMessage = "Error inesperado $e";
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFacility(
    String name,
    String openTime,
    String closeTime,
    String location,
    File imageFile,
  ) async {
    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token = userProvider.activeUser?.token;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      ResponseApi response = await _facilityService.addFacility(
        name,
        openTime,
        closeTime,
        location,
        imageFile,
        token,
      );

      if(response.success == true){
        
        await getFacilities();
      }else {
        errorMessage = response.message;
      }

    }catch(e){
      errorMessage = "Error inesperado $e";
    }finally{
      isLoading = false;
      notifyListeners();      
    }

  }

  Future<void> deleteFacility(int id) async {
    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token = userProvider.activeUser?.token;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      ResponseApi response = await _facilityService.deleteFacility(id, token);
      if(response.success == true){
        facilities = _mapToFacilityList(response.data);
      }else {
        errorMessage = response.message;
      }

    }catch(e){
      errorMessage = "Error inesperado $e";
    }finally{
      isLoading = false;
      notifyListeners();      
    }
  }

  Future<void> deactivateFacility(int id) async {
    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token = userProvider.activeUser?.token;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      ResponseApi response = await _facilityService.deactivateFacility(id, token);

      if(response.success == true){
        facilities = _mapToFacilityList(response.data);
      }else {
        errorMessage = response.message;
      }

    }catch(e){
      errorMessage = "Error inesperado $e";
    }finally{
      isLoading = false;
      notifyListeners();      
    }
  }

    Future<void> activateFacility(int id) async {
    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token = userProvider.activeUser?.token;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      ResponseApi response = await _facilityService.activateFacility(id, token);

      if(response.success == true){
        facilities = _mapToFacilityList(response.data);
      }else {
        errorMessage = response.message;
      }

    }catch(e){
      errorMessage = "Error inesperado $e";
    }finally{
      isLoading = false;
      notifyListeners();      
    }
  }

  Future<void> updateFacility(int id, String name, String openTime, String closeTime, String location) async {
    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token = userProvider.activeUser?.token;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      ResponseApi response = await _facilityService.updateFacility(id,name, openTime, closeTime, location, token);

      if(response.success == true){
        facilities = _mapToFacilityList(response.data);
      }else {
        errorMessage = response.message;
      }

    }catch(e){
      errorMessage = "Error inesperado $e";
    }finally{
      isLoading = false;
      notifyListeners();      
    }
  }

  Future<void> getWalletFacility(int id) async {
    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token = userProvider.activeUser?.token;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      ResponseApi response = await _facilityService.getFacilityWallet(id, token);

      if(response.success == true){
        facilityWallet = _mapToWallet(response.data);
      }else {
        errorMessage = response.message;
      }

    }catch(e){
      errorMessage = "Error inesperado $e";
    }finally{
      isLoading = false;
      notifyListeners();      
    }
  }

  Future<void> getWalletFacilityTransactions(int id) async {
    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token = userProvider.activeUser?.token;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      ResponseApi response = await _facilityService.getFacilityWalletTransactions(id, token);

      if(response.success == true){
        facilityWalletTransactions = _mapToWalletTransactions(response.data);
      }else {
        errorMessage = response.message;
      }

    }catch(e){
      errorMessage = "Error inesperado $e";
    }finally{
      isLoading = false;
      notifyListeners();      
    }
  }

}
