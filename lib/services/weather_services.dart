import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/weatherModel.dart';

class WeatherServices {
  static const String _baseUrl = "https://api.open-meteo.com/v1/forecast";

  Future<WeatherModel?> fetchWeatherApi({
    required double lat,
    required double long,
  }) async {
    try {
      /// API ne Uri datatype kari Uri.parse karvu j pade tena vagar API response na aapi sake
      final Uri url = Uri.parse(
        "$_baseUrl?latitude=$lat&longitude=$long&hourly=temperature_2m,wind_speed_10m,relative_humidity_2m,rain,snowfall,weather_code,soil_temperature_0cm",
      );

      final response = await http.get(url);
      print("API CALL HERE ## : ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return WeatherModel.fromJson(data);
      } else {
        print("Server Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        /// debug mode ma print show thase ane release mode ma print show nahi thase
        print("Error Show:: $e");
      }
      return null;
    }
  }
}
