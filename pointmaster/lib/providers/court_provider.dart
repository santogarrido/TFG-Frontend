import 'package:flutter/cupertino.dart';
import 'package:pointmaster/models/court.dart';
import 'package:pointmaster/models/response_api.dart';
import 'package:pointmaster/providers/user_provider.dart';
import 'package:pointmaster/services/court_service.dart';

class CourtProvider extends ChangeNotifier{

  final CourtService _courtService = CourtService();

  final UserProvider userProvider;

  List<Court> courts = [];
  List<Court> courtsForUsers = [];
  bool isLoading = false;
  String? errorMessage;

  CourtProvider(this.userProvider); 

  List<Court> _mapToCourtList(dynamic data) {
    if (data is List<Court>) return data;
    if (data is Map) {
      return [
        Court.fromCourtsJson(
          Map<String, dynamic>.from(data),
        ),
      ];
    }
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => Court.fromCourtsJson(
                Map<String, dynamic>.from(item),
              ))
          .toList();
    }
    return [];
  }

  Future<void> getCourts(int id) async {

    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token = userProvider.activeUser?.token;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      ResponseApi response = await _courtService.getCourts(id, token);

      if(response.success == true){
        courts = _mapToCourtList(response.data);
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

    Future<void> getCourtsForUsers(int id) async {

    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token = userProvider.activeUser?.token;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      ResponseApi response = await _courtService.getCourts(id, token);

      if(response.success == true){
        courtsForUsers = _mapToCourtList(response.data);
        courtsForUsers.removeWhere((c) => c.activated == false);
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

  Future<void> getCourtById(int id) async {
        try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token = userProvider.activeUser?.token;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      ResponseApi response = await _courtService.getCourtById(id, token);

      if(response.success == true){
        courts = _mapToCourtList(response.data);
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

  Future<void> addCourt(
    String name,
    String category,
    double courtPrice,
    int bookingDuration,
    int facilityId,
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

      ResponseApi response = await _courtService.addCourt(
        name,
        category,
        courtPrice,
        bookingDuration,
        facilityId,
        token,
      );

      if(response.success == true){
        courts = _mapToCourtList(response.data);
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

  Future<void> updateCourt(int id, String name, String category, int bookingDuration, int facilityId) async {
    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token = userProvider.activeUser?.token;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      ResponseApi response = await _courtService.updateCourt(id, name, category, bookingDuration, facilityId, token);
      if(response.success == true){
        courts = _mapToCourtList(response.data);
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

  Future<void> deleteCourt(int id) async {
        try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token = userProvider.activeUser?.token;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      ResponseApi response = await _courtService.deleteCourt(id, token);

      if(response.success == true){
        courts = _mapToCourtList(response.data);
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

  Future<void> activateCourt(int id) async {
        try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token = userProvider.activeUser?.token;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      ResponseApi response = await _courtService.activateCourt(id, token);

      if(response.success == true){
        courts = _mapToCourtList(response.data);
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

  Future<void> deactivateCourt(int id) async {
        try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token = userProvider.activeUser?.token;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      ResponseApi response = await _courtService.deactivateCourt(id, token);

      if(response.success == true){
        courts = _mapToCourtList(response.data);
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

}
