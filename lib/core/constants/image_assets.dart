class ImageAssets {
  /// private constructor a class no koi out side object create na kari sake ane aa class ma normal variable, methods hoy to tene
  /// aa object no used kari koi pon jagya par used kari sakay ane aa class no koi other object create na kari sakay error aapse private constructor se etle.
  ImageAssets._();
  static const String _basePath = "assets/images";

  static const String splash = "$_basePath/splash.png";
  static const String cloudy = "$_basePath/cloudy.png";
  static const String foggy = "$_basePath/foggy.png";
  static const String rainy = "$_basePath/rainy.png";
  static const String partlyCloudy = "$_basePath/partly_cloudy_day.png";
  static const String rainyHeavy = "$_basePath/rainy_heavy.png";
  static const String snow = "$_basePath/snowing.png";
  static const String sunny = "$_basePath/sunny.png";
  static const String mainlyClear = "$_basePath/sunny.png";
  static const String thunderStorm = "$_basePath/thunderstorm.png";
  static const String unknown = "$_basePath/sunny_light.svg";
  static const String sunnyNight = "$_basePath/mainlyClearSkyNight.png";
  static const String mainlyClearNight = "$_basePath/mainlyClearNight.png";
  static const String partlyCloudNight = "$_basePath/partlyCloudNight.png";
  static const String thunderStormNight = "$_basePath/thunderNight.png";
  static const String mapImg = "$_basePath/map.png";
  static const String byDefault = "$_basePath/default.png";
}

enum WeatherCondition {
  // ૧. દરેક કેસની સાથે તેનો કોડ, નામ અને AppAssets માંથી પાથ સેટ કરો
  clear(0, "Clear Sky", ImageAssets.sunny, false),
  partlyCloudy(1, "Mainly Clear", ImageAssets.partlyCloudy, false),
  partlyCloudyMedium(2, "Partly Cloudy", ImageAssets.partlyCloudy, false),
  partlyOvercast(3, "Overcast", ImageAssets.partlyCloudy, false),
  fog(45, "Fog", ImageAssets.foggy, false),
  fogMedium(48, "Fog", ImageAssets.foggy, false),
  drizzle(51, "Drizzle", ImageAssets.rainy, false),
  drizzleMedium(53, "Drizzle", ImageAssets.rainy, false),
  drizzleOvercast(55, "Drizzle", ImageAssets.rainy, false),
  rain(61, "Rainy", ImageAssets.rainy, false),
  rainMedium(63, "Rainy", ImageAssets.rainy, false),
  rainOvercast(65, "Rainy", ImageAssets.rainy, false),
  snow(71, "Snowy", ImageAssets.snow, false),
  snowMedium(73, "Snowy", ImageAssets.snow, false),
  snowOvercast(75, "Snowy", ImageAssets.snow, false),
  rainShowers(80, "Rain Showers", ImageAssets.rainyHeavy, false),
  rainShowersMedium(81, "Rain Showers", ImageAssets.rainyHeavy, false),
  rainShowersOvercast(82, "Rain Showers", ImageAssets.rainyHeavy, false),
  thunderstorm(95, "Thunderstorm", ImageAssets.thunderStorm, false),
  thunderstormMedium(96, "Thunderstorm", ImageAssets.thunderStorm, false),
  thunderstormOvercast(99, "Thunderstorm", ImageAssets.thunderStorm, false),
  unknown(-1, "Unknown", ImageAssets.unknown, false), // unknown આઈકોન વાપર્યો
  clearNight(0, "Clear Sky Night", ImageAssets.sunnyNight, true),
  mainlyClearNight(1, "Mainly Clear Night", ImageAssets.mainlyClearNight, true),
  partlyCloudyNight(
    2,
    "Partly Cloudy Night",
    ImageAssets.partlyCloudNight,
    true,
  ),
  thunderstormNight(
    95,
    "Thunderstorm Night",
    ImageAssets.thunderStormNight,
    true,
  );

  // ૨. વેરીએબલ્સ (fields) વ્યાખ્યાયિત કરો
  final int code;
  final String description;
  final String imagePath; // 'image' ના બદલે 'imagePath' વધુ સારું છે
  final bool isNight;

  // ૩. કોન્સ્ટ્રક્ટર (Constructor)
  // **Correction**: અહીં 'this.imagePath' વાપરવું પડે, તમે 'this.icon' લખ્યું હતું.
  const WeatherCondition(
    this.code,
    this.description,
    this.imagePath,
    this.isNight,
  );

  // ૪. API માંથી આવતા નંબરને Enum માં બદલવા માટેનું ફંક્શન
  static WeatherCondition fromCode(int code, {required bool isNight}) {
    // આ એક static const Map છે, જે માત્ર એક જ વાર મેમરીમાં બને છે.
    final Map<int, WeatherCondition> codeMap = {
      0: WeatherCondition.clear,
      1: WeatherCondition.partlyCloudy,
      2: WeatherCondition.partlyCloudy,
      3: WeatherCondition.partlyCloudy,
      45: WeatherCondition.fog,
      48: WeatherCondition.fog,
      51: WeatherCondition.drizzle,
      53: WeatherCondition.drizzle,
      55: WeatherCondition.drizzle,
      61: WeatherCondition.rain,
      63: WeatherCondition.rain,
      65: WeatherCondition.rain,
      71: WeatherCondition.snow,
      73: WeatherCondition.snow,
      75: WeatherCondition.snow,
      80: WeatherCondition.rainShowers,
      81: WeatherCondition.rainShowers,
      82: WeatherCondition.rainShowers,
      95: WeatherCondition.thunderstorm,
      96: WeatherCondition.thunderstorm,
      99: WeatherCondition.thunderstorm,
    };

    final WeatherCondition condition =
        codeMap[code] ?? WeatherCondition.unknown;

    // જો રાત હોય અને આ કેસમાં ફેરફાર કરવાનો હોય તો ચેક કરો
    if (isNight) {
      // **ખાસ લોજિક**: રાત્રિ માટે યોગ્ય કેસ શોધો
      return WeatherCondition.values.firstWhere(
        (e) => e.code == code && e.isNight == true,
        // જો રાત્રિનો કેસ ન મળે (દા.ત. fog), તો ડિફોલ્ટ દિવસનો (condition) જ રિટર્ન કરો
        orElse: () => condition,
      );
    } else {
      // દિવસ માટે યોગ્ય કેસ શોધો
      return WeatherCondition.values.firstWhere(
        (e) => e.code == code && e.isNight == false,
        // જો દિવસનો કેસ ન મળે (null), તો ડિફોલ્ટ દિવસનો (condition) જ રિટર્ન કરો
        orElse: () => condition,
      );
    }
  }
}
