import 'package:arca_tribun/features/stadium/data/weather_repository.dart';
import 'package:arca_tribun/features/stadium/domain/weather_snapshot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepository(),
);

final stadiumWeatherProvider = FutureProvider<WeatherSnapshot>((ref) {
  return ref.watch(weatherRepositoryProvider).fetchCurrentStadiumWeather();
});
