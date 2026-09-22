import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  static const _portraitFrames = <String>[
    'assets/gate_portrait_1.png',
    'assets/gate_portrait_2.png',
    'assets/gate_portrait_3.png',
    'assets/gate_portrait_4.png',
    'assets/gate_portrait_5.png',
  ];

  static const _landscapeFrames = <String>[
    'assets/gate_landscape_1.png',
    'assets/gate_landscape_2.png',
    'assets/gate_landscape_3.png',
    'assets/gate_landscape_4.png',
    'assets/gate_landscape_5.png',
  ];


  late final AnimationController _controller;
  Timer? _finishTimer;

  @override
  void initState() {
    super.initState();
    // Gate transition is intentionally immersive so landscape artwork can
    // occupy the physical display instead of stopping before Android nav bars.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
    for (final asset in [..._portraitFrames, ..._landscapeFrames]) {
      precacheImage(AssetImage(asset), context);
    }
  }

  @override
  void dispose() {
    _finishTimer?.cancel();
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
          final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;
          final frames = isLandscape ? _landscapeFrames : _portraitFrames;
          final p = _controller.value;
          final frame = _frameFor(p);
          final next = frame < frames.length - 1 ? frame + 1 : frame;
          final blend = _blendFor(p, frame);

          return Stack(
            fit: StackFit.expand,
            children: [
              _GateFrame(
                asset: frames[frame],
                isLandscape: isLandscape,
                opacity: 1,
                frameIndex: frame,
                fallbackAsset: widget.backgroundAsset,
              ),
              if (next != frame)
                _GateFrame(
                  asset: frames[next],
                  isLandscape: isLandscape,
                  opacity: blend,
                  frameIndex: next,
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
  final bool isLandscape;
  final double opacity;
  final int frameIndex;
  final String fallbackAsset;

  const _GateFrame({
    required this.asset,
    required this.isLandscape,
    required this.opacity,
    required this.frameIndex,
    required this.fallbackAsset,
  });

  @override
  Widget build(BuildContext context) {
    // Portrait frames 1-4 were authored with slightly different framing.
    // Keep the architectural gate anchored while the doors open.
    const portraitAlignment = <Alignment>[
      Alignment(0.0, 0.01),
      Alignment(0.0, -0.01),
      Alignment(0.0, -0.01),
      Alignment(0.0, -0.01),
      Alignment.center,
    ];

    final alignment =
        isLandscape ? Alignment.center : portraitAlignment[frameIndex];

    return Opacity(
      opacity: opacity,
      child: SizedBox.expand(
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
          alignment: alignment,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => Image.asset(
            fallbackAsset,
            fit: BoxFit.cover,
            alignment: alignment,
          ),
        ),
      ),
    );
  }
}
