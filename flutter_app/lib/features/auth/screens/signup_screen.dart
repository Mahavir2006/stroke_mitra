import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme.dart';
import '../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _fullNameController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        } else if (!state.isLoading && !state.hasError && state.value == null) {
          // If sign up succeeded but no automatic login depending on confirm email
          // We can just rely on auth state router if it logs in or show success.
        }
      },
    );

    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgApp,
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
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
                        Text(
                          'Join Stroke Mitra',
                          style: AppTheme.headingMD,
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(),
                        const SizedBox(height: AppTheme.spaceXS),
                        Text(
                          'Create an account to securely store your stroke screening results and monitor your health.',
                          style: AppTheme.bodyMD,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppTheme.spaceXL),
                        TextFormField(
                          controller: _fullNameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                            ),
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppTheme.spaceMD),
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
                              return 'Password must be at least 6 characters for security';
                            }
                            return null;
                          },
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
                              : const Text('Sign Up'),
                        ),
                        const SizedBox(height: AppTheme.spaceMD),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: AppTheme.bodyMD,
                            ),
                            TextButton(
                              onPressed: () => context.pop(),
                              child: Text(
                                'Sign In',
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
