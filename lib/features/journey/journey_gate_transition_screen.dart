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

  static const double _sourceWidth = 1536;
  static const double _sourceHeight = 1024;
  static const double _cropTop = 68;
  static const double _cropHeight = 400;

  static const List<double> _cropLeft = [0, 307, 615, 922, 1229];
  static const List<double> _cropWidth = [307, 308, 307, 307, 307];

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

          // Scale the selected reference panel uniformly so one single stage
          // fills the device. Never stretch X/Y independently and never let
          // neighbouring storyboard panels enter the viewport.
          final scale = math.max(targetW / cropWidth, targetH / _cropHeight);
          final scaledCropW = cropWidth * scale;
          final scaledCropH = _cropHeight * scale;
          final extraX = (scaledCropW - targetW) / 2;
          final extraY = (scaledCropH - targetH) / 2;

          final imageW = _sourceWidth * scale;
          final imageH = _sourceHeight * scale;
          final dx = -(cropLeft * scale) - extraX;
          final dy = -(_cropTop * scale) - extraY;

          return ClipRect(
            child: OverflowBox(
              alignment: Alignment.topLeft,
              minWidth: imageW,
              maxWidth: imageW,
              minHeight: imageH,
              maxHeight: imageH,
              child: Transform.translate(
                offset: Offset(dx, dy),
                child: Image.asset(
                  'assets/gate_refence.png',
                  width: imageW,
                  height: imageH,
                  fit: BoxFit.fill,
                  alignment: Alignment.topLeft,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, __, ___) => Image.asset(
                    fallbackAsset,
                    width: targetW,
                    height: targetH,
                    fit: BoxFit.cover,
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
