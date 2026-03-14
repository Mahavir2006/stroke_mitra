import 'package:flutter/material.dart';
import '../../core/theme.dart';

class SpeechCheckScreen extends StatelessWidget {
  const SpeechCheckScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speech Check', style: TextStyle(fontFamily: 'Outfit'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mic, size: 80, color: AppTheme.lpTeal400),
            const SizedBox(height: 24),
            const Text('Microphone integration will go here', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Utilizes record package to capture audio chunks', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.lpTeal400),
              onPressed: () {},
              child: const Text('Start Recording'),
            )
          ],
        ),
      ),
    );
  }
}
