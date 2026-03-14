import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authControllerProvider.notifier).resetPassword(
            _emailController.text.trim(),
          );
      final state = ref.read(authControllerProvider);
      if (!state.hasError) {
        setState(() {
          _emailSent = true;
        });
      }
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
        }
      },
    );

    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgApp,
      appBar: AppBar(
        title: const Text('Reset Password'),
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
                  child: _emailSent
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              size: 48,
                              color: AppTheme.statusSuccess,
                            ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                            const SizedBox(height: AppTheme.spaceMD),
                            Text(
                              'Email Sent',
                              style: AppTheme.headingMD,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppTheme.spaceXS),
                            Text(
                              'Check your inbox for instructions to reset your password.',
                              style: AppTheme.bodyMD,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppTheme.spaceXL),
                            ElevatedButton(
                              onPressed: () => context.pop(),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text('Back to Login'),
                            )
                          ],
                        )
                      : Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Recover Account',
                                style: AppTheme.headingMD,
                                textAlign: TextAlign.center,
                              ).animate().fadeIn(),
                              const SizedBox(height: AppTheme.spaceXS),
                              Text(
                                'Enter your email address and we will send you a link to reset your password.',
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
                                    : const Text('Send Reset Link'),
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
