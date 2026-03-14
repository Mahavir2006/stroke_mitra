import 'package:flutter/material.dart';
import '../../core/theme.dart';

class MotionTestScreen extends StatelessWidget {
  const MotionTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Motion Test', style: TextStyle(fontFamily: 'Outfit'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.screen_rotation, size: 80, color: AppTheme.lpOrange400),
            const SizedBox(height: 24),
            const Text('Accelerometer integration will go here', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Utilizes sensors_plus to calculate device stability', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.lpOrange400),
              onPressed: () {},
              child: const Text('Start Motion Test'),
            )
          ],
        ),
      ),
    );
  }
}
