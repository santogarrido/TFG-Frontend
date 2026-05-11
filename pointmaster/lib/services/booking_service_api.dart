import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pointmaster/models/response_api.dart';

class BookingServiceApi {
  static const String _baseUrl = 'http://10.0.2.2:8080';

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

    return ResponseApi.fromJson(json.decode(response.body));
  }

  // Get all bookings of a Court
  Future<ResponseApi> getBookingsByCourt(int courtId, String token) async {
    Uri url = Uri.parse('$_baseUrl/bookings/getByCourt/$courtId');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return ResponseApi.fromJson(json.decode(response.body));
  }

  // Get all bookings of a Facility
  Future<ResponseApi> getBookingsByFacility(
    int facilityId,
    String token,
  ) async {
    Uri url = Uri.parse('$_baseUrl/bookings/getAllBookings/$facilityId');

    final response = await http.post(
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

  // Get bookings of an User
  Future<ResponseApi> getBookingsByUser(int userId, String token) async {
    Uri url = Uri.parse('$_baseUrl/bookings/getBookingsByUser/$userId');

    final response = await http.post(
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

  // Get booking by id
  Future<ResponseApi> getBookingById(int bookingId, String token) async {
    Uri url = Uri.parse('$_baseUrl/bookings/getBooking/$bookingId');

    final response = await http.post(
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

  // Crear una nueva reserva
  Future<ResponseApi> addBooking(
    int userId,
    int courtId,
    DateTime bookingDateTime,
    DateTime courtDateTimeBooking,
    String token,
  ) async {
    Uri url = Uri.parse('$_baseUrl/bookings/addBooking');

    final response = await http.post(
      url,
      body: jsonEncode({
        'userId': userId,
        'courtId': courtId,
        'bookingDateTime': bookingDateTime.toIso8601String(),
        'courtDateTimeBooking': courtDateTimeBooking.toIso8601String(),
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

  // Delete booking
  Future<ResponseApi> deleteBooking(int bookingId, String token) async {
    Uri url = Uri.parse('$_baseUrl/bookings/deleteBooking/$bookingId');

    final response = await http.delete(
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
}
