// To parse this JSON data, do
//
//     final weatherModel = weatherModelFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

WeatherModel weatherModelFromJson(String str) =>
    WeatherModel.fromJson(json.decode(str));

String weatherModelToJson(WeatherModel data) => json.encode(data.toJson());

class WeatherModel {
  double latitude;
  double longitude;
  double generationtimeMs;
  int utcOffsetSeconds;
  String timezone;
  String timezoneAbbreviation;
  num elevation;
  HourlyUnits hourlyUnits;
  Hourly hourly;
  CurrentWeather? currentWeather;

  WeatherModel({
    required this.latitude,
    required this.longitude,
    required this.generationtimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    required this.hourlyUnits,
    required this.hourly,
    required this.currentWeather,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    generationtimeMs: json["generationtime_ms"]?.toDouble(),
    utcOffsetSeconds: json["utc_offset_seconds"],
    timezone: json["timezone"],
    timezoneAbbreviation: json["timezone_abbreviation"],
    elevation: json["elevation"],
    hourlyUnits: HourlyUnits.fromJson(json["hourly_units"]),
    hourly: Hourly.fromJson(json["hourly"]),
    currentWeather: json["current_weather"] == null
        ? null
        : CurrentWeather.fromJson(json["current_weather"]),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "generationtime_ms": generationtimeMs,
    "utc_offset_seconds": utcOffsetSeconds,
    "timezone": timezone,
    "timezone_abbreviation": timezoneAbbreviation,
    "elevation": elevation,
    "hourly_units": hourlyUnits.toJson(),
    "hourly": hourly.toJson(),
  };

  // WeatherModel ક્લાસની અંદર...
  List<HourlyItem> get getItems {
    return List.generate(hourly.time.length, (index) {
      return HourlyItem(
        time: hourly.time[index],
        temperature2M: hourly.temperature2M[index],
        windSpeed10M: hourly.windSpeed10M[index],
        relativeHumidity2M: hourly.relativeHumidity2M[index],
        rain: hourly.rain[index],
        snowfall: hourly.snowfall[index],
        weatherCode: hourly.weatherCode[index],
        soilTemperature0Cm: hourly.soilTemperature0Cm[index],
      );
    });
  }
}

class Hourly {
  List<String> time;
  List<double> temperature2M;
  List<double> windSpeed10M;
  List<int> relativeHumidity2M;
  List<double> rain;
  List<num> snowfall;
  List<int> weatherCode;
  List<double> soilTemperature0Cm;

  Hourly({
    required this.time,
    required this.temperature2M,
    required this.windSpeed10M,
    required this.relativeHumidity2M,
    required this.rain,
    required this.snowfall,
    required this.weatherCode,
    required this.soilTemperature0Cm,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
    time: List<String>.from(json["time"].map((x) => x)),
    temperature2M: List<double>.from(
      json["temperature_2m"].map((x) => x?.toDouble()),
    ),
    windSpeed10M: List<double>.from(
      json["wind_speed_10m"].map((x) => x?.toDouble()),
    ),
    relativeHumidity2M: List<int>.from(
      json["relative_humidity_2m"].map((x) => x),
    ),
    rain: List<double>.from(json["rain"].map((x) => x?.toDouble())),
    snowfall: List<num>.from(json["snowfall"].map((x) => x)),
    weatherCode: List<int>.from(json["weather_code"].map((x) => x)),
    soilTemperature0Cm: List<double>.from(
      json["soil_temperature_0cm"].map((x) => x?.toDouble()),
    ),
  );

  Map<String, dynamic> toJson() => {
    "time": List<dynamic>.from(time.map((x) => x)),
    "temperature_2m": List<dynamic>.from(temperature2M.map((x) => x)),
    "wind_speed_10m": List<dynamic>.from(windSpeed10M.map((x) => x)),
    "relative_humidity_2m": List<dynamic>.from(
      relativeHumidity2M.map((x) => x),
    ),
    "rain": List<dynamic>.from(rain.map((x) => x)),
    "snowfall": List<dynamic>.from(snowfall.map((x) => x)),
    "weather_code": List<dynamic>.from(weatherCode.map((x) => x)),
    "soil_temperature_0cm": List<dynamic>.from(
      soilTemperature0Cm.map((x) => x),
    ),
  };
}

class HourlyUnits {
  String time;
  String temperature2M;
  String windSpeed10M;
  String relativeHumidity2M;
  String rain;
  String snowfall;
  String weatherCode;
  String soilTemperature0Cm;

