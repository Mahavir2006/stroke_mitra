/// Stats Section — Animated counters + F.A.S.T. banner
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';

class StatsSection extends StatefulWidget {
  const StatsSection({super.key});
  @override
  State<StatsSection> createState() => _StatsSectionState();
}

class _StatsSectionState extends State<StatsSection> with TickerProviderStateMixin {
  late AnimationController _ctrl;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));
    // Auto-start after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) { _started = true; _ctrl.forward(); }
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final stats = [
      _Stat(15000000, '+', 'Strokes occur globally each year', AppTheme.blue400),
      _Stat(80, '%', 'Of strokes are preventable with early action', AppTheme.teal400),
      _Stat(1900000, '', 'Brain cells lost every minute untreated', AppTheme.orange400),
      _Stat(3, 'x', 'Better outcomes with treatment in first hour', AppTheme.green400),
    ];

    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.darkGradient),
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1160),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text('THE STAKES', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: Colors.white.withValues(alpha: 0.8))),
          ),
          const SizedBox(height: 16),
          Text('Why Every Second Counts', style: GoogleFonts.outfit(fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -1.2), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text('Stroke is the second leading cause of death worldwide. Early detection dramatically changes outcomes.',
              style: GoogleFonts.inter(fontSize: 17, color: Colors.white.withValues(alpha: 0.65), height: 1.7), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 64),
          // Stats grid
          AnimatedBuilder(animation: _ctrl, builder: (context, _) {
            final v = Curves.easeOutCubic.transform(_ctrl.value);
            return Wrap(spacing: 20, runSpacing: 20, alignment: WrapAlignment.center,
              children: stats.map((s) => SizedBox(
                width: w > 900 ? (w - 48 - 60) / 4 : w > 600 ? (w - 48 - 20) / 2 : w - 48,
                child: _StatCard(stat: s, progress: v),
              )).toList(),
            );
          }),
          const SizedBox(height: 56),
          // F.A.S.T. banner
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(children: [
              Text.rich(TextSpan(children: [
                TextSpan(text: 'Remember ', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.9))),
                TextSpan(text: 'F.A.S.T.', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.orange400)),
              ])),
              const SizedBox(height: 28),
              Wrap(spacing: 16, runSpacing: 16, alignment: WrapAlignment.center,
                children: [
                  _FastItem('F', 'Face', 'Is one side drooping?'),
                  _FastItem('A', 'Arms', 'Can they raise both arms?'),
                  _FastItem('S', 'Speech', 'Is speech slurred or strange?'),
                  _FastItem('T', 'Time', 'Call 112 immediately!'),
                ].map((item) => SizedBox(
                  width: w > 800 ? (w - 48 - 48 - 48) / 4 : w > 500 ? (w - 48 - 16) / 2 : w - 48,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(children: [
                      Text(item.letter, style: GoogleFonts.outfit(fontSize: 34, fontWeight: FontWeight.w900, color: AppTheme.orange400, height: 1)),
                      const SizedBox(height: 6),
                      Text(item.word, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(item.desc, style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withValues(alpha: 0.55)), textAlign: TextAlign.center),
                    ]),
                  ),
                )).toList(),
              ),
            ]),
          ),
        ]),
      )),
    );
  }
}

class _Stat {
  final int value; final String suffix, label; final Color color;
  const _Stat(this.value, this.suffix, this.label, this.color);
}

class _StatCard extends StatelessWidget {
  final _Stat stat; final double progress;
  const _StatCard({required this.stat, required this.progress});
  @override
  Widget build(BuildContext context) {
    final count = (stat.value * progress).toInt();
    final formatted = count > 999999 ? '${(count / 1000000).toStringAsFixed(1)}M' : count > 999 ? '${(count / 1000).toStringAsFixed(0)}K' : count.toString();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: [
        Text('$formatted${stat.suffix}',
          style: GoogleFonts.outfit(fontSize: 36, fontWeight: FontWeight.w900, color: stat.color, letterSpacing: -1.5, height: 1)),
        const SizedBox(height: 10),
        Text(stat.label, style: GoogleFonts.inter(fontSize: 13, color: Colors.white.withValues(alpha: 0.6), height: 1.5), textAlign: TextAlign.center),
      ]),
    );
  }
}

class _FastItem {
  final String letter, word, desc;
  const _FastItem(this.letter, this.word, this.desc);
}
