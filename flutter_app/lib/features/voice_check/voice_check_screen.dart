/// Stroke Mitra - Voice Check Screen
///
/// Mirrors the React `VoiceModule` component.
/// Records audio using the `record` package, displays a
/// visualizer animation, and provides playback with mock analysis.

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../app/theme.dart';
import '../../core/constants.dart';

class VoiceCheckScreen extends StatefulWidget {
  const VoiceCheckScreen({super.key});

  @override
  State<VoiceCheckScreen> createState() => _VoiceCheckScreenState();
}

class _VoiceCheckScreenState extends State<VoiceCheckScreen>
    with TickerProviderStateMixin {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  bool _isRecording = false;
  String? _recordingPath;
  bool _hasRecording = false;

  // Visualizer animation
  late AnimationController _vizAnimController;

  @override
  void initState() {
    super.initState();
    _vizAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  Future<void> _startRecording() async {
    try {
      if (await _recorder.hasPermission()) {
        final dir = await getTemporaryDirectory();
        final path = '${dir.path}/stroke_mitra_recording.m4a';

        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            numChannels: 1,
            sampleRate: 44100,
          ),
          path: path,
        );

        setState(() {
          _isRecording = true;
          _recordingPath = path;
        });
        _vizAnimController.repeat(reverse: true);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Microphone access denied.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recording error: $e')),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorder.stop();
      _vizAnimController.stop();
      _vizAnimController.reset();

      if (mounted) {
        setState(() {
          _isRecording = false;
          _hasRecording = true;
          if (path != null) _recordingPath = path;
        });
      }
    } catch (e) {
      setState(() => _isRecording = false);
    }
  }

  Future<void> _playRecording() async {
    if (_recordingPath != null) {
      await _player.play(DeviceFileSource(_recordingPath!));
    }
  }

  @override
  void dispose() {
    _recorder.dispose();
    _player.dispose();
    _vizAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ─── Header ───
          Row(
            children: [
              Icon(Icons.mic_rounded, color: AppTheme.primary, size: 24),
              const SizedBox(width: 8),
              Text('Voice Check', style: AppTheme.headingMD),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Read the following sentence clearly:',
              style: AppTheme.bodyMD,
            ),
          ),
          const SizedBox(height: AppTheme.spaceMD),

          // ─── Prompt Card ───
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spaceLG),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border(
                left: BorderSide(color: AppTheme.primary, width: 4),
              ),
            ),
            child: Text(
              '"${AppConstants.voicePrompt}"',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppTheme.slate800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppTheme.spaceLG),

          // ─── Visualizer ───
          AnimatedBuilder(
            animation: _vizAnimController,
            builder: (context, child) {
              return SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final delay = i * 0.1;
                    final height = _isRecording
                        ? 12.0 +
                            (48.0 *
                                (0.3 + 0.7 * _vizAnimController.value) *
                                [0.6, 0.9, 1.0, 0.8, 0.5][i])
                        : 12.0;
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 100 + (i * 50)),
                      width: 8,
                      height: height,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.secondary.withValues(
                          alpha: _isRecording ? 1.0 : 0.3,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
          const SizedBox(height: AppTheme.spaceLG),

          // ─── Record / Stop Button ───
          SizedBox(
            width: 300,
            child: !_isRecording
                ? ElevatedButton.icon(
                    onPressed: _startRecording,
                    icon: const Icon(Icons.mic_rounded, size: 20),
                    label: Text(
                        _hasRecording ? 'Record Again' : 'Start Recording'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(AppTheme.spaceLG),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: _stopRecording,
                    icon: const Icon(Icons.stop_rounded, size: 20),
                    label: const Text('Stop'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.statusError,
                      padding: const EdgeInsets.all(AppTheme.spaceLG),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
          ),

          // ─── Playback & Analysis ───
          if (_hasRecording) ...[
            const SizedBox(height: AppTheme.spaceLG),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spaceMD),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              ),
              child: Column(
                children: [
                  // Play button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _playRecording,
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Play Recording'),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceMD),
                  // Analysis stub — matches React component
                  Row(
                    children: [
                      Icon(Icons.bar_chart_rounded,
                          size: 16, color: AppTheme.secondary),
                      const SizedBox(width: 8),
                      Text(
                        'Analysis: Clarity 96% (Normal)',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppTheme.spaceLG),
        ],
      ),
    );
  }
}
