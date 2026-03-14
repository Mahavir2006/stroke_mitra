/// Stroke Mitra - Face Analysis Screen
///
/// Mirrors the React `CameraModule` component.
/// Uses the device camera to capture the user's face,
/// displays a guide overlay with a face oval, and performs
/// mock analysis. Submits results to Supabase.

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../app/theme.dart';
import '../../shared/utils/session_service.dart';
import '../../core/constants.dart';

class FaceAnalysisScreen extends StatefulWidget {
  const FaceAnalysisScreen({super.key});

  @override
  State<FaceAnalysisScreen> createState() => _FaceAnalysisScreenState();
}

class _FaceAnalysisScreenState extends State<FaceAnalysisScreen>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  bool _isInitialized = false;
  bool _isAnalyzing = false;
  bool _hasError = false;
  String _errorMessage = '';
  Map<String, dynamic>? _result;

  // Scanning animation
  late AnimationController _scanAnimController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _scanAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scanAnimController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _startCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage =
            'Camera access denied. Please allow camera permissions to proceed.';
      });
    }
  }

  Future<void> _analyzeFace() async {
    setState(() => _isAnalyzing = true);
    _scanAnimController.repeat();

    // Mock analysis — simulates 2-second processing (matches React behavior)
    await Future.delayed(const Duration(seconds: 2));

    final mockResult = {
      'symmetry': 0.98,
      'status': 'Normal',
      'message': 'No significant asymmetry detected.',
      'confidence': 0.95,
    };

    // Fire-and-forget — submit to Supabase
    SessionService.submitData(
      'temp-session',
      AppConstants.dataTypeFace,
      mockResult,
    );

    if (mounted) {
      _scanAnimController.stop();
      setState(() {
        _result = mockResult;
        _isAnalyzing = false;
      });
    }
  }

  void _reset() {
    setState(() {
      _result = null;
      _isAnalyzing = false;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _scanAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Header ───
          Row(
            children: [
              Icon(Icons.camera_alt_rounded,
                  color: AppTheme.primary, size: 24),
              const SizedBox(width: 8),
              Text('Face Analysis', style: AppTheme.headingMD),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Align your face within the frame. Maintain a neutral expression.',
            style: AppTheme.bodyMD,
          ),
          const SizedBox(height: AppTheme.spaceLG),

          // ─── Camera Frame ───
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusLG),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: _buildCameraView(),
            ),
          ),

          // ─── Error Message ───
          if (_hasError) ...[
            const SizedBox(height: AppTheme.spaceMD),
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceSM),
              decoration: BoxDecoration(
                color: AppTheme.statusError.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_rounded,
                      color: AppTheme.statusError, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.statusError,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppTheme.spaceMD),

          // ─── Controls ───
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    if (!_isInitialized) {
      return GestureDetector(
        onTap: _startCamera,
        child: Container(
          color: const Color(0xFFF0F2F5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_outlined,
                  size: 48, color: AppTheme.slate400),
              const SizedBox(height: 12),
              Text(
                'Tap to Enable Camera',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.slate500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Mirror the camera feed (matches React scaleX(-1))
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..scale(-1.0, 1.0),
          child: CameraPreview(_cameraController!),
        ),

        // Face oval guide overlay
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.7),
                width: 2,
                strokeAlign: BorderSide.strokeAlignCenter,
              ),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),

        // Scanning line animation
        if (_isAnalyzing)
          AnimatedBuilder(
            animation: _scanAnimation,
            builder: (context, child) {
              return Positioned(
                top: _scanAnimation.value *
                    (MediaQuery.of(context).size.width * 0.75 * 0.75),
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppTheme.blue400,
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.blue400.withValues(alpha: 0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

        // Dark overlay outside the oval
        ColorFiltered(
          colorFilter: _isAnalyzing
              ? const ColorFilter.mode(
                  Color(0x33996633), BlendMode.colorBurn)
              : const ColorFilter.mode(
                  Colors.transparent, BlendMode.srcOver),
          child: const SizedBox.expand(),
        ),
      ],
    );
  }

  Widget _buildControls() {
    if (!_isInitialized) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _startCamera,
          icon: const Icon(Icons.camera_alt_rounded),
          label: const Text('Grant Access'),
        ),
      );
    }

    if (_result != null) {
      return _buildResultCard();
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isAnalyzing ? null : _analyzeFace,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(AppTheme.spaceLG),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        child: Text(_isAnalyzing ? 'Analyzing...' : 'Capture & Analyze'),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_rounded,
                  color: AppTheme.statusSuccess, size: 24),
              const SizedBox(width: 8),
              Text(
                'Analysis Complete',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.statusSuccess,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMD),

          // Symmetry metric
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceSM),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Symmetry Score',
                    style: TextStyle(color: AppTheme.slate500)),
                Text(
                  '${((_result!['symmetry'] as double) * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppTheme.slate800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spaceSM),

          // Message
          Text(
            _result!['message'] as String,
            style: AppTheme.bodyMD,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spaceMD),

          // Retake button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Retake'),
            ),
          ),
        ],
      ),
    );
  }
}
