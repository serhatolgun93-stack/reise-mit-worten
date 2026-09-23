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
  // The same gate is used for every language; frames 3 and 4 reveal
  // the selected destination. The transition ends after frame 4.
  String get _destination {
    switch (widget.language.trim().toLowerCase()) {
      case 'türkçe':
      case 'turkish':
      case 'türkisch':
        return 'turkish';
      case 'ελληνικά':
      case 'greek':
      case 'griechisch':
        return 'greek';
      default:
        return 'english';
    }
  }

  List<String> _framesFor(bool isLandscape) {
    final format = isLandscape ? 'landscape' : 'portrait';
    return <String>[
      'assets/gate_${format}_1.png',
      'assets/gate_${format}_2.png',
      'assets/gate_${format}_${_destination}_3.png',
      'assets/gate_${format}_${_destination}_4.png',
    ];
  }

  late final AnimationController _controller;
  Timer? _finishTimer;

  @override
  void initState() {
    super.initState();
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
    for (final asset in <String>{..._framesFor(false), ..._framesFor(true)}) {
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
          final frames = _framesFor(isLandscape);
          final p = _controller.value;
          final frame = _frameFor(p);
          final next = frame < frames.length - 1 ? frame + 1 : frame;
          final blend = _blendFor(p, frame);

          return Stack(
            fit: StackFit.expand,
            children: [
              _GateFrame(
                asset: frames[frame],
                alignment: isLandscape ? Alignment.center : const Alignment(0, -0.01),
                opacity: 1,
                fallbackAsset: widget.backgroundAsset,
              ),
              if (next != frame)
                _GateFrame(
                  asset: frames[next],
                  alignment: isLandscape ? Alignment.center : const Alignment(0, -0.01),
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
    if (p < .27) return 0;
    if (p < .53) return 1;
    if (p < .79) return 2;
    return 3;
  }

  double _blendFor(double p, int frame) {
    switch (frame) {
      case 0:
        return ((p - .22) / .05).clamp(0.0, 1.0);
      case 1:
        return ((p - .48) / .05).clamp(0.0, 1.0);
      case 2:
        return ((p - .74) / .05).clamp(0.0, 1.0);
      default:
        return 0;
    }
  }
}

class _GateFrame extends StatelessWidget {
  final String asset;
  final Alignment alignment;
  final double opacity;
  final String fallbackAsset;

  const _GateFrame({
    required this.asset,
    required this.alignment,
    required this.opacity,
    required this.fallbackAsset,
  });

  @override
  Widget build(BuildContext context) {
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
