enum WeatherInterval {
  currentTime(0),
  hour1(1),
  hour2(2),
  hour4(4),
  day1(24),
  day2(48),
  day7(168);

  final int step;
  const WeatherInterval(this.step);
}
