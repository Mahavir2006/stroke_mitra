import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 20 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 20 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const HeroSection(),
                const WhatIsSection(),
                const HowItWorksSection(),
                const FeaturesSection(),
                // StatsSection and CTASection would follow here.
              ],
            ),
          ),
          // Navbar overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: _isScrolled ? Colors.white.withOpacity(0.95) : Colors.transparent,
                boxShadow: _isScrolled ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)] : [],
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.monitor_heart, color: _isScrolled ? AppTheme.lpBlue700 : Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          'Stroke Mitra',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: _isScrolled ? AppTheme.lpBlue700 : Colors.white,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.lpBlue500,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () => context.go('/app'),
                      child: const Text('Check Symptoms', style: TextStyle(fontWeight: FontWeight.bold)),
                    ).animate().fadeIn(duration: 500.ms),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0C4A6E), Color(0xFF0369A1), Color(0xFF0D9488)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.lpGreen400, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    const Text('AI-Powered Stroke Screening', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ).animate().fade(duration: 700.ms).slideY(begin: 0.2, end: 0),
              
              const SizedBox(height: 24),
              const Text(
                'Detect Stroke Early.\nSave Lives.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Outfit', fontSize: 42, height: 1.1, fontWeight: FontWeight.w900, color: Colors.white),
              ).animate(delay: 150.ms).fade(duration: 700.ms).slideY(begin: 0.2, end: 0),
              
              const SizedBox(height: 24),
              const Text(
                'Stroke Mitra uses your device\'s camera, microphone, and motion sensors to screen for early stroke symptoms — in under 60 seconds.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white70, height: 1.5),
              ).animate(delay: 300.ms).fade(duration: 700.ms).slideY(begin: 0.2, end: 0),
              
              const SizedBox(height: 48),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.lpBlue700,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => context.go('/app'),
                    icon: const Icon(Icons.play_circle_fill),
                    label: const Text('Check Symptoms'),
                  ),
                ],
              ).animate(delay: 450.ms).fade(duration: 700.ms).slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class WhatIsSection extends StatelessWidget {
  const WhatIsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: AppTheme.bgApp,
      child: Column(
        children: [
          const Text('ABOUT', style: TextStyle(color: AppTheme.lpBlue700, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 16),
          const Text('What is Stroke Mitra?', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Outfit', fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.lpSlate800)),
          const SizedBox(height: 16),
          const Text(
            'Stroke Mitra is an AI-powered screening tool that helps identify early warning signs of stroke using your smartphone\'s built-in sensors.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppTheme.lpSlate500),
          ),
          const SizedBox(height: 48),
          // Mocks for What is section cards
          _buildInfoCard(Icons.medical_services, 'Clinically Informed', 'Built on the FAST framework used by professionals.', AppTheme.primary),
          const SizedBox(height: 16),
          _buildInfoCard(Icons.security, 'Device-Native AI', 'No cloud uploads, data stays yours.', AppTheme.secondary),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String desc, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)]),
      child: Column(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.lpSlate800)),
          const SizedBox(height: 8),
          Text(desc, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.lpSlate500)),
        ],
      ),
    );
  }
}

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Column(
        children: const [
          Text('PROCESS', style: TextStyle(color: AppTheme.lpBlue700, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          SizedBox(height: 16),
          Text('How It Works', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Outfit', fontSize: 32, fontWeight: FontWeight.bold)),
          SizedBox(height: 32),
          Text('1. Face Detection\n2. Voice Analysis\n3. Motion Test\n4. Results Viewer', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, height: 1.8)),
        ],
      ),
    );
  }
}

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.bgApp,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Column(
        children: const [
          Text('FEATURES', style: TextStyle(color: AppTheme.lpBlue700, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          SizedBox(height: 16),
          Text('Built for Speed.\nDesigned for Trust.', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Outfit', fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
