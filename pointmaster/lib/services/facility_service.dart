import "dart:convert";
import "dart:io";

import "package:http/http.dart" as http;
import "package:http_parser/http_parser.dart";
import "package:pointmaster/models/response_api.dart";

class FacilityService {

  static const String _baseUrl = 'http://149.202.58.58:8080/facilities';

  ResponseApi _safeResponse(http.Response response) {
    final body = response.body.trim();
    if (body.isEmpty) {
      return ResponseApi(
        success: false,
        data: null,
        message: 'Respuesta vacia del servidor (${response.statusCode})',
      );
    }

    try {
      return ResponseApi.fromJson(json.decode(body));
    } catch (_) {
      return ResponseApi(
        success: false,
        data: null,
        message: 'Respuesta no valida del servidor (${response.statusCode})',
      );
    }
  }

  String _imageExtension(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'png':
      case 'webp':
      case 'gif':
      case 'jpg':
      case 'jpeg':
        return extension;
      default:
        return 'jpg';
    }
  }

  MediaType _imageContentType(String path) {
    final extension = _imageExtension(path);
    switch (extension) {
      case 'png':
        return MediaType('image', 'png');
      case 'webp':
        return MediaType('image', 'webp');
      case 'gif':
        return MediaType('image', 'gif');
      case 'jpg':
      case 'jpeg':
      default:
        return MediaType('image', 'jpeg');
    }
  }

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
    Uri url = Uri.parse('$_baseUrl/$id');

    final response = await http.get(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    return _safeResponse(response); 

  }

  Future<ResponseApi> addFacility(
    String name,
    String openTime,
    String closeTime,
    String location,
    File imageFile,
    String token,
  ) async {
    final url = Uri.parse('$_baseUrl');
    final facilityBody = {
      'name': name,
      'openTime': openTime,
      'closeTime': closeTime,
      'location': location,
    };

    final request = http.MultipartRequest('POST', url)
      ..headers['Accept'] = 'application/json'
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(
        http.MultipartFile.fromString(
          'facility',
          json.encode(facilityBody),
          contentType: MediaType('application', 'json'),
        ),
      )
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          filename: 'facility-image.${_imageExtension(imageFile.path)}',
          contentType: _imageContentType(imageFile.path),
        ),
      );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return _safeResponse(response);
  }

  Future<ResponseApi> deleteFacility(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/$id');

    final response = await http.delete(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final facilityResponse = ResponseApi.fromJson(json.decode(response.body));

    return facilityResponse;

  }

  Future<ResponseApi> activateFacility(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/$id/activate');

    final response = await http.post(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final facilityResponse = ResponseApi.fromJson(json.decode(response.body));

    return facilityResponse;

  }

  Future<ResponseApi> deactivateFacility(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/$id/deactivate');

    final response = await http.post(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final facilityResponse = ResponseApi.fromJson(json.decode(response.body));

    return facilityResponse;

  }

  Future<ResponseApi> updateFacility(int id, String name, String openTime, String closeTime, String location, String token) async {
    Uri url = Uri.parse('$_baseUrl/$id');

    final response = await http.put(
      url,
      body: json.encode({'name' : name, 'openTime' : openTime, 'closeTime' : closeTime, 'location' : location}),
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    
    final facilityResponse = ResponseApi.fromJson(json.decode(response.body));

    return facilityResponse;
    
  }

  
  //Wallet 
  Future<ResponseApi> getFacilityWallet(int id, String token) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final candidates = [
      Uri.parse('$_baseUrl/wallet/$id'),
      Uri.parse('$_baseUrl/$id/wallet'),
      Uri.parse('$_baseUrl/facilities/$id/wallet'),
    ];

    for (final url in candidates) {
      final response = await http.get(url, headers: headers);
      final parsed = _safeResponse(response);
      if (parsed.success) return parsed;
    }

    return ResponseApi(
      success: false,
      data: null,
      message: 'No se pudo cargar la cartera de la facility',
    );
  }

  //Wallet 
  Future<ResponseApi> getFacilityWalletTransactions(int id, String token) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final candidates = [
      Uri.parse('$_baseUrl/wallet/$id/transactions'),
      Uri.parse('$_baseUrl/$id/transactions'),
      Uri.parse('$_baseUrl/facilities/$id/transactions'),
    ];

    for (final url in candidates) {
      final response = await http.get(url, headers: headers);
      final parsed = _safeResponse(response);
      if (parsed.success) return parsed;
    }

    return ResponseApi(
      success: false,
      data: null,
      message: 'No se pudieron cargar las transacciones de la facility',
    );
  }

}
