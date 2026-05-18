import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pointmaster/models/response_api.dart';

class CourtService {

  static const String _baseUrl = 'http://149.202.58.58:8080';

  Future<ResponseApi> getCourts(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/courts/facility/$id');

    final response = await http.get(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final courtResponse = ResponseApi.fromJson(json.decode(response.body));

    return courtResponse;

  }

  Future<ResponseApi> getCourtById(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/courts/$id');

    final response = await http.get(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}      
    );

    final courtResponse = ResponseApi.fromJson(json.decode(response.body));

    return courtResponse;

  }

  Future<ResponseApi> addCourt(
    String name,
    String category,
    double courtPrice,
    int bookingDuration,
    int facilityId,
    String token,
  ) async {
    Uri url = Uri.parse('$_baseUrl/courts');

    final response = await http.post(
      url,
      body: json.encode({
        'name' : name,
        'category' : category,
        'courtPrice': courtPrice,
        'bookingDuration' : bookingDuration,
        'facilityId' : facilityId,
      }),
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final courtResponse = ResponseApi.fromJson(json.decode(response.body));

    return courtResponse;
  }

  Future<ResponseApi> updateCourt(
    int id,
    String name,
    String category,
    double courtPrice,
    int bookingDuration,
    int facilityId,
    String token,
  ) async {
    Uri url = Uri.parse('$_baseUrl/courts/$id');

    final response = await http.put(
      url,
      body: json.encode({
        'name': name,
        'category': category,
        'courtPrice': courtPrice,
        'bookingDuration': bookingDuration,
        'facilityId': facilityId,
      }),
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final courtResponse = ResponseApi.fromJson(json.decode(response.body));

    return courtResponse;
  }

  Future<ResponseApi> deleteCourt(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/courts/$id');

    final response = await http.delete(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final courtResponse = ResponseApi.fromJson(json.decode(response.body));

    return courtResponse;
  }

  Future<ResponseApi> activateCourt(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/courts/$id/activate');

    final response = await http.put(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final courtResponse = ResponseApi.fromJson(json.decode(response.body));

    return courtResponse;
  }

  Future<ResponseApi> deactivateCourt(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/courts/$id/deactivate');

    final response = await http.put(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final courtResponse = ResponseApi.fromJson(json.decode(response.body));

    return courtResponse;
  }

}
