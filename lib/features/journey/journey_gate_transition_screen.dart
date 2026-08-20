import 'dart:async';

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
  State<JourneyGateTransitionScreen> createState() =>
      _JourneyGateTransitionScreenState();
}

class _JourneyGateTransitionScreenState
    extends State<JourneyGateTransitionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _finishTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5200),
    );
    Future<void>.delayed(const Duration(milliseconds: 650), () {
      if (mounted) _controller.forward();
    });
    _finishTimer = Timer(const Duration(milliseconds: 6400), _finish);
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
        transitionDuration: const Duration(milliseconds: 500),
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
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final p = _controller.value;
          final frame = _frameFor(p);
          final next = frame < 4 ? frame + 1 : frame;
          final blend = _blendFor(p, frame);

          return Stack(
            fit: StackFit.expand,
            children: [
              _ReferenceStoryboardFrame(
                frame: frame,
                opacity: 1,
                fallbackAsset: widget.backgroundAsset,
              ),
              if (next != frame)
                _ReferenceStoryboardFrame(
                  frame: next,
                  opacity: blend,
                  fallbackAsset: widget.backgroundAsset,
                ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
                  child: Column(
                    children: [
                      const Spacer(),
                      AnimatedOpacity(
                        opacity: p > .88 ? 0 : 1,
                        duration: const Duration(milliseconds: 250),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 620),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xC9141217),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: const Color(0x55FFFFFF)),
                          ),
                          child: Text(
                            p < .20
                                ? 'Deine Reise beginnt, ${widget.name}.'
                                : p < .82
                                    ? 'Das Tor zu deiner neuen Sprache öffnet sich …'
                                    : 'Deine Reise startet.',
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

  int _frameFor(double p) {
    if (p < .18) return 0;
    if (p < .38) return 1;
    if (p < .62) return 2;
    if (p < .82) return 3;
    return 4;
  }

  double _blendFor(double p, int frame) {
    switch (frame) {
      case 0:
        return ((p - .12) / .06).clamp(0.0, 1.0);
      case 1:
        return ((p - .32) / .06).clamp(0.0, 1.0);
      case 2:
        return ((p - .56) / .06).clamp(0.0, 1.0);
      case 3:
        return ((p - .76) / .06).clamp(0.0, 1.0);
      default:
        return 0;
    }
  }
}

class _ReferenceStoryboardFrame extends StatelessWidget {
  final int frame;
  final double opacity;
  final String fallbackAsset;

  const _ReferenceStoryboardFrame({
    required this.frame,
    required this.opacity,
    required this.fallbackAsset,
  });

  static const _sourceWidth = 1536.0;
  static const _sourceHeight = 1024.0;
  static const _cropTop = 70.0;
  static const _cropHeight = 395.0;

  static const List<double> _cropLeft = [0, 318, 630, 942, 1232];
  static const List<double> _cropWidth = [270, 270, 270, 270, 304];

  @override
  Widget build(BuildContext context) {
    final cropLeft = _cropLeft[frame];
    final cropWidth = _cropWidth[frame];

    return Opacity(
      opacity: opacity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final targetW = constraints.maxWidth;
          final targetH = constraints.maxHeight;
          final scaleX = targetW / cropWidth;
          final scaleY = targetH / _cropHeight;

          return ClipRect(
            child: Transform.scale(
              scaleX: scaleX,
              scaleY: scaleY,
              alignment: Alignment.topLeft,
              child: Transform.translate(
                offset: Offset(-cropLeft, -_cropTop),
                child: SizedBox(
                  width: _sourceWidth,
                  height: _sourceHeight,
                  child: Image.asset(
                    'assets/gate_refence.png',
                    width: _sourceWidth,
                    height: _sourceHeight,
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (_, __, ___) => Image.asset(
                      fallbackAsset,
                      width: _sourceWidth,
                      height: _sourceHeight,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
