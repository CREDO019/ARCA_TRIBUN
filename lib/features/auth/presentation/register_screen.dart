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

/// Kayıt ekranı
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await ref.read(authNotifierProvider.notifier).registerWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    final authState = ref.read(authNotifierProvider);
    authState.when(
      data: (user) {
        if (user != null) context.go(RouteNames.home);
      },
      error: (error, _) {
        final message =
            error is Failure ? error.message.tr() : 'errors.unknown'.tr();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.errorRed,
          ),
        );
      },
      loading: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('auth.create_account'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.lg),

                Text(
                  'Taraftar Hesabı Oluştur',
                  style: AppTypography.headlineLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'ARCA Tribün ailesine katıl, puan kazan!',
                  style: AppTypography.bodyMedium,
                ),

                const SizedBox(height: AppSpacing.xxxl),

                // Display Name
                TextFormField(
                  controller: _nameController,
                  autofillHints: const [AutofillHints.name],
                  textInputAction: TextInputAction.next,
                  style: AppTypography.bodyLarge,
                  decoration: InputDecoration(
                    labelText: 'auth.display_name'.tr(),
                    prefixIcon: const Icon(Icons.person_outline,
                        color: AppColors.secondaryGray),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Gerekli alan';
                    if (value.length < 3) return 'En az 3 karakter olmalı';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Email
                TextFormField(
                  controller: _emailController,
                  autofillHints: const [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: AppTypography.bodyLarge,
                  decoration: InputDecoration(
                    labelText: 'auth.email'.tr(),
                    prefixIcon: const Icon(Icons.email_outlined,
                        color: AppColors.secondaryGray),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Gerekli alan';
                    if (!value.contains('@')) return 'Geçerli e-posta girin';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Password
                TextFormField(
                  controller: _passwordController,
                  autofillHints: const [AutofillHints.newPassword],
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
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
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Gerekli alan';
                    if (value.length < 6) return 'En az 6 karakter olmalı';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _register(),
                  style: AppTypography.bodyLarge,
                  decoration: InputDecoration(
                    labelText: 'auth.confirm_password'.tr(),
                    prefixIcon: const Icon(Icons.lock_outlined,
                        color: AppColors.secondaryGray),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text)
                      return 'Şifreler eşleşmiyor';
                    return null;
                  },
                ),

                const SizedBox(height: AppSpacing.xxxl),

                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : Text('auth.register'.tr().toUpperCase()),
                ),

                const SizedBox(height: AppSpacing.xl),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('auth.already_have_account'.tr(),
                        style: AppTypography.bodySmall),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text('auth.sign_in'.tr()),
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
