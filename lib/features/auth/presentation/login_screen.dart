import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/failure.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'auth_provider.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.errorRed),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.huge),

              // ─── Logo & Title ─────────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusLg),
                      ),
                      child: const Icon(
                        Icons.sports_soccer,
                        color: AppColors.white,
                        size: 44,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('ARCA Tribün', style: AppTypography.displayMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Arca Çorum FK',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxxl),

              // ─── Form ─────────────────────────────────────────────────
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: AppTypography.bodyLarge,
                      decoration: InputDecoration(
                        labelText: 'auth.email'.tr(),
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: AppColors.secondaryGray),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Gerekli alan';
                        if (!value.contains('@'))
                          return 'Geçerli e-posta girin';
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: AppTypography.bodyLarge,
                      decoration: InputDecoration(
                        labelText: 'auth.password'.tr(),
                        prefixIcon: const Icon(Icons.lock_outlined,
                            color: AppColors.secondaryGray),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.secondaryGray,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Gerekli alan';
                        if (value.length < 6)
                          return 'Şifre en az 6 karakter olmalı';
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text('auth.forgot_password'.tr()),
                      ),
                    ),
                  ],
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
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text('veya', style: AppTypography.bodySmall),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // ─── Social Auth Buttons ───────────────────────────────────
              _SocialButton(
                id: 'google_login_btn',
                icon: Icons.g_mobiledata,
                label: 'auth.google'.tr(),
                onPressed: () =>
                    ref.read(authNotifierProvider.notifier).loginWithGoogle(),
              ),
              const SizedBox(height: AppSpacing.md),
              _SocialButton(
                id: 'apple_login_btn',
                icon: Icons.apple,
                label: 'auth.apple'.tr(),
                onPressed: () =>
                    ref.read(authNotifierProvider.notifier).loginWithApple(),
              ),
              const SizedBox(height: AppSpacing.md),
              _SocialButton(
                id: 'guest_login_btn',
                icon: Icons.person_outline,
                label: 'auth.guest'.tr(),
                onPressed: () =>
                    ref.read(authNotifierProvider.notifier).loginAsGuest(),
              ),

              const SizedBox(height: AppSpacing.xxxl),

              // ─── Register Link ────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('auth.no_account'.tr(), style: AppTypography.bodySmall),
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
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.id,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final String id;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      key: ValueKey(id),
      onPressed: onPressed,
      icon: Icon(icon, color: AppColors.white),
      label: Text(label),
    );
  }
}
