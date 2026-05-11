import "dart:convert";

import "package:http/http.dart" as http;
import "package:pointmaster/models/response_api.dart";

class FacilityService {

  static const String _baseUrl = 'http://10.0.2.2:8080';

  Future<ResponseApi> getFacilities(String token) async {

    Uri url = Uri.parse('$_baseUrl/getAll');

    final response = await http.get(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final facilityResponse = ResponseApi.fromJson(json.decode(response.body));

    return facilityResponse;
  }

  Future<ResponseApi> getFacilityById(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/getFacility/$id');

    final response = await http.get(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final facilityResponse = ResponseApi.fromJson(json.decode(response.body));

    return facilityResponse; 

  }

  Future<ResponseApi> addFacility(String name, String openTime, String closeTime, String location, String token) async {
    Uri url = Uri.parse('$_baseUrl/addFacility');

    final response = await http.post(
      url,
      body: json.encode({'name' : name, 'openTime' : openTime, 'closeTime' : closeTime, 'location' : location}),
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final facilityResponse = ResponseApi.fromJson(json.decode(response.body));

    return facilityResponse;

  }  

  Future<ResponseApi> deleteFacility(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/deleteFacility/$id');

    final response = await http.delete(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final facilityResponse = ResponseApi.fromJson(json.decode(response.body));

    return facilityResponse;

  }

  Future<ResponseApi> activateFacility(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/activateFacility/$id');

    final response = await http.post(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final facilityResponse = ResponseApi.fromJson(json.decode(response.body));

    return facilityResponse;

  }

  Future<ResponseApi> deactivateFacility(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/deactivateFacility/$id');

    final response = await http.post(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final facilityResponse = ResponseApi.fromJson(json.decode(response.body));

    return facilityResponse;

  }

  Future<ResponseApi> updateFacility(int id, String name, String openTime, String closeTime, String location, String token) async {
    Uri url = Uri.parse('$_baseUrl/updateFacility/$id');

    final response = await http.put(
      url,
      body: json.encode({'name' : name, 'openTime' : openTime, 'closeTime' : closeTime, 'location' : location}),
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    
    final facilityResponse = ResponseApi.fromJson(json.decode(response.body));

    return facilityResponse;
    
  }

}