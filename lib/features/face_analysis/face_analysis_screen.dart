import 'package:flutter/material.dart';
import '../../core/theme.dart';

class FaceAnalysisScreen extends StatelessWidget {
  const FaceAnalysisScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Face Analysis', style: TextStyle(fontFamily: 'Outfit'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_front, size: 80, color: AppTheme.primary),
            const SizedBox(height: 24),
            const Text('Camera integration will go here', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Utilizes camera and google_mlkit_face_detection', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Start Camera'),
            )
          ],
        ),
      ),
    );
  }
}
