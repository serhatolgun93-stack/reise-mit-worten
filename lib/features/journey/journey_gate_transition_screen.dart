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
  static const _frames = <String>[
    'assets/gate_1.png',
    'assets/gate_2.png',
    'assets/gate_3.png',
    'assets/gate_4.png',
    'assets/gate_5.png',
  ];

  late final AnimationController _controller;
  Timer? _finishTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5600),
    );
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (mounted) _controller.forward();
    });
    _finishTimer = Timer(const Duration(milliseconds: 6800), _finish);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final asset in _frames) {
      precacheImage(AssetImage(asset), context);
    }
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
          final next = frame < _frames.length - 1 ? frame + 1 : frame;
          final blend = _blendFor(p, frame);

          return Stack(
            fit: StackFit.expand,
            children: [
              _GateFrame(
                asset: _frames[frame],
                opacity: 1,
                fallbackAsset: widget.backgroundAsset,
              ),
              if (next != frame)
                _GateFrame(
                  asset: _frames[next],
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
    if (p < .20) return 0;
    if (p < .40) return 1;
    if (p < .62) return 2;
    if (p < .82) return 3;
    return 4;
  }

  double _blendFor(double p, int frame) {
    switch (frame) {
      case 0:
        return ((p - .15) / .05).clamp(0.0, 1.0);
      case 1:
        return ((p - .35) / .05).clamp(0.0, 1.0);
      case 2:
        return ((p - .57) / .05).clamp(0.0, 1.0);
      case 3:
        return ((p - .77) / .05).clamp(0.0, 1.0);
      default:
        return 0;
    }
  }
}

class _GateFrame extends StatelessWidget {
  final String asset;
  final double opacity;
  final String fallbackAsset;

  const _GateFrame({
    required this.asset,
    required this.opacity,
    required this.fallbackAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final portrait = constraints.maxHeight >= constraints.maxWidth;

          // The source PNGs contain the explanatory heading above the gate.
          // Push that part outside the viewport and show only the actual gate
          // scene. Portrait keeps more vertical scene; landscape crops tighter.
          final topCropFraction = portrait ? 0.205 : 0.225;

          return ClipRect(
            child: FractionalTranslation(
              translation: Offset(0, -topCropFraction),
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight / (1 - topCropFraction),
                child: Image.asset(
                  asset,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, __, ___) => Image.asset(
                    fallbackAsset,
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
