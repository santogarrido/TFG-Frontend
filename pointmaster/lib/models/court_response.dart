

import 'package:pointmaster/models/court.dart';

class CourtsResponse {
  final bool success;
  final List<Court> data;
  final String message;

  CourtsResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory CourtsResponse.fromJson(Map<String, dynamic> json) {
    List<Court> parsedData = [];

    if (json['data'] != null) {
      if (json['data'] is Map<String, dynamic>) {
        parsedData = [Court.fromCourtsJson(json['data'])];
      } else if (json['data'] is List) {
        parsedData = (json['data'] as List)
            .map((e) => Court.fromCourtsJson(e))
            .toList();
      }
    }

    return CourtsResponse(
      success: json['success'] ?? false,
      data: parsedData,
      message: json['message'] ?? '',
    );
  }
}