  HourlyUnits({
    required this.time,
    required this.temperature2M,
    required this.windSpeed10M,
    required this.relativeHumidity2M,
    required this.rain,
    required this.snowfall,
    required this.weatherCode,
    required this.soilTemperature0Cm,
  });

  factory HourlyUnits.fromJson(Map<String, dynamic> json) => HourlyUnits(
    time: json["time"],
    temperature2M: json["temperature_2m"],
    windSpeed10M: json["wind_speed_10m"],
    relativeHumidity2M: json["relative_humidity_2m"],
    rain: json["rain"],
    snowfall: json["snowfall"],
    weatherCode: json["weather_code"],
    soilTemperature0Cm: json["soil_temperature_0cm"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "temperature_2m": temperature2M,
    "wind_speed_10m": windSpeed10M,
    "relative_humidity_2m": relativeHumidity2M,
    "rain": rain,
    "snowfall": snowfall,
    "weather_code": weatherCode,
    "soil_temperature_0cm": soilTemperature0Cm,
  };
}

/// GETTER CREATE  large app hoy to saprate class create karo. ///

class HourlyItem {
  final String? time;
  final double temperature2M;
  final double windSpeed10M;
  final int relativeHumidity2M;
  final double rain;
  final num snowfall;
  final int weatherCode;
  final double soilTemperature0Cm;

  HourlyItem({
    required this.time,
    required this.temperature2M,
    required this.windSpeed10M,
    required this.relativeHumidity2M,
    required this.rain,
    required this.snowfall,
    required this.weatherCode,
    required this.soilTemperature0Cm,
  });

  String get timeOnly {
    if (time == null || time!.isEmpty) return "--:--";
    try {
      final date = DateTime.parse(time!);

      return DateFormat("hh:mm a").format(date);
    } catch (e) {
      return "Error";
    }
  }

  // ૨. ફક્ત તારીખ માટે (દા.ત. 27 Mar, Fri)
  String get dateOnly {
    if (time == null || time!.isEmpty) return "--/--";
    try {
      final date = DateTime.parse(time!);
      return DateFormat("dd MMM, EEE").format(date);
    } catch (e) {
      return "Error";
    }
  }

  // ૩. આખી વિગત માટે (તમે જે પહેલા પૂછ્યું હતું તે)
  String get fullDateTime {
    if (time == null || time!.isEmpty) return "no Date";
    try {
      final date = DateTime.parse(time!);
      return DateFormat('EEE, dd MMM - hh:mm a').format(date);
    } catch (e) {
      return "Error";
    }
  }

  factory HourlyItem.empty() {
    return HourlyItem(
      time: "",
      temperature2M: 0.0,
      weatherCode: 0,
      relativeHumidity2M: 0,
      rain: 0.0,
      snowfall: 0.0,
      soilTemperature0Cm: 0.0,
      windSpeed10M: 0.0,
    );
  }
}

class CurrentWeather {
  double temperature;
  double windspeed;
  int weathercode;
  int isDay;
  String time;

  CurrentWeather({
    required this.temperature,
    required this.windspeed,
    required this.weathercode,
    required this.isDay,
    required this.time,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) => CurrentWeather(
    temperature: json["temperature"]?.toDouble(),
    windspeed: json["windspeed"]?.toDouble(),
    weathercode: json["weathercode"],
    isDay: json["is_day"],
    time: json["time"],
  );
}
