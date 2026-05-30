import 'package:equatable/equatable.dart';

/// Kullanıcı domain modeli.
class UserModel extends Equatable {
  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.isGuest,
    this.photoUrl,
    this.preferredLocale = 'tr',
  });

  final String uid;
  final String? email;
  final String displayName;
  final bool isGuest;
  final String? photoUrl;
  final String preferredLocale;

  /// Tam auth var mı (guest değil)
  bool get isFullyAuthenticated => !isGuest;

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    bool? isGuest,
    String? photoUrl,
    String? preferredLocale,
  }) =>
      UserModel(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        displayName: displayName ?? this.displayName,
        isGuest: isGuest ?? this.isGuest,
        photoUrl: photoUrl ?? this.photoUrl,
        preferredLocale: preferredLocale ?? this.preferredLocale,
      );

  @override
  List<Object?> get props =>
      [uid, email, displayName, isGuest, photoUrl, preferredLocale];
}
