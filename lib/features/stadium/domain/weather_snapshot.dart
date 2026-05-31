class WeatherSnapshot {
  const WeatherSnapshot({
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
  });

  final double temperature;
  final int weatherCode;
  final double windSpeed;

  String get conditionLabel {
    if (weatherCode == 0) return 'Açık';
    if (weatherCode <= 3) return 'Parçalı bulutlu';
    if (weatherCode <= 48) return 'Sisli';
    if (weatherCode <= 57) return 'Çiseli';
    if (weatherCode <= 67) return 'Yağmurlu';
    if (weatherCode <= 77) return 'Karlı';
    if (weatherCode <= 82) return 'Sağanak yağışlı';
    if (weatherCode <= 86) return 'Kar sağanaklı';
    return 'Gök gürültülü';
  }
}
