import 'package:flutter/cupertino.dart';
import 'package:pointmaster/models/facility.dart';
import 'package:pointmaster/models/response_api.dart';
import 'package:pointmaster/providers/user_provider.dart';
import 'package:pointmaster/services/facility_service.dart';

class FacilityProvider extends ChangeNotifier{

  final FacilityService _facilityService = FacilityService();
  final UserProvider userProvider;

  List<Facility> facilities = [];
  List<Facility> facilitiesForUsers = [];
  bool isLoading = false;
  String? errorMessage;

  FacilityProvider(this.userProvider);

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
        facilities = response.data;
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
        facilitiesForUsers = response.data;
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
        facilities = response.data;
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

  Future<void> addFacility(String name, String openTime, String closeTime, String location) async {
    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token = userProvider.activeUser?.token;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      ResponseApi response = await _facilityService.addFacility(name, openTime, closeTime, location, token);

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
        facilities = response.data;
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
        facilities = response.data;
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
        facilities = response.data;
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
        facilities = response.data;
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