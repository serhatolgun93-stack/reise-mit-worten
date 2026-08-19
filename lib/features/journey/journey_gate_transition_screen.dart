import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'journey_dashboard_screen.dart';

class JourneyGateTransitionScreen extends StatefulWidget {
  final String name;
  final String language;
  final String flag;
  final String guideName;
  final String guideKey;
  final String backgroundAsset;

  const JourneyGateTransitionScreen({
    super.key,
    required this.name,
    required this.language,
    required this.flag,
    required this.guideName,
    required this.guideKey,
    required this.backgroundAsset,
  });

  @override
  State<JourneyGateTransitionScreen> createState() => _JourneyGateTransitionScreenState();
}

class _JourneyGateTransitionScreenState extends State<JourneyGateTransitionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _finishTimer;

  String get _destinationAsset {
    if (widget.language == 'Türkçe') return 'assets/backgrounds/gate_turkish.jpg';
    if (widget.language == 'Ελληνικά') return 'assets/backgrounds/gate_greek.jpg';
    return 'assets/backgrounds/gate_english.jpg';
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4300),
    );
    Future<void>.delayed(const Duration(milliseconds: 850), () {
      if (mounted) _controller.forward();
    });
    _finishTimer = Timer(const Duration(milliseconds: 5650), _finish);
  }

  @override
  void dispose() {
    _finishTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 550),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: JourneyDashboardScreen(
            name: widget.name,
            language: widget.language,
            flag: widget.flag,
            guideName: widget.guideName,
            guideKey: widget.guideKey,
            backgroundAsset: widget.backgroundAsset,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050507),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final p = Curves.easeInOutCubic.transform(_controller.value);
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                _destinationAsset,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                filterQuality: FilterQuality.high,
                errorBuilder: (_, __, ___) => Image.asset(
                  widget.backgroundAsset,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              _ApprovedGate(progress: p),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
                  child: Column(
                    children: [
                      const Spacer(),
                      AnimatedOpacity(
                        opacity: p > .88 ? 0 : 1,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 560),
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
                          decoration: BoxDecoration(
                            color: const Color(0xC8151318),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: const Color(0x55FFFFFF)),
                          ),
                          child: Text(
                            p < .10
                                ? 'Deine Reise beginnt, ${widget.name}.'
                                : p < .72
                                    ? 'Das Tor zu deiner neuen Sprache öffnet sich …'
                                    : 'Willkommen in ${widget.language}.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ApprovedGate extends StatelessWidget {
  final double progress;

  const _ApprovedGate({required this.progress});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final landscape = size.width > size.height;
    final p = progress.clamp(0.0, 1.0);
    final fade = (1 - ((p - .92) / .08).clamp(0.0, 1.0)).toDouble();
    final angle = p * (math.pi / 2.05);
    final glowIn = ((p - .04) / .12).clamp(0.0, 1.0);
    final glowOut = 1 - ((p - .30) / .20).clamp(0.0, 1.0);
    final glow = (glowIn * glowOut).toDouble();

    return Opacity(
      opacity: fade,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/journey_gate.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
          ),
          LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth;
              final h = c.maxHeight;
              // Keep the door area proportional in portrait and landscape.
              final doorW = landscape ? math.min(w * .55, h * .92) : w * .76;
              final doorH = landscape ? h * .78 : h * .62;
              final left = (w - doorW) / 2;
              final top = landscape ? h * .14 : h * .30;
              final leafW = doorW / 2;

              Widget leaf(bool leftLeaf) {
                return ClipRect(
                  child: Align(
                    alignment: leftLeaf ? Alignment.centerLeft : Alignment.centerRight,
                    widthFactor: .5,
                    child: Image.asset(
                      'assets/journey_gate.png',
                      width: doorW,
                      height: doorH,
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                    ),
                  ),
                );
              }

              return Stack(
                children: [
                  Positioned(
                    left: left,
                    top: top,
                    width: leafW,
                    height: doorH,
                    child: Transform(
                      alignment: Alignment.centerLeft,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, .0015)
                        ..rotateY(-angle),
                      child: leaf(true),
                    ),
                  ),
                  Positioned(
                    left: left + leafW,
                    top: top,
                    width: leafW,
                    height: doorH,
                    child: Transform(
                      alignment: Alignment.centerRight,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, .0015)
                        ..rotateY(angle),
                      child: leaf(false),
                    ),
                  ),
                  if (glow > 0)
                    Positioned(
                      left: w / 2 - 1.5,
                      top: top + doorH * .05,
                      width: 3,
                      height: doorH * .90,
                      child: Opacity(
                        opacity: glow,
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xFFFF4FA5),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xDDFF2E9A),
                                blurRadius: 18,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
