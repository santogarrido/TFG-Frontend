import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pointmaster/models/response_api.dart';

class BookingServiceApi {
  static const String _baseUrl = 'http://149.202.58.58:8080';

  ResponseApi _safeResponse(http.Response response) {
    final body = response.body.trim();

    if (body.isEmpty) {
      final isForbidden = response.statusCode == 403;
      return ResponseApi(
        success: response.statusCode >= 200 && response.statusCode < 300,
        data: null,
        message: response.statusCode >= 200 && response.statusCode < 300
            ? 'OK'
            : isForbidden
                ? 'Saldo insuficiente para reservar esta pista'
                : 'HTTP ${response.statusCode}',
      );
    }

    try {
      final decoded = json.decode(body);
      if (decoded is Map<String, dynamic>) {
        return ResponseApi.fromJson(decoded);
      }

      return ResponseApi(
        success: response.statusCode >= 200 && response.statusCode < 300,
        data: decoded,
        message: response.statusCode >= 200 && response.statusCode < 300
            ? 'OK'
            : 'HTTP ${response.statusCode}',
      );
    } catch (_) {
      final isForbidden = response.statusCode == 403;
      return ResponseApi(
        success: response.statusCode >= 200 && response.statusCode < 300,
        data: null,
        message: isForbidden
            ? 'Saldo insuficiente para reservar esta pista'
            : body,
      );
    }
  }

  //Get all
  Future<ResponseApi> getAllBookings(String token) async {
    Uri url = Uri.parse('$_baseUrl/bookings');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return _safeResponse(response);
  }

  // Get all bookings of a Court
  Future<ResponseApi> getBookingsByCourt(int courtId, String token) async {
    Uri url = Uri.parse('$_baseUrl/bookings/$courtId/getByCourt');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return _safeResponse(response);
  }

  // Get all bookings of a Facility
  Future<ResponseApi> getBookingsByFacility(
    int facilityId,
    String token,
  ) async {
    Uri url = Uri.parse('$_baseUrl/bookings/$facilityId/getAllByFacilities');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return _safeResponse(response);
  }

  // Get bookings of an User
  Future<ResponseApi> getBookingsByUser(int userId, String token) async {
    Uri url = Uri.parse('$_baseUrl/bookings/$userId/getBookingsByUser');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return _safeResponse(response);
  }

  // Get booking by id
  Future<ResponseApi> getBookingById(int bookingId, String token) async {
    Uri url = Uri.parse('$_baseUrl/bookings/$bookingId');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return _safeResponse(response);
  }

  // Crear una nueva reserva
  Future<ResponseApi> addBooking(
    int userId,
    int courtId,
    DateTime bookingDateTime,
    DateTime courtDateTimeBooking,
    double courtPrice,
    String token,
  ) async {
    Uri url = Uri.parse('$_baseUrl/bookings');

    final response = await http.post(
      url,
      body: jsonEncode({
        'userId': userId,
        'courtId': courtId,
        'bookingDateTime': bookingDateTime.toIso8601String(),
        'courtDateTimeBooking': courtDateTimeBooking.toIso8601String(),
        'courtPrice': courtPrice,
      }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return _safeResponse(response);
  }

  // Delete booking
  Future<ResponseApi> deleteBooking(int bookingId, String token) async {
    Uri url = Uri.parse('$_baseUrl/bookings/$bookingId');

    final response = await http.delete(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return _safeResponse(response);
  }
}
