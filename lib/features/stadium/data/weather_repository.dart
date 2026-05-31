import 'dart:convert';
import 'dart:io';

import 'package:arca_tribun/core/stadium/stadium_info.dart';
import 'package:arca_tribun/features/stadium/domain/weather_snapshot.dart';

typedef FetchJson = Future<Map<String, dynamic>> Function(Uri uri);

class WeatherRepository {
  WeatherRepository({FetchJson? fetchJson}) : _fetchJson = fetchJson ?? _get;

  final FetchJson _fetchJson;

  Future<WeatherSnapshot> fetchCurrentStadiumWeather() async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '${StadiumInfo.latitude}',
      'longitude': '${StadiumInfo.longitude}',
      'current': 'temperature_2m,weather_code,wind_speed_10m',
      'timezone': 'Europe/Istanbul',
    });
    final json = await _fetchJson(uri);
    final current = json['current'] as Map<String, dynamic>?;
    if (current == null) throw const FormatException('current is missing');

    return WeatherSnapshot(
      temperature: (current['temperature_2m'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
    );
  }

  static Future<Map<String, dynamic>> _get(Uri uri) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(uri).timeout(
            const Duration(seconds: 6),
          );
      final response = await request.close().timeout(
            const Duration(seconds: 6),
          );
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(
          'Weather request failed: ${response.statusCode}',
          uri: uri,
        );
      }
      final payload = await response.transform(utf8.decoder).join();
      return jsonDecode(payload) as Map<String, dynamic>;
    } finally {
      client.close(force: true);
    }
  }
}
