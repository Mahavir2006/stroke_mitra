import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme.dart';
import '../providers/auth_provider.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth state changes to show errors or succeed.
    ref.listen<AsyncValue>(
      authControllerProvider,
      (_, state) {
        if (!state.isLoading && state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.toString()),
              backgroundColor: AppTheme.statusError,
            ),
          );
        }
      },
    );

    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgApp,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spaceLG),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                ),
                elevation: 0,
                color: AppTheme.bgCard,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spaceLG),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.favorite_rounded,
                          size: 48,
                          color: AppTheme.primary,
                        ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                        const SizedBox(height: AppTheme.spaceMD),
                        Text(
                          'Welcome Back',
                          style: AppTheme.headingMD,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppTheme.spaceXS),
                        Text(
                          'Sign in to securely access your stroke screening results.',
                          style: AppTheme.bodyMD,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppTheme.spaceXL),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                            ),
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppTheme.spaceMD),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                            ),
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty || value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppTheme.spaceSM),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => context.push('/forgot-password'),
                            child: Text(
                              'Forgot Password?',
                              style: AppTheme.bodySM.copyWith(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spaceLG),
                        ElevatedButton(
                          onPressed: authState.isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: authState.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Sign In'),
                        ),
                        const SizedBox(height: AppTheme.spaceMD),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: AppTheme.bodyMD,
                            ),
                            TextButton(
                              onPressed: () => context.push('/signup'),
                              child: Text(
                                'Sign Up',
                                style: AppTheme.bodyMD.copyWith(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
