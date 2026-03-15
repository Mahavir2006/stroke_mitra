/// Stroke Mitra - Landing Screen
/// Full marketing landing page mirroring the React LandingPage component.

import 'package:flutter/material.dart';
import 'widgets/hero_section.dart';
import 'widgets/what_is_section.dart';
import 'widgets/how_it_works_section.dart';
import 'widgets/features_section.dart';
import 'widgets/stats_section.dart';
import 'widgets/cta_section.dart';
import 'widgets/landing_footer.dart';
import 'widgets/landing_nav.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: const [
                HeroSection(),
                WhatIsSection(),
                HowItWorksSection(),
                FeaturesSection(),
                StatsSection(),
                CTASection(),
                LandingFooter(),
              ],
            ),
          ),
          const LandingNav(),
        ],
      ),
    );
  }
}
