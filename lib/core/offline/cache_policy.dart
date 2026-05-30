import '../constants/app_constants.dart';

/// Önbellekleme politikalarını tanımlar.
/// TTL (Time-To-Live) bazlı cache geçerlilik kontrolü.
class CachePolicy {
  const CachePolicy._();

  /// Belirtilen süre içinde cache geçerlidir
  static bool isFresh({
    required DateTime cachedAt,
    required Duration ttl,
  }) {
    return DateTime.now().difference(cachedAt) < ttl;
  }

  /// Haber önbelleği hala geçerli mi?
  static bool isNewsFresh(DateTime cachedAt) =>
      isFresh(cachedAt: cachedAt, ttl: AppConstants.cacheDurationNews);

  /// Fikstür önbelleği hala geçerli mi?
  static bool isFixturesFresh(DateTime cachedAt) =>
      isFresh(cachedAt: cachedAt, ttl: AppConstants.cacheDurationFixtures);

  /// Puan durumu önbelleği geçerli mi?
  static bool isStandingsFresh(DateTime cachedAt) =>
      isFresh(cachedAt: cachedAt, ttl: AppConstants.cacheDurationStandings);

  /// Kadro önbelleği geçerli mi?
  static bool isSquadFresh(DateTime cachedAt) =>
      isFresh(cachedAt: cachedAt, ttl: AppConstants.cacheDurationSquad);

  /// Canlı maç önbelleği — hiçbir zaman cache'lenmez (her zaman Firestore stream kullan)
  static bool isLiveMatchFresh(DateTime cachedAt) => false;

  /// Custom TTL ile cache kontrolü
  static bool isCustomFresh(DateTime cachedAt, Duration ttl) =>
      isFresh(cachedAt: cachedAt, ttl: ttl);
}
