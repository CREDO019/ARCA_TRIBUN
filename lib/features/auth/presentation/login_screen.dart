import 'package:arca_tribun/core/error/failure.dart';
import 'package:arca_tribun/core/router/route_names.dart';
import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/auth/presentation/auth_provider.dart';
import 'package:arca_tribun/shared/widgets/club_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Giriş ekranı — email/şifre, Google, Apple, Misafir
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isPasswordResetLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await ref.read(authNotifierProvider.notifier).loginWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    final authState = ref.read(authNotifierProvider);
    authState.when(
      data: (user) {
        if (user != null) context.go(RouteNames.home);
      },
      error: (error, _) => _showError(error),
      loading: () {},
    );
  }

  void _showError(Object error) {
    final message =
        error is Failure ? error.message.tr() : 'errors.unknown'.tr();
    _showMessage(message, isError: true);
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.errorRed : null,
      ),
    );
  }

  Future<void> _sendPasswordReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showMessage(
        'Şifre yenileme bağlantısı için geçerli e-posta adresinizi yazın.',
      );
      return;
    }

    setState(() => _isPasswordResetLoading = true);
    final result =
        await ref.read(authRepositoryProvider).sendPasswordResetEmail(email);
    if (!mounted) return;
    setState(() => _isPasswordResetLoading = false);

    result.fold(
      _showError,
      (_) => _showMessage(
        'Şifre yenileme bağlantısı e-posta adresinize gönderildi.',
      ),
    );
  }

  void _showGuestInfo() {
    _showMessage('Misafir erişimi yakında aktif olacak.');
  }

  void _showSocialAuthInfo() {
    _showMessage('Sosyal giriş seçenekleri yakında aktif olacak.');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
          .copyWith(
        statusBarColor: Colors.transparent,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.xl),

                // ─── Logo & Title ─────────────────────────────────────────
                const _LoginHeader(),

                const SizedBox(height: AppSpacing.xxl),

                Container(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(color: colors.border),
                  ),
                  child: Form(
                    key: _formKey,
                    child: AutofillGroup(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            autofillHints: const [AutofillHints.email],
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: Theme.of(context).textTheme.bodyLarge,
                            decoration: InputDecoration(
                              labelText: 'auth.email'.tr(),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: colors.textSecondary,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Gerekli alan';
                              }
                              if (!value.contains('@')) {
                                return 'Geçerli e-posta girin';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _passwordController,
                            autofillHints: const [AutofillHints.password],
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _loginWithEmail(),
                            style: Theme.of(context).textTheme.bodyLarge,
                            decoration: InputDecoration(
                              labelText: 'auth.password'.tr(),
                              prefixIcon: Icon(
                                Icons.lock_outlined,
                                color: colors.textSecondary,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: colors.textSecondary,
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Gerekli alan';
                              }
                              if (value.length < 6) {
                                return 'Şifre en az 6 karakter olmalı';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _isPasswordResetLoading
                                  ? null
                                  : _sendPasswordReset,
                              child: Text(
                                _isPasswordResetLoading
                                    ? 'Gönderiliyor...'
                                    : 'auth.forgot_password'.tr(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // ─── Login Button ─────────────────────────────────────────
                ElevatedButton(
                  onPressed: _isLoading ? null : _loginWithEmail,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : Text('auth.login'.tr().toUpperCase()),
                ),

                const SizedBox(height: AppSpacing.xl),

                // ─── Divider ──────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(child: Divider(color: colors.border)),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Text(
                        'veya',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Expanded(child: Divider(color: colors.border)),
                  ],
                ),

                const SizedBox(height: AppSpacing.xl),

                // ─── Social Auth Buttons ───────────────────────────────────
                _SocialButton(
                  buttonKey: const Key('google_login_btn'),
                  icon: Icons.g_mobiledata,
                  label: 'auth.google'.tr(),
                  subtitle: 'Yakında',
                  onPressed: _showSocialAuthInfo,
                ),
                const SizedBox(height: AppSpacing.md),
                _SocialButton(
                  buttonKey: const Key('apple_login_btn'),
                  icon: Icons.apple,
                  label: 'auth.apple'.tr(),
                  subtitle: 'Yakında',
                  onPressed: _showSocialAuthInfo,
                ),
                const SizedBox(height: AppSpacing.md),
                _SocialButton(
                  buttonKey: const Key('guest_login_btn'),
                  icon: Icons.person_outline,
                  label: 'auth.guest'.tr(),
                  subtitle: 'Yakında',
                  onPressed: _showGuestInfo,
                ),

                const SizedBox(height: AppSpacing.xl),

                // ─── Register Link ────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'auth.no_account'.tr(),
                      style: AppTypography.bodySmall,
                    ),
                    TextButton(
                      onPressed: () => context.push(RouteNames.register),
                      child: Text('auth.register'.tr()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ClubLogo(size: 104, showShadow: true),
        const SizedBox(height: AppSpacing.lg),
        Text('ARCA TRİBÜN', style: AppTypography.displayMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Kırmızı siyah ruhun dijital evi',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.buttonKey,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.subtitle,
  });

  final Key buttonKey;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;

    return OutlinedButton.icon(
      key: buttonKey,
      onPressed: onPressed,
      icon: Icon(icon, color: colors.textPrimary),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (subtitle != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
