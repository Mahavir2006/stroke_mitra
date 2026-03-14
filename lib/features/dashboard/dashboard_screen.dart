import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stroke Mitra', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Outfit')),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Early Detection Saves Lives',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Outfit', fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.lpSlate800),
              ),
              const SizedBox(height: 12),
              const Text(
                'Perform a quick self-check if you suspect symptoms.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppTheme.lpSlate500),
              ),
              const SizedBox(height: 48),
              _buildActionCard(
                context,
                title: 'Face Analysis',
                subtitle: 'Check for facial drooping',
                icon: Icons.camera_alt,
                route: '/face',
              ),
              const SizedBox(height: 16),
              _buildActionCard(
                context,
                title: 'Speech Check',
                subtitle: 'Analyze speech clarity',
                icon: Icons.mic,
                route: '/voice',
              ),
              const SizedBox(height: 16),
              _buildActionCard(
                context,
                title: 'Motion Test',
                subtitle: 'Assess arm stability',
                icon: Icons.monitor_heart,
                route: '/motion',
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Medical Disclaimer: Not a diagnostic tool. Call 112 immediately if you suspect a stroke.',
                        style: TextStyle(color: Colors.red.shade900, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required String route}) {
    return InkWell(
      onTap: () => context.push(route),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
          ],
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.bgApp,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppTheme.primary, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.lpSlate800)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 14, color: AppTheme.lpSlate500)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, color: AppTheme.lpSlate300),
          ],
        ),
      ),
    );
  }
}
