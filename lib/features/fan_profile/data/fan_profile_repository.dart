import 'package:arca_tribun/core/constants/supabase_tables.dart';
import 'package:arca_tribun/features/fan_profile/domain/fan_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Authenticated taraftarın kendi profilini yönetir.
class FanProfileRepository {
  FanProfileRepository({SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  String? get currentUserEmail => _supabase.auth.currentUser?.email;

  Stream<FanProfileModel?> watchCurrentProfile() async* {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      yield null;
      return;
    }

    yield await ensureCurrentProfile();

    yield* _supabase
        .from(SupabaseTables.fanProfiles)
        .stream(primaryKey: [SupabaseTables.colId])
        .eq(SupabaseTables.colId, user.id)
        .map((rows) {
          if (rows.isEmpty) return null;
          return FanProfileModel.fromSupabase(rows.first);
        });
  }

  /// Normalde auth trigger profili oluşturur. Eksik satır varsa yalnızca
  /// RLS'nin izin verdiği kolonlarla güvenli biçimde tamamlar.
  Future<FanProfileModel?> ensureCurrentProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final existingProfile = await _findProfile(user.id);
    if (existingProfile != null) return existingProfile;

    final avatarUrl = user.userMetadata?['avatar_url'] as String?;
    final values = <String, dynamic>{
      SupabaseTables.colId: user.id,
      SupabaseTables.colDisplayName: _displayNameFor(user),
      if (avatarUrl != null) SupabaseTables.colAvatarUrl: avatarUrl,
    };

    try {
      final row = await _supabase
          .from(SupabaseTables.fanProfiles)
          .insert(values)
          .select()
          .single();
      return FanProfileModel.fromSupabase(row);
    } on PostgrestException catch (error) {
      if (error.code != '23505') rethrow;
      return _findProfile(user.id);
    }
  }

  Future<void> updateDisplayName(String displayName) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw const AuthException('Oturum bulunamadı.');
    }

    await _supabase
        .from(SupabaseTables.fanProfiles)
        .update({SupabaseTables.colDisplayName: displayName.trim()}).eq(
      SupabaseTables.colId,
      user.id,
    );
  }

  Future<FanProfileModel?> _findProfile(String userId) async {
    final row = await _supabase
        .from(SupabaseTables.fanProfiles)
        .select()
        .eq(SupabaseTables.colId, userId)
        .maybeSingle();

    if (row == null) return null;
    return FanProfileModel.fromSupabase(row);
  }

  String _displayNameFor(User user) {
    final metadata = user.userMetadata ?? {};
    return (metadata['display_name'] as String?) ??
        (metadata['full_name'] as String?) ??
        user.email?.split('@').first ??
        'Taraftar';
  }
}
