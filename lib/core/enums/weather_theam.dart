import 'dart:ui';

enum WeatherTheme { day, sunset, night, rainy, winter, summer }

extension WeatherThemeExtension on WeatherTheme {
  List<Color> get setColor {
    switch (this) {
      case WeatherTheme.day:
        return [const Color(0xFF4A90E2), const Color(0xFF91C4FF)];
      case WeatherTheme.sunset:
        return [const Color(0xFFF2994A), const Color(0xFFE2B04A)];
      case WeatherTheme.night:
        return [const Color(0xFF081421), const Color(0xFF1B304A)];

      case WeatherTheme.rainy:
        return [const Color(0xFF4B617A), const Color(0xFF2D3947)];
      case WeatherTheme.winter:
        return [const Color(0xFF83A4D4), const Color(0xFFB6FBFF)];
      case WeatherTheme.summer:
        return [const Color(0xFF2980B9), const Color(0xFF6DD5FA)];
    }
  }

  ///સ્ટેટસ બાર (Status Bar) ના આઈકોન કલર પણ થીમ મુજબ બદલવા mate
  Brightness get statusBrightness {
    return (this == WeatherTheme.night || this == WeatherTheme.rainy)
        ? Brightness.light
        : Brightness.dark;
  }

  String get lottiePath {
    switch (this) {
      case WeatherTheme.night:
        return "assets/lottie/night_stars.json";
      case WeatherTheme.rainy:
        return "assets/lottie/rain.json";
      case WeatherTheme.sunset:
        return "assets/lottie/sunset_clouds.json";
      case WeatherTheme.winter:
        return "assets/lottie/snow.json";
      case WeatherTheme.summer:
        return "assets/lottie/sunny_day.json";
      case WeatherTheme.day:
        return "assets/lottie/clouds.json";
    }
  }
}
